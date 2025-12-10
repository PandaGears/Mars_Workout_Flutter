import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import '../../models/training_plan.dart';
import '../../models/workout_model.dart';
import '../misc/misc_repository.dart';

// ==============================================================================
// 1. DISCOVERY 30KM BEGINNER PLAN (Corrected 7-Day PDF Schedule)
// ==============================================================================

TrainingPlan discovery30kmBeginnerPlan() {
  return TrainingPlan(
    id: 'discovery_30km_beginner',
    title: 'Discovery: Beginner 30km',
    description: 'The official 8-week Discovery Vitality programme. Designed to take you from zero to a comfortable 30km race finish.',
    difficulty: 'Beginner',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(8, (index) {
      int weekNum = index + 1;

      // Default Placeholder Workouts
      Workout tuesdayRide = _restDayWorkout();
      Workout thursdayRide = _restDayWorkout();
      Workout saturdayRide = _restDayWorkout();
      Workout sundayRide = _discRecoveryRide(); // Almost always 30m recovery

      // --- WEEKLY SCHEDULE FROM PDF ---

      if (weekNum == 1) {
        // Week 1: Base
        tuesdayRide = _discBaseRide(30);
        thursdayRide = _discBaseRide(40);
        saturdayRide = _discBaseRide(60);
        sundayRide = _discRecoveryRide();
      }
      else if (weekNum == 2) {
        // Week 2: Build
        tuesdayRide = _discIMTGRide(30);
        thursdayRide = _discBaseRide(45);
        saturdayRide = _discBaseRide(70); // 1h 10m
        sundayRide = _discRecoveryRide();
      }
      else if (weekNum == 3) {
        // Week 3: Intervals Start
        tuesdayRide = _discIMTGRide(40);
        thursdayRide = _discIntervals(15, 4, 2, 4, 10); // 4x2min intervals
        saturdayRide = _discBaseRide(70); // 1h 10m
        sundayRide = _discRecoveryRide();
      }
      else if (weekNum == 4) {
        // Week 4: Volume
        tuesdayRide = _discBaseRide(50);
        thursdayRide = _discIntervals(15, 4, 3, 4, 10); // 4x3min intervals
        saturdayRide = _discBaseRide(80); // 1h 20m
        sundayRide = _discRecoveryRide();
      }
      else if (weekNum == 5) {
        // Week 5: Climbing
        tuesdayRide = _discBaseRide(60);
        thursdayRide = _discHillIntervals(20, 2, 8, 10); // 2x8min Hills
        saturdayRide = _discBaseRide(90); // 1h 30m
        sundayRide = _discRecoveryRide();
      }
      else if (weekNum == 6) {
        // Week 6: Peak Climbing
        tuesdayRide = _discHillIntervals(20, 3, 6, 10); // 3x6min Hills
        thursdayRide = _discBaseRide(60); // 1h Tempo
        saturdayRide = _discBaseRide(100); // 1h 40m (Peak Long Ride)
        sundayRide = _discRecoveryRide();
      }
      else if (weekNum == 7) {
        // Week 7: Speed & Taper Start
        tuesdayRide = _discIntervals(20, 5, 2, 5, 20); // 5x2min Z4
        thursdayRide = _discBaseRide(60);
        saturdayRide = _discBaseRide(75); // 1h 15m (Tapering down)
        sundayRide = _discRecoveryRide();
      }
      else if (weekNum == 8) {
        // Week 8: RACE WEEK
        tuesdayRide = _discIntervals(20, 4, 2, 5, 10); // Sharpening intervals
        thursdayRide = _discPrimingRide(); // 30m with bursts
        saturdayRide = _restDayWorkout(); // Total rest before race
        sundayRide = _discRaceDayWorkout(); // RACE DAY
      }

      // --- 7-DAY STRUCTURE ---
      // Mon/Wed/Fri are always REST in this plan
      return PlanWeek(
        weekNumber: weekNum,
        days: [
          PlanDay(id: 'disc_w${weekNum}_d1', title: 'Rest Day', workout: _restDayWorkout()),
          PlanDay(id: 'disc_w${weekNum}_d2', title: 'Training Ride', workout: tuesdayRide),
          PlanDay(id: 'disc_w${weekNum}_d3', title: 'Rest Day', workout: _restDayWorkout()),
          PlanDay(id: 'disc_w${weekNum}_d4', title: 'Training Ride', workout: thursdayRide),
          PlanDay(id: 'disc_w${weekNum}_d5', title: 'Rest Day', workout: _restDayWorkout()),
          PlanDay(id: 'disc_w${weekNum}_d6', title: weekNum == 8 ? 'Rest Day' : 'Long Ride', workout: saturdayRide),
          PlanDay(id: 'disc_w${weekNum}_d7', title: weekNum == 8 ? 'RACE DAY' : 'Recovery Ride', workout: sundayRide),
        ],
      );
    }),
  );
}

