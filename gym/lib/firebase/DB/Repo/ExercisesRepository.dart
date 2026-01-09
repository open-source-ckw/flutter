import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../Models/Equipments.dart';
import '../Models/Exercises.dart';
import '../Repo/Exercises_CategoriesRepository.dart';
import '../Repo/Exercises_EquipmentsRepository.dart';
import '../Repo/Trainings_ExercisesRepository.dart';
import '../Repo/Workouts_ExercisesRepository.dart';
import 'package:uuid/uuid.dart';

class ExercisesRepository {
  ExercisesRepository();

  Future<List<Exercises>> getAllExercises() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("Exercises").get().then((snapshot) {
      List<Exercises> exercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Exercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return exercises;
    });
  }

  Future<List<Exercises>> getResentExercises() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("Exercises").limitToLast(4).get().then((snapshot) {
      List<Exercises> exercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Exercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return exercises;
    });
  }

  Future<List<Exercises>> getAllExercisesWithQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    Query query = ref.orderByChild("Exercises").equalTo("es_name");
    return await ref.child("Exercises").get().then((snapshot) {
      List<Exercises> exercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Exercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return exercises;
    });
  }

  Future<List<Exercises>> getAllExercisesByCSID({required String CS_ID}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("Exercises").get().then((snapshot) {
      List<Exercises> exercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Exercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      exercises = exercises.where((e) => e.CS_ID == CS_ID).toList();
      return exercises;
    });
  }

  Future<Exercises> save({required Exercises exercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Exercises');

    String uuid = const Uuid().v4();

    print(uuid);

    exercises.Es_ID = uuid;
    print('ES_ID : $uuid');

    await ref.child(uuid).set(exercises.toJson()).then((value) {
      return exercises;
    });
    return exercises;
  }

  Future<Exercises> update({required Exercises exercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Exercises');

    await ref.child(exercises.Es_ID).set(exercises.toJson()).then((value) {
      return exercises;
    });
    return exercises;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Exercises');

    await ref.child(uid).remove().then((value) async {
      await ExercisesCategoriesRepository()
          .deleteByESId(esId: uid)
          .then((value) async {
        await WorkoutsExercisesRepository()
            .deleteByESId(esId: uid)
            .then((value) async {
          await ExercisesEquipmentsRepository()
              .deleteByESId(esId: uid)
              .then((value) async {
            await TrainingsExercisesRepository().deleteByESId(esId: uid);
          });
        });
      });
    });
    return true;
  }

  Future<Exercises> getExercisesFromId({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Exercises');

    return await ref.child(uid).get().then((value) {
      // return category;
      Exercises exercises = Exercises.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
      return exercises;
    });
  }
}
