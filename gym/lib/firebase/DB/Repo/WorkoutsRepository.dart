import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../Models/Workouts.dart';
import '../Repo/Trainings_WorkoutsRepository.dart';
import '../Repo/Workouts_ExercisesRepository.dart';
import 'package:uuid/uuid.dart';

class WorkoutsRepository {
  WorkoutsRepository();

  Future<List<Workouts>> getAllWorkouts() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("Workouts").get().then((snapshot) {
      List<Workouts> workouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Workouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return workouts;
    });
  }

  Future<List<Workouts>> getAllWorkoutsWithQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    Query query = ref.orderByChild("Workout").equalTo("ws_name");
    return await query.get().then((snapshot) {
      List<Workouts> workouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Workouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return workouts;
    });
  }

  Future<Workouts> save({required Workouts workouts}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Workouts');

    String uuid = const Uuid().v4();

    workouts.WS_ID = uuid;
    print('WS_ID : $uuid');

    await ref.child(uuid).set(workouts.toJson()).then((value) {
      return workouts;
    });
    return workouts;
  }

  Future<Workouts> update({required Workouts workouts}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Workouts');

    await ref.child(workouts.WS_ID).set(workouts.toJson()).then((value) {
      return workouts;
    });
    return workouts;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Workouts');

    await ref.child(uid).remove().then((value) {
      WorkoutsExercisesRepository().deleteByWSId(wsId: uid);
      TrainingsWorkoutsRepository().deleteByWSId(wsId: uid);
    });
    return true;
  }

  // Future<Workouts?> getWorkoutsFromId({required String uid}) async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref('Workouts');
  //
  //   return await ref.child(uid).get().then((value) {
  //     // return category;
  //     Workouts workouts = Workouts.fromJson(
  //         Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>)
  //     );
  //     // print(workouts.toString());
  //     return workouts;
  //   });
  //
  // }

  Future<Workouts> getWorkoutsFromId({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Workouts');

    return await ref.child(uid).get().then((value) {
      // return userMaster;
      Workouts workouts = Workouts.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
      // print(userMaster.toString());
      return workouts;
    });
  }
}
