import 'package:firebase_database/firebase_database.dart';
import '../Models/Workouts_Exercises.dart';
import 'package:uuid/uuid.dart';

class WorkoutsExercisesRepository {
  WorkoutsExercisesRepository();

  static const String wsESTableName = "Workouts_Exercises";

  Future<List<WorkoutsExercises>> getAllWorkoutsExercises() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsESTableName).get().then((snapshot) {
      List<WorkoutsExercises> workoutsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return workoutsExercises;
    });
  }

  Future<List<WorkoutsExercises>> getAllWorkoutsExercisesByWSId(
      {required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsESTableName).get().then((snapshot) {
      List<WorkoutsExercises> workoutsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<WorkoutsExercises> newCategories =
          workoutsExercises.where((element) => element.WS_ID == wsId).toList();

      return newCategories;
    });
  }

  Future<List<WorkoutsExercises>> getAllWorkoutsExercisesByESId(
      {required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsESTableName).get().then((snapshot) {
      List<WorkoutsExercises> workoutsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<WorkoutsExercises> newCategories =
          workoutsExercises.where((element) => element.ES_ID == esId).toList();

      return newCategories;
    });
  }

  Future<List<WorkoutsExercises>> getWorkoutsExercises(
      {required String wsId, required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsESTableName).get().then((snapshot) {
      List<WorkoutsExercises> workoutsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<WorkoutsExercises> newCategories = workoutsExercises
          .where((element) => element.WS_ID == wsId && element.ES_ID == esId)
          .toList();

      return newCategories;
    });
  }

  Future<WorkoutsExercises> save(
      {required WorkoutsExercises workoutsExercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsESTableName);

    String uuid = const Uuid().v4();

    workoutsExercises.WS_ES_ID = uuid;

    return await ref.child(uuid).set(workoutsExercises.toJson()).then((value) {
      return workoutsExercises;
    });
  }

  Future<WorkoutsExercises> update(
      {required WorkoutsExercises workoutsExercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsESTableName);

    return await ref
        .child(workoutsExercises.WS_ES_ID)
        .set(workoutsExercises.toJson())
        .then((value) {
      return workoutsExercises;
    });
  }

  Future<bool> delete({required String wsEsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsESTableName);

    await ref.child(wsEsId).remove();
    return true;
  }

  Future<bool> deleteByESId({required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsESTableName);
    List<WorkoutsExercises> workoutsExercises = await getAllWorkoutsExercises();
    for (var element in workoutsExercises) {
      if (element.ES_ID == esId) {
        await delete(wsEsId: element.WS_ES_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByWSId({required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsESTableName);
    List<WorkoutsExercises> exercisesCategories =
        await getAllWorkoutsExercises();
    for (var element in exercisesCategories) {
      if (element.WS_ID == wsId) {
        await delete(wsEsId: element.WS_ES_ID);
      }
    }
    return true;
  }
}
