import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../Models/Banner.dart';
import '../Models/Workouts.dart';
import '../Repo/Trainings_WorkoutsRepository.dart';
import '../Repo/Workouts_ExercisesRepository.dart';
import 'package:uuid/uuid.dart';

class TonningWorkoutsRepository {
  TonningWorkoutsRepository();

  Future<List<TonningWorkoutsModel>> getAllTonningWorkouts() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("TonningWorkouts").get().then((snapshot) {
      List<TonningWorkoutsModel> tonningWorkoutsModel =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TonningWorkoutsModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return tonningWorkoutsModel;
    });
  }

  Future<List<TonningWorkoutsModel>> getAllTonningWorkoutsWithQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    Query query = ref.orderByChild("TonningWorkouts").equalTo("tWs_name");
    return await query.get().then((snapshot) {
      List<TonningWorkoutsModel> tonningWorkoutsModel =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TonningWorkoutsModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return tonningWorkoutsModel;
    });
  }

  Future<TonningWorkoutsModel> save(
      {required TonningWorkoutsModel tonningWorkoutsModel}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('TonningWorkouts');

    String uuid = const Uuid().v4();

    tonningWorkoutsModel.TWS_ID = uuid;
    print('TWS_ID : $uuid');

    await ref.child(uuid).set(tonningWorkoutsModel.toJson()).then((value) {
      return tonningWorkoutsModel;
    });
    return tonningWorkoutsModel;
  }

  Future<TonningWorkoutsModel> update(
      {required TonningWorkoutsModel tonningWorkoutsModel}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('TonningWorkouts');

    await ref
        .child(tonningWorkoutsModel.TWS_ID)
        .set(tonningWorkoutsModel.toJson())
        .then((value) {
      return tonningWorkoutsModel;
    });
    return tonningWorkoutsModel;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('TonningWorkouts');

    await ref.child(uid).remove().then((value) {
      // WorkoutsExercisesRepository().deleteByWSId(wsId: uid);
      // TrainingsWorkoutsRepository().deleteByWSId(wsId: uid);
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

  Future<TonningWorkoutsModel> getTonningWorkoutsModelFromId(
      {required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('TonningWorkouts');

    return await ref.child(uid).get().then((value) {
      // return userMaster;
      TonningWorkoutsModel tonningWorkoutsModel = TonningWorkoutsModel.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
      // print(userMaster.toString());
      return tonningWorkoutsModel;
    });
  }
}
