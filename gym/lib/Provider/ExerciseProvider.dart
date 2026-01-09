import 'package:flutter/material.dart';

import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';

class ExercisesProvider with ChangeNotifier {
  // bool isOnline = true;
  ExercisesRepository exercisesRepository = ExercisesRepository();
  List<Exercises> exercises = [];

  resentExercisesProvider() async {
    List<Exercises> tempExercises =
        await exercisesRepository.getResentExercises();

    // exercises.clear();
    exercises = tempExercises;
    // setState(() {});
    // exercisesRepository.getResentExercises();
    notifyListeners();
  }
}
