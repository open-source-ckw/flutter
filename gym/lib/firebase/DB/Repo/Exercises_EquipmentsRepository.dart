import 'package:firebase_database/firebase_database.dart';

import 'package:uuid/uuid.dart';

import '../Models/Exercises_Equipments.dart';

class ExercisesEquipmentsRepository {
  ExercisesEquipmentsRepository();

  static const String exEqTableName = "Exercises_Equipments";

  Future<List<ExercisesEquipments>> getAllExercisesEquipments() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(exEqTableName).get().then((snapshot) {
      List<ExercisesEquipments> exercisesEquipments =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesEquipments.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return exercisesEquipments;
    });
  }

  Future<List<ExercisesEquipments>> getAllExercisesEquipmentsByESId(
      {required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(exEqTableName).get().then((snapshot) {
      List<ExercisesEquipments> exercisesEquipments =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesEquipments.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ExercisesEquipments> newCategories = exercisesEquipments
          .where((element) => element.ES_ID == esId)
          .toList();

      return newCategories;
    });
  }

  Future<List<ExercisesEquipments>> getAllExercisesEquipmentsByEQId(
      {required String eqId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(exEqTableName).get().then((snapshot) {
      List<ExercisesEquipments> exercisesEquipments =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesEquipments.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ExercisesEquipments> newCategories = exercisesEquipments
          .where((element) => element.EQ_ID == eqId)
          .toList();

      return newCategories;
    });
  }

  Future<List<ExercisesEquipments>> getExercisesEquipments(
      {required String esId, required String eqId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(exEqTableName).get().then((snapshot) {
      List<ExercisesEquipments> exercisesEquipments =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesEquipments.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ExercisesEquipments> newCategories = exercisesEquipments
          .where((element) => element.ES_ID == esId && element.EQ_ID == eqId)
          .toList();

      return newCategories;
    });
  }

  Future<ExercisesEquipments> save(
      {required ExercisesEquipments exercisesEquipments}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(exEqTableName);

    String uuid = const Uuid().v4();

    exercisesEquipments.ES_EQ_ID = uuid;

    return await ref
        .child(uuid)
        .set(exercisesEquipments.toJson())
        .then((value) {
      return exercisesEquipments;
    });
  }

  Future<ExercisesEquipments> update(
      {required ExercisesEquipments exercisesEquipments}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(exEqTableName);

    return await ref
        .child(exercisesEquipments.ES_EQ_ID)
        .set(exercisesEquipments.toJson())
        .then((value) {
      return exercisesEquipments;
    });
  }

  Future<bool> delete({required String esEqId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(exEqTableName);

    await ref.child(esEqId).remove();
    return true;
  }

  Future<bool> deleteByESId({required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(exEqTableName);
    List<ExercisesEquipments> exercisesEquipments =
        await getAllExercisesEquipments();
    for (var element in exercisesEquipments) {
      if (element.ES_ID == esId) {
        await delete(esEqId: element.ES_EQ_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByEQId({required String eqId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(exEqTableName);
    List<ExercisesEquipments> exercisesCategories =
        await getAllExercisesEquipments();
    for (var element in exercisesCategories) {
      if (element.EQ_ID == eqId) {
        await delete(esEqId: element.ES_EQ_ID);
      }
    }
    return true;
  }
}
