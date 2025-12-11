// lib/logic/bloc/plan/plan_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_event.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_state.dart';

class PlanBloc extends HydratedBloc<PlanEvent, PlanState> {
  PlanBloc() : super(const PlanState()) {

    on<StartPlan>((event, emit) {
      final updatedMap = Map<String, String>.from(state.activePlans);

      // CRITICAL: Use the Type as the key.
      // This ensures if you start "Cycling Plan B", it overwrites "Cycling Plan A".
      updatedMap[event.type.toString()] = event.planId;

      emit(state.copyWith(activePlans: updatedMap));
    });

    on<MarkDayAsCompleted>((event, emit) {
      final updatedList = List<String>.from(state.completedDayIds);
      if (!updatedList.contains(event.dayId)) {
        updatedList.add(event.dayId);
      }
      emit(state.copyWith(completedDayIds: updatedList));
    });

    // Reset everything
    on<ResetProgress>((event, emit) {
      emit(const PlanState(activePlans: {}, completedDayIds: []));
    });
  }

  @override
  PlanState? fromJson(Map<String, dynamic> json) => PlanState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PlanState state) => state.toJson();
}