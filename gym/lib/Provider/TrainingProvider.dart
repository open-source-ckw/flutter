import '../firebase/DB/Models/Trainings.dart';
import '../firebase/DB/Repo/TrainingRepository.dart';
import 'package:flutter/material.dart';

class TrainingProvider with ChangeNotifier {
  // bool isOnline = true;
  TrainingsRepository trainingsRepository = TrainingsRepository();
  List<Trainings> trainings = [];

  allTrainingsProvider() async {
    List<Trainings> tempTrainings = await trainingsRepository.getAllTrainings();

    // exercises.clear();
    trainings = tempTrainings;
    // setState(() {});
    // exercisesRepository.getResentExercises();
    notifyListeners();
  }
}
