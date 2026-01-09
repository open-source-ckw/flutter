import 'package:firebase_database/firebase_database.dart';
import '../Models/Trainings_Workouts.dart';
import 'package:uuid/uuid.dart';

class TrainingsWorkoutsRepository {
  TrainingsWorkoutsRepository();

  static const String tsWsTableName = "Trainings_Workouts";

  Future<List<TrainingsWorkouts>> getAllTrainingsWorkouts() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsWsTableName).get().then((snapshot) {
      List<TrainingsWorkouts> trainingsWorkouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsWorkouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return trainingsWorkouts;
    });
  }

  Future<List<TrainingsWorkouts>> getAllTrainingsWorkoutsByTSId(
      {required String tsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsWsTableName).get().then((snapshot) {
      List<TrainingsWorkouts> trainingsWorkouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsWorkouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<TrainingsWorkouts> newCategories =
          trainingsWorkouts.where((element) => element.TS_ID == tsId).toList();

      return newCategories;
    });
  }

  Future<List<TrainingsWorkouts>> getAllTrainingsWorkoutsByWSId(
      {required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsWsTableName).get().then((snapshot) {
      List<TrainingsWorkouts> trainingsWorkouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsWorkouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<TrainingsWorkouts> newCategories =
          trainingsWorkouts.where((element) => element.WS_ID == wsId).toList();

      return newCategories;
    });
  }

  Future<List<TrainingsWorkouts>> getTrainingsWorkouts(
      {required String tsId, required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsWsTableName).get().then((snapshot) {
      List<TrainingsWorkouts> trainingsWorkouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsWorkouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<TrainingsWorkouts> newCategories = trainingsWorkouts
          .where((element) => element.TS_ID == tsId && element.WS_ID == wsId)
          .toList();

      return newCategories;
    });
  }

  Future<TrainingsWorkouts> save(
      {required TrainingsWorkouts trainingsWorkouts}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsWsTableName);

    String uuid = const Uuid().v4();

    trainingsWorkouts.TS_WS_ID = uuid;

    return await ref.child(uuid).set(trainingsWorkouts.toJson()).then((value) {
      return trainingsWorkouts;
    });
  }

  Future<TrainingsWorkouts> update(
      {required TrainingsWorkouts trainingsWorkouts}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsWsTableName);

    return await ref
        .child(trainingsWorkouts.TS_WS_ID)
        .set(trainingsWorkouts.toJson())
        .then((value) {
      return trainingsWorkouts;
    });
  }

  Future<bool> delete({required String tsWsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsWsTableName);

    await ref.child(tsWsId).remove();
    return true;
  }

  Future<bool> deleteByTSId({required String tsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsWsTableName);
    List<TrainingsWorkouts> trainingsWorkouts = await getAllTrainingsWorkouts();
    for (var element in trainingsWorkouts) {
      if (element.TS_ID == tsId) {
        await delete(tsWsId: element.TS_WS_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByWSId({required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsWsTableName);
    List<TrainingsWorkouts> exercisesCategories =
        await getAllTrainingsWorkouts();
    for (var element in exercisesCategories) {
      if (element.WS_ID == wsId) {
        await delete(tsWsId: element.TS_WS_ID);
      }
    }
    return true;
  }
}