// --- DISCOVERY WORKOUT HELPERS ---

Workout _restDayWorkout() {
  return const Workout(
    title: 'Rest Day',
    description: 'Rest is vital. Mark this day as complete to stay on track.',
    stages: [
      WorkoutStage(name: 'Resting...', duration: Duration(seconds: 1), description: 'Relax.'),
    ],
  );
}

Workout _discBaseRide(int mins) {
  return Workout(
    title: 'Base Ride ($mins mins)',
    description: 'Zone 2/3. Keep cadence >85 RPM. Comfortable, conversational pace.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Spin easy.'),
      WorkoutStage(name: 'Steady Ride', duration: Duration(minutes: mins - 10), description: 'Zone 2/3. Smooth circles.'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Easy spin.'),
    ],
  );
}

Workout _discRecoveryRide() {
  return const Workout(
    title: 'Recovery Ride (30m)',
    description: 'Zone 2 ONLY. Very easy spin to flush out legs. >85 RPM.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5), description: 'Very easy.'),
      WorkoutStage(name: 'Recovery Spin', duration: Duration(minutes: 20), description: 'Zone 2. No resistance.'),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _discIMTGRide(int mins) {
  return Workout(
    title: 'IMTG Ride ($mins mins)',
    description: 'FASTED RIDE (No breakfast). Teaches body to burn fat. Keep intensity LOW (Zone 2).',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Fasted Zone 2', duration: Duration(minutes: mins), description: 'Steady pace. Do not spike HR.'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _discIntervals(int warm, int sets, int work, int rest, int cool) {
  return Workout(
    title: 'Intervals ($sets x $work min)',
    description: 'High intensity efforts to build speed and power.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: warm), description: 'Progressive warmup.'),
      for(int i=0; i<sets; i++) ...[
        WorkoutStage(name: 'Hard Effort', duration: Duration(minutes: work), description: 'Zone 4/5. High gear, low cadence (45-50rpm) or high speed.'),
        WorkoutStage(name: 'Recovery', duration: Duration(minutes: rest), description: 'Spin easy.'),
      ],
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: cool)),
    ],
  );
}

Workout _discHillIntervals(int warm, int sets, int work, int cool) {
  return Workout(
    title: 'Hill Repeats ($sets x $work min)',
    description: 'Seated climbing strength. Keep cadence low (50-65 RPM).',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: warm)),
      for(int i=0; i<sets; i++) ...[
        WorkoutStage(name: 'Seated Climb', duration: Duration(minutes: work), description: 'Moderate gradient. Stay seated. Grind it out.'),
        WorkoutStage(name: 'Recovery', duration: Duration(minutes: 8), description: 'Roll down/Spin easy.'),
      ],
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: cool)),
    ],
  );
}

Workout _discPrimingRide() {
  return const Workout(
    title: 'Race Priming (30m)',
    description: 'Short ride with bursts to wake up the legs.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'Accel 1', duration: Duration(minutes: 2), description: 'High gear, low cadence.'),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4)),
      WorkoutStage(name: 'Accel 2', duration: Duration(minutes: 2), description: 'Pick up speed.'),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 4)),
      WorkoutStage(name: 'Accel 3', duration: Duration(minutes: 2), description: 'Race pace feeling.'),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 6)),
    ],
  );
}

