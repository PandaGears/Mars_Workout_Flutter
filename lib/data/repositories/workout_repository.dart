import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';

class WorkoutRepository {
  List<TrainingPlan> getAllPlans() {
    return [_cyclingPlan(), _petePlan(), _kettlebellPlan(), _rowingMixPlan()];
  }

  // --- 1. Cycling Plan (Based on CSS Fitness 12-week structure) ---
  TrainingPlan _cyclingPlan() {
    return TrainingPlan(
      id: 'cycling_12_week',
      title: '12-Week Indoor Cycling Base',
      description: 'Focus on building aerobic base and threshold power. Ideal for winter training.',
      difficulty: 'Intermediate',
      weeks: List.generate(12, (weekIndex) {
        // Progressive overload: increasing duration slightly every week
        int baseDuration = 30 + (weekIndex * 2);

        return PlanWeek(
          weekNumber: weekIndex + 1,
          days: [
            PlanDay(
              id: 'cyc_w${weekIndex}_d1',
              title: 'Day 1: Aerobic Endurance',
              workout: Workout(
                title: 'Zone 2 Steady State',
                description: 'Maintain a conversation pace. Focus on smooth pedaling.',
                stages: [
                  WorkoutStage(name: 'Warm Up', details: 'Easy Spin', duration: Duration(minutes: 5)),
                  WorkoutStage(name: 'Main Set', details: 'Zone 2 / 65% HR', duration: Duration(minutes: baseDuration)),
                  WorkoutStage(name: 'Cool Down', details: 'Easy Spin', duration: Duration(minutes: 5)),
                ],
              ),
            ),
            PlanDay(
              id: 'cyc_w${weekIndex}_d2',
              title: 'Day 2: Threshold Intervals',
              workout: Workout(
                title: '2x10min Sweet Spot',
                description: 'Hard effort but sustainable. 88-93% FTP.',
                stages: [
                  WorkoutStage(name: 'Warm Up', duration: Duration(minutes: 10)),
                  WorkoutStage(name: 'Interval 1', details: 'Sweet Spot Power', duration: Duration(minutes: 10)),
                  WorkoutStage(name: 'Recovery', details: 'Light Spin', duration: Duration(minutes: 5)),
                  WorkoutStage(name: 'Interval 2', details: 'Sweet Spot Power', duration: Duration(minutes: 10)),
                  WorkoutStage(name: 'Cool Down', duration: Duration(minutes: 5)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- 2. The Pete Plan (Beginner Rowing) ---
  TrainingPlan _petePlan() {
    return TrainingPlan(
      id: 'pete_plan_beginner',
      title: 'The Pete Plan (Beginner)',
      description: 'The gold standard for rowing progression. Mix of long steady distance and intervals.',
      difficulty: 'Hard',
      weeks: [
        PlanWeek(
          weekNumber: 1,
          days: [
            PlanDay(
              id: 'pete_w1_d1',
              title: '5000m Single Distance',
              workout: Workout(
                title: '5000m Test/Piece',
                description: 'Record your time. Maintain consistent stroke rate (22-24 spm).',
                stages: [
                  WorkoutStage(name: 'Warm Up', duration: Duration(minutes: 5)),
                  // We use a "dummy" duration for distance pieces, user clicks next when done
                  WorkoutStage(name: '5000m Row', details: 'Aim for consistent splits', duration: Duration(minutes: 25)),
                  WorkoutStage(name: 'Cool Down', duration: Duration(minutes: 5)),
                ],
              ),
            ),
            PlanDay(
              id: 'pete_w1_d2',
              title: '6 x 500m Intervals',
              workout: Workout(
                title: 'Speed Intervals',
                description: 'High intensity. 2min rest between intervals.',
                stages: [
                  WorkoutStage(name: 'Warm Up', duration: Duration(minutes: 10)),
                  ...List.generate(6, (i) => [
                    WorkoutStage(name: '500m Sprint', details: 'Max Effort', duration: Duration(minutes: 2)), // Approx time
                    WorkoutStage(name: 'Rest', details: 'Paddle lightly', duration: Duration(minutes: 2)),
                  ]).expand((i) => i),
                  WorkoutStage(name: 'Cool Down', duration: Duration(minutes: 5)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 3. Kettlebell Program (12 Week) ---
  // Note: Since these are Rep-based, we use Duration(seconds: 0) to indicate "Manual Advance"
  // or a rough time estimate.
  TrainingPlan _kettlebellPlan() {
    return TrainingPlan(
      id: 'kettlebell_12_week',
      title: '12-Week Kettlebell Strength',
      description: 'Functional strength using EMOM (Every Minute on the Minute) and circuits.',
      difficulty: 'Advanced',
      weeks: List.generate(12, (index) =>
          PlanWeek(
            weekNumber: index + 1,
            days: [
              PlanDay(
                id: 'kb_w${index}_d1',
                title: 'Day 1: The Swing',
                workout: Workout(
                  title: 'Swing Ladders',
                  description: 'Perform reps, then rest for the remainder of the interval or click next.',
                  stages: [
                    WorkoutStage(name: 'Warm Up', details: 'Halos & Bridges', duration: Duration(minutes: 5)),
                    WorkoutStage(name: 'Set 1', details: '10 Two-Handed Swings', duration: Duration(seconds: 45)),
                    WorkoutStage(name: 'Rest', duration: Duration(seconds: 30)),
                    WorkoutStage(name: 'Set 2', details: '15 Two-Handed Swings', duration: Duration(seconds: 45)),
                    WorkoutStage(name: 'Rest', duration: Duration(seconds: 30)),
                    WorkoutStage(name: 'Set 3', details: '20 Two-Handed Swings', duration: Duration(seconds: 60)),
                    WorkoutStage(name: 'Cool Down', details: 'Stretching', duration: Duration(minutes: 5)),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  // --- 4. Hydrow / Rowing Mix ---
  TrainingPlan _rowingMixPlan() {
    return TrainingPlan(
      id: 'hydrow_mix',
      title: 'Rowing Variety Mix',
      description: 'Short, effective rowing workouts focused on HIIT and technique.',
      difficulty: 'Beginner',
      weeks: [
        PlanWeek(
          weekNumber: 1,
          days: [
            PlanDay(
              id: 'row_mix_1',
              title: '20min Sweat',
              workout: Workout(
                title: 'Pyramid Intervals',
                description: 'Stroke rate variation: 22, 24, 26, 24, 22 spm.',
                stages: [
                  WorkoutStage(name: 'Warm Up', duration: Duration(minutes: 3)),
                  WorkoutStage(name: '22 SPM', duration: Duration(minutes: 2)),
                  WorkoutStage(name: '24 SPM', duration: Duration(minutes: 2)),
                  WorkoutStage(name: '26 SPM', duration: Duration(minutes: 2)),
                  WorkoutStage(name: '24 SPM', duration: Duration(minutes: 2)),
                  WorkoutStage(name: '22 SPM', duration: Duration(minutes: 2)),
                  WorkoutStage(name: 'Cool Down', duration: Duration(minutes: 3)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}