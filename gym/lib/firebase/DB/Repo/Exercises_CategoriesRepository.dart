import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../Models/Exercises_Categories.dart';

class ExercisesCategoriesRepository {
  ExercisesCategoriesRepository();

  static const String tableName = "Exercises_Categories";

  Future<List<ExercisesCategories>> getAllExercisesCategories() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tableName).get().then((snapshot) {
      List<ExercisesCategories> exercisesCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return exercisesCategories;
    });
  }

  Future<List<ExercisesCategories>> getAllExercisesCategoriesByESId(
      {required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tableName).get().then((snapshot) {
      List<ExercisesCategories> exercisesCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ExercisesCategories> newCategories = exercisesCategories
          .where((element) => element.ES_ID == esId)
          .toList();
      return newCategories;
    });
  }

  Future<List<ExercisesCategories>> getAllExercisesCategoriesByCSId(
      {required String csId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tableName).get().then((snapshot) {
      print(snapshot.value);
      List<ExercisesCategories> exercisesCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ExercisesCategories> newCategories = exercisesCategories
          .where((element) => element.CS_ID == csId)
          .toList();

      return newCategories;
    });
  }

  Future<List<ExercisesCategories>> getExercisesCategory(
      {required String esId, required String csId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tableName).get().then((snapshot) {
      List<ExercisesCategories> exercisesCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ExercisesCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ExercisesCategories> newCategories = exercisesCategories
          .where((element) => element.ES_ID == esId && element.CS_ID == csId)
          .toList();

      return newCategories;
    });
  }

  Future<ExercisesCategories> save(
      {required ExercisesCategories exercisesCategory}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tableName);

    String uuid = const Uuid().v4();

    exercisesCategory.ES_CS_ID = uuid;

    return await ref.child(uuid).set(exercisesCategory.toJson()).then((value) {
      return exercisesCategory;
    });
  }

  Future<ExercisesCategories> update(
      {required ExercisesCategories exercisesCategory}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tableName);

    return await ref
        .child(exercisesCategory.ES_CS_ID)
        .set(exercisesCategory.toJson())
        .then((value) {
      return exercisesCategory;
    });
  }

  Future<bool> delete({required String esCsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tableName);

    await ref.child(esCsId).remove();
    return true;
  }

  Future<bool> deleteByESId({required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tableName);
    List<ExercisesCategories> exercisesCategories =
        await getAllExercisesCategories();
    for (var element in exercisesCategories) {
      if (element.ES_ID == esId) {
        await delete(esCsId: element.ES_CS_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByCSId({required String csId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tableName);
    List<ExercisesCategories> exercisesCategories =
        await getAllExercisesCategories();
    for (var element in exercisesCategories) {
      if (element.CS_ID == csId) {
        await delete(esCsId: element.ES_CS_ID);
      }
    }
    return true;
  }
}