Workout _discRaceDayWorkout() {
  return const Workout(
    title: '30KM RACE',
    description: 'Race Day! Start steady, finish strong.',
    stages: [
      WorkoutStage(name: 'The Race', duration: Duration(minutes: 90), description: 'Go get that medal!'),
    ],
  );
}

// ==============================================================================
// 2. BICYCLE NETWORK 150KM PLAN (Existing)
// ==============================================================================

TrainingPlan bicycleNetwork150kmPlan() {
  return TrainingPlan(
    id: 'bn_150km_classic',
    title: 'Bicycle Network: 150km Classic',
    description: '12-week guide for 150km endurance. Focuses on Sweet Spot and long miles.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(12, (index) {
      int weekNum = index + 1;
      List<PlanDay> days = [];

      if (weekNum <= 4) {
        int enduranceMins = 90 + ((weekNum - 1) * 15);
        days = [
          buildDay(weekNum, 2, 'Aerobic Ride (60m)', _bnAerobicRide(60)),
          buildDay(weekNum, 4, weekNum == 3 ? 'Tempo Ride (60m)' : 'Aerobic Ride (60m)',
              weekNum == 3 ? _bnTempoRide(60) : _bnAerobicRide(60)),
          buildDay(weekNum, 7, 'Endurance Ride (${enduranceMins}m)', _bnEnduranceRide(enduranceMins)),
        ];
      } else if (weekNum <= 8) {
        bool isSweetSpotWeek = weekNum >= 6;
        int enduranceMins = 210 + ((weekNum - 5) * 15);
        days = [
          buildDay(weekNum, 2, 'Aerobic Ride (2h)', _bnAerobicRide(120)),
          buildDay(weekNum, 4, isSweetSpotWeek ? 'Sweet Spot Blocks' : 'Tempo Ride',
              isSweetSpotWeek ? _bnSweetSpotWorkout(weekNum) : _bnTempoRide(75)),
          buildDay(weekNum, 7, 'Endurance Ride ($enduranceMins m)', _bnEnduranceRide(enduranceMins)),
        ];
      } else {
        if (weekNum == 12) {
          days = [
            buildDay(weekNum, 3, 'Taper: Aerobic (45m)', _bnAerobicRide(45)),
            buildDay(weekNum, 7, 'EVENT DAY: 150KM', _bnEnduranceRide(360)),
          ];
        } else {
          days = [
            buildDay(weekNum, 2, 'Sweet Spot Intervals', _bnSweetSpotWorkout(weekNum)),
            buildDay(weekNum, 4, 'High Cadence Drills', _bnHighCadenceDrills()),
            buildDay(weekNum, 7, 'Long Endurance Ride', _bnEnduranceRide(weekNum == 10 ? 360 : 270)),
          ];
        }
      }
      return PlanWeek(weekNumber: weekNum, days: days);
    }),
  );
}

// --- BN Workout Generators ---

