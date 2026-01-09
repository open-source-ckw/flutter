import 'package:flutter/material.dart';

import '../firebase/DB/Models/Banner.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Repo/TonningWorkoutsRepository.dart';

class BannerWorkoutsProvider with ChangeNotifier {
  // bool isOnline = true;
  TonningWorkoutsRepository tonningWorkoutsRepository =
      TonningWorkoutsRepository();
  List<TonningWorkoutsModel> toningWorkouts = [];

  allToningWorkoutsProvider() async {
    List<TonningWorkoutsModel> tempToningWorkouts =
        await tonningWorkoutsRepository.getAllTonningWorkouts();

    // exercises.clear();
    toningWorkouts = tempToningWorkouts;
    // setState(() {});
    // exercisesRepository.getResentExercises();
    notifyListeners();
  }
}
