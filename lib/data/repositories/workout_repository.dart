import 'package:mars_workout_app/data/models/training_plan.dart';
import 'package:mars_workout_app/data/models/workout_model.dart'; //

class WorkoutRepository {
  // Method to fetch all training plans
  List<TrainingPlan> getAllPlans() {
    return [_cssFitness12WeekPlan(), _cyclingPlan(), _rowingPlan(), _kettlebellPlan(), _petePlan()]; //
  }

  TrainingPlan _cssFitness12WeekPlan() {
    return TrainingPlan(
      id: 'css_12_week',
      title: '12-Week Indoor Cycling Plan',
      description: 'A 12-week progression from CSS Fitness designed to improve speed, power, and climbing ability.',
      difficulty: 'Advanced',
      weeks: List.generate(12, (index) {
        int weekNum = index + 1;

        // Determine Phase
        bool isBasePhase = weekNum >= 1 && weekNum <= 4;
        bool isBuildPhase = weekNum >= 5 && weekNum <= 8;
        bool isPeakPhase = weekNum >= 9 && weekNum <= 11;
        bool isTaperPhase = weekNum == 12;

        List<PlanDay> days = [];

        // Define Workouts based on phase
        if (isBasePhase || isTaperPhase) {
          // Weeks 1-4 & 12: 3x 30min, 1x 60min
          days = [
            _buildDay(weekNum, 1, 'Speed Intervals (30m)', _speedIntervalsWorkout(isShort: true)),
            _buildDay(weekNum, 3, 'Ladder Intervals (30m)', _ladderIntervalsWorkout(isShort: true)),
            _buildDay(weekNum, 5, 'Climbing Bursts (30m)', _climbingBurstsWorkout(isShort: true)),
            _buildDay(weekNum, 7, 'Sunday Endurance (60m)', _sundayRideWorkout()),
          ];
        } else if (isBuildPhase) {
          // Weeks 5-8: 4x 60min
          days = [
            _buildDay(weekNum, 1, 'Speed Intervals (60m)', _speedIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 3, 'Ladder Intervals (60m)', _ladderIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 5, 'Climbing Bursts (60m)', _climbingBurstsWorkout(isShort: false)),
            _buildDay(weekNum, 7, 'Sunday Endurance (60m)', _sundayRideWorkout()),
          ];
        } else if (isPeakPhase) {
          // Weeks 9-11: 5x 60min (Adds "Choice" workout)
          days = [
            _buildDay(weekNum, 1, 'Speed Intervals (60m)', _speedIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 2, 'Ladder Intervals (60m)', _ladderIntervalsWorkout(isShort: false)),
            _buildDay(weekNum, 4, 'Climbing Bursts (60m)', _climbingBurstsWorkout(isShort: false)),
            _buildDay(weekNum, 5, 'Power Hour (Hard Choice)', _powerHourWorkout()),
            _buildDay(weekNum, 7, 'Sunday Endurance (60m)', _sundayRideWorkout()),
          ];
        }

        return PlanWeek(weekNumber: weekNum, days: days);
      }),
    );
  }

  // --- Helpers for CSS Plan ---

  PlanDay _buildDay(int week, int dayNum, String title, Workout workout) {
    return PlanDay(id: 'css_w${week}_d$dayNum', title: title, workout: workout);
  }

