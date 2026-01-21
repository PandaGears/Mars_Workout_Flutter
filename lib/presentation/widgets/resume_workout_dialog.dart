import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/models/workout_session.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/workout_session/workout_session_bloc.dart';
import 'package:mars_workout_app/logic/cubit/workout_video_cubit.dart';
import 'package:mars_workout_app/presentation/screens/workout/workout_page.dart';

class ResumeWorkoutDialog extends StatelessWidget {
  final WorkoutSession session;

  const ResumeWorkoutDialog({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        spacing: 8,
        children: [
          Icon(Icons.fitness_center, color: theme.primaryColor),
          const Text('Resume Workout?'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Woops! Seems that you have an unfinished workout:',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.workout.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timeline, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        session.getProgressDescription(),
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeAgo(session.savedAt),
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<WorkoutSessionBloc>().add(const ClearWorkoutSession());
            Navigator.of(context).pop();
          },
          child: Text('Clear', style: TextStyle(color: Colors.grey.shade600)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _resumeWorkout(context, session);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Resume'),
        ),
      ],
    );
  }

  void _resumeWorkout(BuildContext context, WorkoutSession session) {
    // Create a TimerBloc with the saved state (stages already have countdown stages from saved session)
    final timerBloc = TimerBloc(session.workout.stages);
    
    // Restore the saved state
    timerBloc.add(RestoreTimer(
      currentStageIndex: session.currentStageIndex,
      elapsed: session.elapsed,
    ));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PlanBloc>()),
            BlocProvider.value(value: context.read<WorkoutSessionBloc>()),
            BlocProvider<TimerBloc>.value(value: timerBloc),
            BlocProvider<WorkoutVideoCubit>(create: (_) => WorkoutVideoCubit()),
          ],
          child: WorkoutPage(
            workout: session.workout,
            planDayId: session.planDayId,
            workoutType: session.workoutType,
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
