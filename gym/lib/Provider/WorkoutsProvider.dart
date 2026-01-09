import '../firebase/DB/Models/Workouts.dart';
import '../firebase/DB/Repo/WorkoutsRepository.dart';
import 'package:flutter/material.dart';

class WorkoutsProvider with ChangeNotifier {
  // bool isOnline = true;
  WorkoutsRepository workoutsRepository = WorkoutsRepository();
  List<Workouts> workouts = [];

  allWorkoutsProvider() async {
    List<Workouts> tempWorkouts = await workoutsRepository.getAllWorkouts();

    // exercises.clear();
    workouts = tempWorkouts;
    // setState(() {});
    // exercisesRepository.getResentExercises();
    notifyListeners();
  }
}
