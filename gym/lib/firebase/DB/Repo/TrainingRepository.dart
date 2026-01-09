import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../Models/SubscriptionPlans.dart';
import '../Models/Trainings.dart';
import '../Repo/Trainings_ExercisesRepository.dart';
import '../Repo/Trainings_WorkoutsRepository.dart';
import 'package:uuid/uuid.dart';

class TrainingsRepository {
  TrainingsRepository();

  Future<List<Trainings>> getAllTrainings() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("Trainings").get().then((snapshot) {
      List<Trainings> trainings =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Trainings.fromJson(Map<String, dynamic>.from(e));
      }).toList();
      return trainings;
    });

    return [];
  }

  Future<List<Trainings>> getAllTrainingsWithQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    Query query = ref.orderByChild("Training").equalTo("ts_name");
    return await query.get().then((snapshot) {
      List<Trainings> trainings =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Trainings.fromJson(Map<String, dynamic>.from(e));
      }).toList();
      return trainings;
    });

    return [];
  }

  Future<Trainings> save({required Trainings trainings}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Trainings');

    String uuid = const Uuid().v4();

    trainings.TS_ID = uuid;
    print('TS_ID : $uuid');

    await ref.child(uuid).set(trainings.toJson()).then((value) {
      return trainings;
    });
    return trainings;
  }

  Future<Trainings> update({required Trainings trainings}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Trainings');

    await ref.child(trainings.TS_ID).set(trainings.toJson()).then((value) {
      return trainings;
    });
    return trainings;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Trainings');

    await ref.child(uid).remove().then((value) {
      TrainingsExercisesRepository().deleteByTSId(tsId: uid);
      TrainingsWorkoutsRepository().deleteByTSId(tsId: uid);
    });
    return true;
  }

  Future<Trainings> getTrainingsFromId({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Trainings');

    return await ref.child(uid).get().then((value) {
      // return category;
      Trainings trainings = Trainings.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));

      return trainings;
    });
  }
}