  Workout _speedIntervalsWorkout({required bool isShort}) {
    return Workout(
      title: isShort ? 'Speed Intervals (30m)' : 'Speed Intervals (60m)',
      description: 'High-cadence efforts to improve leg speed and cardiovascular efficiency.',
      stages: [
        WorkoutStage(
          name: 'Warm-up',
          duration: Duration(minutes: isShort ? 5 : 10),
          description: 'Easy spin, gradually increasing cadence to 90+ RPM.',
        ),
        // Main Set: Repeated sprints
        // Short: 4 reps. Long: 8 reps.
        for (int i = 0; i < (isShort ? 4 : 8); i++) ...[
          const WorkoutStage(name: 'Tempo Effort', duration: Duration(minutes: 2), description: 'Hold 80% effort. Strong but sustainable.'),
          const WorkoutStage(name: 'Max Sprint', duration: Duration(seconds: 30), description: '100% Effort! Max cadence. Go all out.'),
          const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 2), description: 'Easy spin to recover heart rate.'),
        ],
        const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Light resistance, bring heart rate down.'),
      ],
    );
  }

  Workout _ladderIntervalsWorkout({required bool isShort}) {
    return Workout(
      title: isShort ? 'Ladder Intervals (30m)' : 'Ladder Intervals (60m)',
      description: 'Progressively longer intervals followed by progressively shorter ones.',
      stages: [
        const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Steady spin.'),
        // Ladder: 1 - 2 - 3 - 2 - 1
        ...[1, 2, 3, 2, 1]
            .map(
              (min) => [
                WorkoutStage(
                  name: '$min min Effort',
                  duration: Duration(minutes: min),
                  description: 'Threshold effort (Zone 4). Push hard.',
                ),
                WorkoutStage(name: 'Rest', duration: Duration(minutes: 1), description: 'Easy spin recovery.'),
              ],
            )
            .expand((i) => i),
        // If Long version, repeat the ladder
        if (!isShort) ...[
          const WorkoutStage(name: 'Set Break', duration: Duration(minutes: 5), description: 'Mid-workout recovery.'),
          ...[1, 2, 3, 2, 1]
              .map(
                (min) => [
                  WorkoutStage(
                    name: '$min min Effort',
                    duration: Duration(minutes: min),
                    description: 'Threshold effort (Zone 4).',
                  ),
                  const WorkoutStage(name: 'Rest', duration: Duration(minutes: 1), description: 'Easy spin.'),
                ],
              )
              .expand((i) => i),
        ],
        const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Easy spinning.'),
      ],
    );
  }

  Workout _climbingBurstsWorkout({required bool isShort}) {
    return Workout(
      title: isShort ? 'Climbing Bursts (30m)' : 'Climbing Bursts (60m)',
      description: 'Simulated hill attacks. High resistance, low cadence strength work.',
      stages: [
        const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Start with low resistance, slowly adding gear.'),
        // Short: 5 bursts. Long: 10 bursts.
        for (int i = 0; i < (isShort ? 5 : 10); i++) ...[
          const WorkoutStage(name: 'Climb Base', duration: Duration(minutes: 3), description: 'Moderate resistance (70 RPM). Feel the "hill".'),
          const WorkoutStage(name: 'Attack!', duration: Duration(seconds: 30), description: 'Max resistance! Stand up and attack the gradient.'),
          const WorkoutStage(name: 'Descend', duration: Duration(minutes: 1, seconds: 30), description: 'Low resistance, high cadence recovery.'),
        ],
        const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Flush the legs out.'),
      ],
    );
  }

  Workout _powerHourWorkout() {
    return Workout(
      title: 'Power Hour',
      description: 'Sustained sweet-spot effort to build mental and physical resilience.',
      stages: [
        const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Gradual build.'),
        const WorkoutStage(name: 'Sweet Spot 1', duration: Duration(minutes: 15), description: '88-93% FTP. Uncomfortably comfortable.'),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 5), description: 'Spin easy.'),
        const WorkoutStage(name: 'Sweet Spot 2', duration: Duration(minutes: 15), description: 'Hold the effort! Don\'t fade.'),
        const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 15), description: 'Relaxed spin.'),
      ],
    );
  }

  Workout _sundayRideWorkout() {
    return Workout(
      title: 'Sunday Endurance',
      description: 'Long, steady distance ride. Keep heart rate in Zone 2.',
      stages: [
        const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Ease into the ride.'),
        const WorkoutStage(name: 'Steady State', duration: Duration(minutes: 40), description: 'Zone 2 heart rate. Conversational pace. Focus on efficiency.'),
        const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: 'Easy spin to finish.'),
      ],
    );
  }

  TrainingPlan _cyclingPlan() {
    return TrainingPlan(
      id: 'cycling_12_week',
      title: '12-Week Indoor Cycling Plan',
      description: 'A comprehensive plan for building cycling endurance and power.',
      difficulty: 'Intermediate',
      weeks: List.generate(12, (weekIndex) {
        return PlanWeek(
          weekNumber: weekIndex + 1,
          days: List.generate(3, (dayIndex) {
            return PlanDay(
              id: 'cycling_w${weekIndex + 1}_d${dayIndex + 1}',
              title: 'Session ${dayIndex + 1}',
              workout: Workout(
                title: 'Endurance Ride',
                description: 'Focus on maintaining a steady pace to build aerobic base.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Spin easy at 80-90 RPM. Gradually increase resistance every 2 mins.'),
                  const WorkoutStage(name: 'Main Set', duration: Duration(minutes: 30), description: 'Hold Zone 2/3 power. Focus on smooth pedal strokes and consistent breathing.'),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10), description: 'Remove resistance and spin legs out to recover.'),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  TrainingPlan _rowingPlan() {
    return TrainingPlan(
      id: 'hydrow_rowing_mix',
      title: 'Hydrow Rowing Workouts',
      description: 'A collection of rowing workouts for all fitness levels.',
      difficulty: 'Beginner',
      weeks: [
        PlanWeek(
          weekNumber: 1,
          days: [
            PlanDay(
              id: 'rowing_w1_d1',
              title: 'Intro to Rowing',
              workout: Workout(
                title: 'Technique Focus',
                description: 'Learn the basics of rowing form with drill work.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Pick drill: Arms only, then Body Over, then Half Slide.'),
                  const WorkoutStage(name: 'Drills', duration: Duration(minutes: 15), description: 'Pause drills at the finish (2 seconds). Focus on handle height.'),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Light paddling at 18 strokes per minute.'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  TrainingPlan _kettlebellPlan() {
    return TrainingPlan(
      id: 'kettlebell_12_week',
      title: '12-Week Kettlebell Program',
      description: 'Build strength and power with this kettlebell program.',
      difficulty: 'Intermediate',
      weeks: List.generate(12, (weekIndex) {
        return PlanWeek(
          weekNumber: weekIndex + 1,
          days: List.generate(3, (dayIndex) {
            return PlanDay(
              id: 'kettlebell_w${weekIndex + 1}_d${dayIndex + 1}',
              title: 'Full Body Strength',
              workout: Workout(
                title: 'Kettlebell Swings & Goblet Squats',
                description: 'Focus on explosive power and core stability.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10), description: 'Halo, Slingshot, and bodyweight lunges to mobilize joints.'),
                  const WorkoutStage(name: 'Main Circuit', duration: Duration(minutes: 20), description: 'Ladder: 5 Swings/5 Squats, rest 30s. Then 10/10. Then 15/15. Repeat.'),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Static stretching: Focus on hamstrings and hip flexors.'),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  TrainingPlan _petePlan() {
    return TrainingPlan(
      id: 'pete_plan_beginner',
      title: 'The Pete Plan (Beginner)',
      description: 'A popular rowing plan for building a solid aerobic base.',
      difficulty: 'Beginner',
      weeks: [
        PlanWeek(
          weekNumber: 1,
          days: [
            PlanDay(
              id: 'pete_w1_d1',
              title: '5000m Intervals',
              workout: Workout(
                title: '5000m @ 22-24 spm',
                description: 'Focus on long, powerful strokes and consistent splits.',
                stages: [
                  const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Build from light pressure to steady state pressure.'),
                  const WorkoutStage(name: '5000m Row', duration: Duration(minutes: 20), description: 'Maintain a consistent split. Rate 22-24 spm. Do not sprint.'),
                  const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Paddle lightly to bring heart rate down.'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
