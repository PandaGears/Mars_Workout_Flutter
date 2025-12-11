import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WorkoutCompletedScreen extends StatelessWidget {
  final String workoutTitle;
  final int totalMinutes;
  final bool isWeekComplete;
  final bool isPlanComplete;

  const WorkoutCompletedScreen({
    super.key,
    required this.workoutTitle,
    required this.totalMinutes,
    this.isWeekComplete = false,
    this.isPlanComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String titleText;
    String subText;
    Color primaryColor;
    IconData icon;

    if (isPlanComplete) {
      titleText = "PLAN CONQUERED!";
      subText = "You have finished the entire program. Incredible work!";
      primaryColor = Colors.amber;
      icon = Icons.emoji_events_rounded;
    } else if (isWeekComplete) {
      titleText = "WEEK CRUSHED!";
      subText = "Another week down. You're getting stronger.";
      primaryColor = Colors.purple;
      icon = Icons.star_rounded;
    } else {
      titleText = "WORKOUT COMPLETE!";
      subText = "You crushed $workoutTitle.";
      primaryColor = theme.colorScheme.tertiary;
      icon = Icons.check_circle_rounded;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      if (isPlanComplete || isWeekComplete)
                        Lottie.asset('assets/lottie/confetti_animation.json', repeat: false),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 120, color: primaryColor),
                          const SizedBox(height: 32),

                          // Title
                          Text(
                            titleText,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Subtext
                          Text(
                            subText,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // Stats
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text(
                              "Session Time: $totalMinutes mins",
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)..pop()..pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              child: const Text("FINISH"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}