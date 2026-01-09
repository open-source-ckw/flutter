import 'package:firebase_database/firebase_database.dart';
import '../Models/Workouts_Categories.dart';
import '../Models/Workouts_Exercises.dart';
import 'package:uuid/uuid.dart';

class WorkoutsCategoriesRepository {
  WorkoutsCategoriesRepository();

  static const String wsCSTableName = "Workouts_Categories";

  Future<List<WorkoutsCategories>> getAllWorkoutsCategories() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsCSTableName).get().then((snapshot) {
      List<WorkoutsCategories> workoutsCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return workoutsCategories;
    });
  }

  Future<List<WorkoutsCategories>> getAllWorkoutsCategoriesByWSId(
      {required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsCSTableName).get().then((snapshot) {
      List<WorkoutsCategories> workoutsCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<WorkoutsCategories> newCategories =
          workoutsCategories.where((element) => element.WS_ID == wsId).toList();

      return newCategories;
    });
  }

  Future<List<WorkoutsCategories>> getAllWorkoutsCategoriesByCSId(
      {required String csId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsCSTableName).get().then((snapshot) {
      List<WorkoutsCategories> workoutsCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<WorkoutsCategories> newCategories =
          workoutsCategories.where((element) => element.CS_ID == csId).toList();

      return newCategories;
    });
  }

  Future<List<WorkoutsCategories>> getWorkoutsCategories(
      {required String wsId, required String csId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(wsCSTableName).get().then((snapshot) {
      List<WorkoutsCategories> workoutsCategories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return WorkoutsCategories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<WorkoutsCategories> newCategories = workoutsCategories
          .where((element) => element.WS_ID == wsId && element.CS_ID == csId)
          .toList();

      return newCategories;
    });
  }

  Future<WorkoutsCategories> save(
      {required WorkoutsCategories workoutsCategories}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsCSTableName);

    String uuid = const Uuid().v4();

    workoutsCategories.WS_CS_ID = uuid;

    return await ref.child(uuid).set(workoutsCategories.toJson()).then((value) {
      return workoutsCategories;
    });
  }

  Future<WorkoutsCategories> update(
      {required WorkoutsCategories workoutsCategories}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsCSTableName);

    return await ref
        .child(workoutsCategories.WS_CS_ID)
        .set(workoutsCategories.toJson())
        .then((value) {
      return workoutsCategories;
    });
  }

  Future<bool> delete({required String wsCsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsCSTableName);

    await ref.child(wsCsId).remove();
    return true;
  }

  Future<bool> deleteByCSId({required String csId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsCSTableName);
    List<WorkoutsCategories> workoutsCategories =
        await getAllWorkoutsCategories();
    for (var element in workoutsCategories) {
      if (element.CS_ID == csId) {
        await delete(wsCsId: element.WS_CS_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByWSId({required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(wsCSTableName);
    List<WorkoutsCategories> workoutsCategories =
        await getAllWorkoutsCategories();
    for (var element in workoutsCategories) {
      if (element.WS_ID == wsId) {
        await delete(wsCsId: element.WS_CS_ID);
      }
    }
    return true;
  }
}