Workout _bnAerobicRide(int totalMinutes) {
  return Workout(
    title: 'Aerobic Ride ($totalMinutes mins)',
    description: 'Ride at a pace you could ride all day (3-4/10 effort).',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Aerobic Base', duration: Duration(minutes: totalMinutes - 10), description: 'Zone 2: Conversational pace.'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _bnTempoRide(int totalMinutes) {
  return Workout(
    title: 'Tempo Ride ($totalMinutes mins)',
    description: 'Harder than aerobic (5-6/10 effort). Breathing becomes audible.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'Tempo Effort', duration: Duration(minutes: totalMinutes - 15), description: 'Zone 3: "Comfortably Hard".'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout _bnEnduranceRide(int totalMinutes) {
  return Workout(
    title: 'Endurance Ride (${(totalMinutes/60).toStringAsFixed(1)} hrs)',
    description: 'Long steady distance. Build mental and physical stamina.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'The Long Ride', duration: Duration(minutes: totalMinutes - 20), description: 'Zone 2: Stay consistent.'),
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout _bnSweetSpotWorkout(int week) {
  int reps = week >= 9 ? 6 : 6;
  int workMin = week >= 9 ? 8 : 5;
  int restMin = week >= 9 ? 5 : 7;

  return Workout(
    title: 'Sweet Spot Blocks',
    description: 'Effort 6-7/10. "Sweet Spot" is just below your threshold.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 15)),
      for(int i=0; i<reps; i++) ...[
        WorkoutStage(name: 'Sweet Spot Block', duration: Duration(minutes: workMin), description: 'Strong effort.'),
        WorkoutStage(name: 'Recovery', duration: Duration(minutes: restMin), description: 'Easy spinning.'),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout _bnHighCadenceDrills() {
  return Workout(
    title: 'High Cadence Drills',
    description: '1 min fast spin, 4 min recovery. Improves efficiency.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 15)),
      for(int i=0; i<8; i++) ...[
        const WorkoutStage(name: 'Spin-Up!', duration: Duration(minutes: 1), description: '100+ RPM.'),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 4), description: 'Easy gear.'),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

// ==============================================================================
// 3. CSS FITNESS (Legacy Plans)
// ==============================================================================

TrainingPlan cssFitness12WeekPlan() {
  return TrainingPlan(
    id: 'css_12_week',
    title: 'CSS Fitness: 12-Week Indoor',
    description: 'A 12-week progression designed to improve speed, power, and climbing ability.',
    difficulty: 'Advanced',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(12, (index) {
      int weekNum = index + 1;
      bool isBasePhase = weekNum >= 1 && weekNum <= 4;
      bool isBuildPhase = weekNum >= 5 && weekNum <= 8;
      bool isTaperPhase = weekNum == 12;

      List<PlanDay> days = [];

      if (isBasePhase || isTaperPhase) {
        days = [
          buildDay(weekNum, 1, 'Speed Intervals (30m)', speedIntervalsWorkout(isShort: true)),
          buildDay(weekNum, 3, 'Ladder Intervals (30m)', ladderIntervalsWorkout(isShort: true)),
          buildDay(weekNum, 5, 'Climbing Bursts (30m)', climbingBurstsWorkout(isShort: true)),
          buildDay(weekNum, 7, 'Sunday Endurance (60m)', sundayRideWorkout()),
        ];
      } else if (isBuildPhase) {
        days = [
          buildDay(weekNum, 1, 'Speed Intervals (60m)', speedIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 3, 'Ladder Intervals (60m)', ladderIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 5, 'Climbing Bursts (60m)', climbingBurstsWorkout(isShort: false)),
          buildDay(weekNum, 7, 'Sunday Endurance (60m)', sundayRideWorkout()),
        ];
      } else { // Peak
        days = [
          buildDay(weekNum, 1, 'Speed Intervals (60m)', speedIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 2, 'Ladder Intervals (60m)', ladderIntervalsWorkout(isShort: false)),
          buildDay(weekNum, 4, 'Climbing Bursts (60m)', climbingBurstsWorkout(isShort: false)),
          buildDay(weekNum, 5, 'Power Hour (Hard Choice)', powerHourWorkout()),
          buildDay(weekNum, 7, 'Sunday Endurance (60m)', sundayRideWorkout()),
        ];
      }
      return PlanWeek(weekNumber: weekNum, days: days);
    }),
  );
}

List<Workout> getPowerHourOptions() {
  return [powerHourWorkout(), powerHourThreshold(), powerHourSteady()];
}

Workout speedIntervalsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Speed Intervals (30m)' : 'Speed Intervals (60m)',
    description: 'High-cadence efforts to improve leg speed.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: isShort ? 5 : 10), description: 'Spin Easy.'),
      for (int i = 0; i < (isShort ? 4 : 8); i++) ...[
        const WorkoutStage(name: 'Tempo Effort', duration: Duration(minutes: 2), description: '80% Effort.'),
        const WorkoutStage(name: 'Max Sprint', duration: Duration(seconds: 30), description: '100% Effort!'),
        const WorkoutStage(name: 'Recovery', duration: Duration(minutes: 2), description: 'Recover.'),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5), description: 'Spin Easy.'),
    ],
  );
}

Workout ladderIntervalsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Ladder Intervals (30m)' : 'Ladder Intervals (60m)',
    description: 'Progressively longer intervals.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      ...[1, 2, 3, 2, 1].map((min) => [
        WorkoutStage(name: '$min min Effort', duration: Duration(minutes: min), description: '90% Effort.'),
        const WorkoutStage(name: 'Rest', duration: Duration(minutes: 1)),
      ]).expand((i) => i),
      if (!isShort) ...[
        const WorkoutStage(name: 'Set Break', duration: Duration(minutes: 5)),
        ...[1, 2, 3, 2, 1].map((min) => [
          WorkoutStage(name: '$min min Effort', duration: Duration(minutes: min), description: '90% Effort.'),
          const WorkoutStage(name: 'Rest', duration: Duration(minutes: 1)),
        ]).expand((i) => i),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout climbingBurstsWorkout({required bool isShort}) {
  return Workout(
    title: isShort ? 'Climbing Bursts (30m)' : 'Climbing Bursts (60m)',
    description: 'Simulated hill attacks.',
    stages: [
      const WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 5)),
      for (int i = 0; i < (isShort ? 5 : 10); i++) ...[
        const WorkoutStage(name: 'Climb Base', duration: Duration(minutes: 3), description: '80% Effort.'),
        const WorkoutStage(name: 'Attack!', duration: Duration(seconds: 30), description: 'Stand 100%.'),
        const WorkoutStage(name: 'Descend', duration: Duration(minutes: 1, seconds: 30), description: 'Recover.'),
      ],
      const WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout powerHourWorkout() {
  return const Workout(
    title: 'Power Hour: Sweet Spot',
    description: 'Sustained effort at 88-93% FTP.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'Sweet Spot 1', duration: Duration(minutes: 20), description: '80% Effort.'),
      WorkoutStage(name: 'Recovery', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Sweet Spot 2', duration: Duration(minutes: 20), description: '80% Effort.'),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout powerHourThreshold() {
  return const Workout(
    title: 'Power Hour: Threshold',
    description: 'Higher intensity intervals at 100% FTP.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'Threshold 1', duration: Duration(minutes: 10), description: '90% Effort.'),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Threshold 2', duration: Duration(minutes: 10), description: '90% Effort.'),
      WorkoutStage(name: 'Rest', duration: Duration(minutes: 5)),
      WorkoutStage(name: 'Threshold 3', duration: Duration(minutes: 10), description: '90% Effort.'),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

Workout powerHourSteady() {
  return const Workout(
    title: 'Power Hour: Steady State',
    description: 'One long, unbroken effort.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'The Block', duration: Duration(minutes: 45), description: '80% Effort.'),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 5)),
    ],
  );
}

Workout sundayRideWorkout() {
  return const Workout(
    title: 'Sunday Endurance',
    description: 'A very low-intensity ride to aid recovery.',
    stages: [
      WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
      WorkoutStage(name: 'Steady State', duration: Duration(minutes: 40), description: 'Gentle Ride.'),
      WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
    ],
  );
}

TrainingPlan cyclingPlan() {
  return TrainingPlan(
    id: 'cycling_12_week',
    title: 'Cycling: 12-Week Power',
    description: 'A comprehensive plan for building cycling endurance and power.',
    difficulty: 'Intermediate',
    workoutType: WorkoutType.cycling,
    weeks: List.generate(12, (weekIndex) {
      return PlanWeek(
        weekNumber: weekIndex + 1,
        days: List.generate(3, (dayIndex) {
          return PlanDay(
            id: 'cycling_w${weekIndex + 1}_d${dayIndex + 1}',
            title: 'Session ${dayIndex + 1}',
            workout: const Workout(
              title: 'Endurance Ride',
              description: 'Focus on maintaining a steady pace.',
              stages: [
                WorkoutStage(name: 'Warm-up', duration: Duration(minutes: 10)),
                WorkoutStage(name: 'Main Set', duration: Duration(minutes: 30), description: 'Hold Zone 2/3 power.'),
                WorkoutStage(name: 'Cool-down', duration: Duration(minutes: 10)),
              ],
            ),
          );
        }),
      );
    }),
  );
}