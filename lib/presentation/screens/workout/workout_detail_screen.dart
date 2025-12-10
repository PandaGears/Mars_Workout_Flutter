import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/workout_model.dart'; //
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_event.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart'; //

class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;
  final String planDayId;

  const WorkoutDetailScreen({super.key, required this.workout, required this.planDayId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(workout.stages),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(workout.title, style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state.isFinished) {
              context.read<PlanBloc>().add(MarkDayAsCompleted(planDayId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Workout Completed!")),
              );
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Visual Progress of Stages
                const _StageSegmentBar(),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade300, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          workout.description, //
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Circular Timer
                const Expanded(child: Center(child: _CircularTimerDisplay())),

                const SizedBox(height: 40),

                // 3. Controls
                const _TimerControls(),
                const SizedBox(height: 24),

                // 4. Next Up Text
                const _StageTracker(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StageSegmentBar extends StatelessWidget {
  const _StageSegmentBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          children: List.generate(state.stages.length, (index) {
            // Determine color based on completion status
            Color color;
            if (index < state.currentStageIndex) {
              color = Colors.green; // Completed
            } else if (index == state.currentStageIndex) {
              color = Colors.blue; // Active
            } else {
              color = Colors.grey.shade300; // Upcoming
            }

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _CircularTimerDisplay extends StatelessWidget {
  const _CircularTimerDisplay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final totalSeconds = state.currentStage.duration.inSeconds; //
        final elapsedSeconds = state.elapsed.inSeconds; //

        // Calculate progress (1.0 = full, 0.0 = empty)
        // We want it to "empty" as time goes on, so we do 1 - (elapsed / total)
        double progress = 1.0;
        if (totalSeconds > 0) {
          progress = 1.0 - (elapsedSeconds / totalSeconds);
        }

        final duration = state.currentStage.duration - state.elapsed;
        final minutes = (duration.inSeconds / 60).floor().toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Circle (Grey track)
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 15,
                color: Colors.grey.shade100,
              ),
              // Progress Circle (Animated)
              // We rotate it -90 degrees (pi/2) so it starts at the top (12 o'clock)
              Transform.rotate(
                angle: -math.pi / 2,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 15,
                  strokeCap: StrokeCap.round, // Rounded ends look nicer
                  color: progress < 0.2 ? Colors.redAccent : Colors.blueAccent, // Turn red when low
                  backgroundColor: Colors.transparent,
                ),
              ),
              // Center Text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.currentStage.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$minutes:$seconds',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFeatures: [FontFeature.tabularFigures()], // Keeps numbers from jumping width
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimerControls extends StatelessWidget {
  const _TimerControls();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating Action Button style for main control
            FloatingActionButton.large(
              onPressed: () {
                if (state.isRunning) {
                  context.read<TimerBloc>().add(PauseTimer());
                } else {
                  context.read<TimerBloc>().add(StartTimer());
                }
              },
              backgroundColor: state.isRunning ? Colors.amber : Colors.blue,
              child: Icon(
                state.isRunning ? Icons.pause : Icons.play_arrow,
                size: 42,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 32),
            // Secondary button for skip
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.skip_next_rounded),
                color: Colors.grey.shade800,
                onPressed: () => context.read<TimerBloc>().add(NextStage()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StageTracker extends StatelessWidget {
  const _StageTracker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state.upcomingStages.isEmpty) {
          return const Center(
            child: Text(
                "Final Stage!",
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)
            ),
          );
        }

        // Show only the immediate next stage to keep UI clean
        final next = state.upcomingStages.first;

        return Column(
          children: [
            const Text(
              "NEXT UP",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              next.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}