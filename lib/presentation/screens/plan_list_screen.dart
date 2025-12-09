import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/data/repositories/workout_repository.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_bloc.dart';
import 'package:mars_workout_app/logic/bloc/plan/plan_state.dart';
import 'package:mars_workout_app/presentation/screens/details/plan_details.dart';

class PlanListScreen extends StatelessWidget {
  const PlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = WorkoutRepository().getAllPlans();

    return Scaffold(
      appBar: AppBar(title: const Text("Workout Plans")),
      body: BlocBuilder<PlanBloc, PlanState>(
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              // Calculate progress using the hydrated state
              final progress = plan.calculateProgress(state.completedDayIds);
              final isActive = state.activePlanId == plan.id;

              return Card(
                elevation: isActive ? 4 : 1,
                shape: RoundedRectangleBorder(
                  side: isActive
                      ? const BorderSide(color: Colors.blue, width: 2)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlanDetailScreen(plan: plan),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                plan.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            if (isActive)
                              const Chip(
                                label: Text("Active", style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(plan.description, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[200],
                                color: isActive ? Colors.blue : Colors.grey,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text("${(progress * 100).toInt()}%"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}