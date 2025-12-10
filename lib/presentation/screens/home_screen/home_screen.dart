import 'package:flutter/material.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/presentation/screens/plan_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mars Workout")),
      body: Center(
        child: TabBar(

          tabs: [
            Tab(
              child: TabBarView(children: [PlanListScreen(workoutType: WorkoutType.cycling)]),
            ),
            Tab(
              child: TabBarView(children: [PlanListScreen(workoutType: WorkoutType.rowing)]),
            ),
            Tab(
              child: TabBarView(children: [PlanListScreen(workoutType: WorkoutType.kettleBell)]),
            ),
          ],
        ),
      ),
    );
  }
}
