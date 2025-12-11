import 'package:equatable/equatable.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();
  @override
  List<Object> get props => [];
}

class StartPlan extends PlanEvent {
  final String planId;
  final WorkoutType type; // Added Type

  const StartPlan(this.planId, this.type);
}

class CompleteDay extends PlanEvent {
  final String dayId;
  const CompleteDay(this.dayId);
}

class MarkDayAsCompleted extends PlanEvent {
  final String dayId;
  const MarkDayAsCompleted(this.dayId);
}

class ResetProgress extends PlanEvent {}