import 'package:firebase_database/firebase_database.dart';
import '../Models/Trainings_Exercises.dart';
import 'package:uuid/uuid.dart';

class TrainingsExercisesRepository {
  TrainingsExercisesRepository();

  static const String tsEsTableName = "Trainings_Exercises";

  Future<List<TrainingsExercises>> getAllTrainingsExercises() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsEsTableName).get().then((snapshot) {
      List<TrainingsExercises> trainingsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return trainingsExercises;
    });
  }

  Future<List<TrainingsExercises>> getAllTrainingsExercisesByTSId(
      {required String tsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsEsTableName).get().then((snapshot) {
      List<TrainingsExercises> trainingsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<TrainingsExercises> newCategories =
          trainingsExercises.where((element) => element.TS_ID == tsId).toList();

      return newCategories;
    });
  }

  Future<List<TrainingsExercises>> getAllTrainingsExercisesByESId(
      {required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsEsTableName).get().then((snapshot) {
      List<TrainingsExercises> trainingsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<TrainingsExercises> newCategories =
          trainingsExercises.where((element) => element.ES_ID == esId).toList();

      return newCategories;
    });
  }

  Future<List<TrainingsExercises>> getTrainingsExercises(
      {required String tsId, required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(tsEsTableName).get().then((snapshot) {
      List<TrainingsExercises> trainingsExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return TrainingsExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<TrainingsExercises> newCategories = trainingsExercises
          .where((element) => element.TS_ID == tsId && element.ES_ID == esId)
          .toList();

      return newCategories;
    });
  }

  Future<TrainingsExercises> save(
      {required TrainingsExercises trainingsExercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsEsTableName);

    String uuid = const Uuid().v4();

    trainingsExercises.TS_ES_ID = uuid;

    return await ref.child(uuid).set(trainingsExercises.toJson()).then((value) {
      return trainingsExercises;
    });
  }

  Future<TrainingsExercises> update(
      {required TrainingsExercises trainingsExercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsEsTableName);

    return await ref
        .child(trainingsExercises.TS_ES_ID)
        .set(trainingsExercises.toJson())
        .then((value) {
      return trainingsExercises;
    });
  }

  Future<bool> delete({required String tsEsID}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsEsTableName);

    await ref.child(tsEsID).remove();
    return true;
  }

  Future<bool> deleteByTSId({required String tsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsEsTableName);
    List<TrainingsExercises> trainingsExercises =
        await getAllTrainingsExercises();
    for (var element in trainingsExercises) {
      if (element.TS_ID == tsId) {
        await delete(tsEsID: element.TS_ES_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByESId({required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(tsEsTableName);
    List<TrainingsExercises> trainingsExercises =
        await getAllTrainingsExercises();
    for (var element in trainingsExercises) {
      if (element.ES_ID == esId) {
        await delete(tsEsID: element.TS_ES_ID);
      }
    }
    return true;
  }
}
