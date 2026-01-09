import 'package:firebase_database/firebase_database.dart';
import '../Models/Toning_Exercises.dart';
import 'package:uuid/uuid.dart';

class ToningExercisesRepository {
  ToningExercisesRepository();

  static const String twsESTableName = "Toning_Exercises";

  Future<List<ToningExercises>> getAllToningExercises() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(twsESTableName).get().then((snapshot) {
      List<ToningExercises> toningExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ToningExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return toningExercises;
    });
  }

  Future<List<ToningExercises>> getAllToningExercisesBytWsId(
      {required String tWsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(twsESTableName).get().then((snapshot) {
      List<ToningExercises> toningExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ToningExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ToningExercises> newCategories =
          toningExercises.where((element) => element.TWS_ID == tWsId).toList();

      return newCategories;
    });
  }

  Future<List<ToningExercises>> getAllToningExercisesByESId(
      {required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(twsESTableName).get().then((snapshot) {
      List<ToningExercises> toningExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ToningExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ToningExercises> newCategories =
          toningExercises.where((element) => element.ES_ID == esId).toList();

      return newCategories;
    });
  }

  Future<List<ToningExercises>> getToningExercises(
      {required String tWsId, required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(twsESTableName).get().then((snapshot) {
      List<ToningExercises> toningExercises =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ToningExercises.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ToningExercises> newCategories = toningExercises
          .where((element) => element.TWS_ID == tWsId && element.ES_ID == esId)
          .toList();

      return newCategories;
    });
  }

  Future<ToningExercises> save(
      {required ToningExercises toningExercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(twsESTableName);

    String uuid = const Uuid().v4();

    toningExercises.TWS_ES_ID = uuid;

    return await ref.child(uuid).set(toningExercises.toJson()).then((value) {
      return toningExercises;
    });
  }

  Future<ToningExercises> update(
      {required ToningExercises toningExercises}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(twsESTableName);

    return await ref
        .child(toningExercises.TWS_ES_ID)
        .set(toningExercises.toJson())
        .then((value) {
      return toningExercises;
    });
  }

  Future<bool> delete({required String tWsEsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(twsESTableName);

    await ref.child(tWsEsId).remove();
    return true;
  }

  Future<bool> deleteByESId({required String esId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(twsESTableName);
    List<ToningExercises> toningExercises = await getAllToningExercises();
    for (var element in toningExercises) {
      if (element.ES_ID == esId) {
        await delete(tWsEsId: element.TWS_ES_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByTWSId({required String tWsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(twsESTableName);
    List<ToningExercises> toningExercises = await getAllToningExercises();
    for (var element in toningExercises) {
      if (element.TWS_ID == tWsId) {
        await delete(tWsEsId: element.TWS_ES_ID);
      }
    }
    return true;
  }
}
