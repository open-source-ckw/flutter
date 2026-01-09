import '../firebase/DB/Models/ReminderWorkout.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/ReminderWorkoutsRepository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../firebase/DB/Models/Exercises.dart';

class ReminderWorkoutProvider with ChangeNotifier {
  // bool isOnline = true;
  ReminderWorkoutsRepository reminderWorkoutsRepository =
      ReminderWorkoutsRepository();
  List<ReminderWorkouts> reminderWorkouts = [];
  List<int> scheduledDays = [];
  List<int> orgScheduledDays = [];

  reminderProvider({required userID}) async {
    reminderWorkouts.clear();
    List<ReminderWorkouts> tempReminderWorkouts =
        await reminderWorkoutsRepository.getAllReminderWorkoutsFromUserId(
            uid: userID);
    for (var userReminderWorkouts in tempReminderWorkouts) {
      if (!reminderWorkouts.contains(userReminderWorkouts)) {
        reminderWorkouts.add(userReminderWorkouts);
      }
    }
    reminderWorkouts = reminderWorkouts.toList();
    notifyListeners();
  }

  createReminderProvider({required userID, required time}) async {
    // reminderWorkouts.clear();
    DateTime startDate = DateTime.now();
    startDate = startDate.add(const Duration(days: 1));

    List<ReminderWorkouts> tempReminderWorkouts =
        await reminderWorkoutsRepository
            .getAllReminderWorkoutsFromUserIdByStartDate(
                uid: userID,
                startDate: scheduledDays.toString(),
                setTime: time);

    for (var element in tempReminderWorkouts) {
      DateFormat format = DateFormat("dd");
      String day = format.format(DateTime.parse(element.rw_scheduledForDay));
      if (!scheduledDays.contains(int.parse(day))) {
        scheduledDays.add(int.parse(day));
        orgScheduledDays.add(int.parse(day));
      }
    }
    notifyListeners();
  }
}
