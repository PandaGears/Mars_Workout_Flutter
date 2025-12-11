import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';

class LinearTimerDisplay extends StatelessWidget {
  const LinearTimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        // If in prep, we show the full duration of the NEXT stage (0 progress)
        // If working, we show actual elapsed time.
        final maxDuration = state.currentStage.duration;

        final durationToShow = state.isPrep
            ? maxDuration
            : maxDuration - state.elapsed;

        final secondsDisplay = durationToShow.inSeconds < 0 ? 0 : durationToShow.inSeconds;

        double progress = 0.0;
        if (maxDuration.inSeconds > 0 && !state.isPrep) {
          progress = state.elapsed.inSeconds / maxDuration.inSeconds;
        }

        return Column(
          children: [
            Text(
              '${(secondsDisplay / 60).floor().toString().padLeft(2, '0')}:${(secondsDisplay % 60).toString().padLeft(2, '0')}',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 80,
                fontWeight: FontWeight.w800,
                color: theme.primaryColor,
                height: 1.0,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 24),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: TweenAnimationBuilder<double>(
                  key: ValueKey('work_${state.currentStageIndex}_${state.isPrep}'),
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.linear,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey.shade100,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}