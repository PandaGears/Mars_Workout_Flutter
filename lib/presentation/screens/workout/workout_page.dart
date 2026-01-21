import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/core/services/audio_service.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/models/workout_session.dart';
import 'package:mars_workout_app/data/repositories/workouts/workout_repository.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/workout_session/workout_session_bloc.dart';
import 'package:mars_workout_app/presentation/screens/workout/completion/workout_completion_screen.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_screen.dart';

class WorkoutPage extends StatefulWidget {
  final Workout workout;
  final String planDayId;
  final WorkoutType workoutType;

  const WorkoutPage({super.key, required this.workout, required this.planDayId, required this.workoutType});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Save workout state when app goes to background or paused
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveWorkoutSession();
    }
  }

  void _saveWorkoutSession() {
    final timerState = context.read<TimerBloc>().state;
    
    // Only save if workout is not finished
    if (!timerState.isFinished) {
      final session = WorkoutSession(
        workout: widget.workout,
        planDayId: widget.planDayId,
        workoutType: widget.workoutType,
        currentStageIndex: timerState.currentStageIndex,
        elapsed: timerState.elapsed,
        isRunning: timerState.isRunning,
        savedAt: DateTime.now(),
      );
      
      context.read<WorkoutSessionBloc>().add(SaveWorkoutSession(session));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cache plans once to avoid repeated expensive calls
    final allPlans = WorkoutRepository().getAllPlans();

    return MultiBlocListener(
        listeners: [
          // Save workout state periodically during workout
          BlocListener<TimerBloc, TimerState>(
            listenWhen: (previous, current) {
              // Save every 5 seconds or when stage changes
              return current.elapsed.inSeconds % 5 == 0 || 
                     previous.currentStageIndex != current.currentStageIndex;
            },
            listener: (context, state) {
              if (!state.isFinished) {
                _saveWorkoutSession();
              }
            },
          ),
          // Handle workout completion
          BlocListener<TimerBloc, TimerState>(
            listener: (context, state) {
              // 2. Workout Finished Logic
              if (state.isFinished) {
            // Clear the saved session since workout is complete
            context.read<WorkoutSessionBloc>().add(const ClearWorkoutSession());
            
            context.read<PlanBloc>().add(MarkDayAsCompleted(widget.planDayId));

            final planBlocState = context.read<PlanBloc>().state;
            final completedIds = Set<String>.from(planBlocState.completedDayIds);
            completedIds.add(widget.planDayId);

            bool isWeekFinished = false;
            bool isPlanFinished = false;

            // --- FIX: Get the active plan ID for THIS workout type ---
            String? activePlanId = planBlocState.activePlans[widget.workoutType.toString()];

            if (activePlanId != null) {
              try {
                final currentPlan = allPlans.firstWhere((p) => p.id == activePlanId);

                isPlanFinished = currentPlan.weeks.every((week) => week.days.every((day) => completedIds.contains(day.id)));

                if (!isPlanFinished) {
                  for (var week in currentPlan.weeks) {
                    if (week.days.any((d) => d.id == widget.planDayId)) {
                      isWeekFinished = week.days.every((d) => completedIds.contains(d.id));
                      break;
                    }
                  }
                  if (isWeekFinished) {
                    SoundService().playWeekComplete();
                  } else {
                    SoundService().playWorkoutComplete();
                  }
                } else {
                  SoundService().playTrainingPlanComplete();
                }
              } catch (e) {
                print("Plan lookup error: $e");
              }
            }

            int totalMins = 0;
            for (var s in widget.workout.stages) {
              totalMins += s.duration.inMinutes;
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutCompletedScreen(workoutTitle: widget.workout.title, totalMinutes: totalMins, isWeekComplete: isWeekFinished, isPlanComplete: isPlanFinished),
              ),
            );
              }
            },
          ),
      ],
      child: WorkoutScreen(workout: widget.workout, planDayId: widget.planDayId, workoutType: widget.workoutType),
    );
  }
}
