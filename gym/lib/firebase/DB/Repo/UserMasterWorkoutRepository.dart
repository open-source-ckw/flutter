import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Models/UserMaster_Workout.dart';
import '../Models/Workouts_Exercises.dart';
import 'package:uuid/uuid.dart';

class UserMasterWorkoutRepository {
  UserMasterWorkoutRepository();

  static const String umWSTableName = "UserMasterWorkout";

  Future<List<UserMasterWorkout>> getAllUserMasterWorkout() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);

    return await ref.get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return userMasterWorkout;
    });
  }

  Future<List<UserMasterWorkout>> getAllUserMasterWorkoutFromUserId(
      {required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);
    Query query = ref.orderByChild('um_ws_startDate');
    return await query.get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      userMasterWorkout =
          userMasterWorkout.where((element) => element.UM_ID == uid).toList();
      // print(userMasterWorkout);
      return userMasterWorkout;
    });
  }

  Future<List<UserMasterWorkout>> getAllUserMasterWorkoutFromUserIdByLimit(
      {required String uid, required int limit}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);
    Query query = ref.orderByChild('um_ws_startDate').limitToLast(limit);
    return await query.get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      userMasterWorkout =
          userMasterWorkout.where((element) => element.UM_ID == uid).toList();
      // print(userMasterWorkout);
      return userMasterWorkout;
    });
  }

  Future<List<UserMasterWorkout>> getAllUserMasterWorkoutByWSId(
      {required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(umWSTableName).get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<UserMasterWorkout> newCategories =
          userMasterWorkout.where((element) => element.WS_ID == wsId).toList();

      return newCategories;
    });
  }

  Future<List<UserMasterWorkout>> getAllUserMasterWorkoutByUMId(
      {required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(umWSTableName).get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<UserMasterWorkout> newCategories =
          userMasterWorkout.where((element) => element.UM_ID == umId).toList();

      return newCategories;
    });
  }

  Future<List<UserMasterWorkout>> getUserMasterWorkout(
      {required String wsId, required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(umWSTableName).get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<UserMasterWorkout> newCategories = userMasterWorkout
          .where((element) => element.WS_ID == wsId && element.UM_ID == umId)
          .toList();

      return newCategories;
    });
  }

  Future<UserMasterWorkout> save(
      {required UserMasterWorkout userMasterWorkout}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);

    String uuid = const Uuid().v4();

    userMasterWorkout.UM_WS_ID = uuid;

    return await ref.child(uuid).set(userMasterWorkout.toJson()).then((value) {
      return userMasterWorkout;
    });
  }

  Future<UserMasterWorkout> update(
      {required UserMasterWorkout userMasterWorkout}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);

    return await ref
        .child(userMasterWorkout.UM_WS_ID)
        .set(userMasterWorkout.toJson())
        .then((value) {
      return userMasterWorkout;
    });
  }

  Future<bool> delete({required String umWsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);

    await ref.child(umWsId).remove();
    return true;
  }

  Future<bool> deleteByUMId({required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);
    List<UserMasterWorkout> userMasterWorkout = await getAllUserMasterWorkout();
    for (var element in userMasterWorkout) {
      if (element.UM_ID == umId) {
        await delete(umWsId: element.UM_WS_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByWSId({required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(umWSTableName);
    List<UserMasterWorkout> userMasterWorkout = await getAllUserMasterWorkout();
    for (var element in userMasterWorkout) {
      if (element.WS_ID == wsId) {
        await delete(umWsId: element.UM_WS_ID);
      }
    }
    return true;
  }

  Future<UserMasterWorkout?> getUserMasterWorkoutExistForDateIfExistForWorkout(
      {required String date,
      required String workoutId,
      required String categoryId,
      required String userId}) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child(umWSTableName);
    Query query = ref.orderByChild("um_ws_startTime");

    return await query.get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<UserMasterWorkout> values = userMasterWorkout
          .where((element) =>
              element.UM_ID == userId &&
              element.um_ws_startDate == date &&
              element.um_ws_type.trim().toLowerCase() == 'workout' &&
              element.WS_ID == workoutId &&
              element.um_ws_activeCategoryId == categoryId)
          .toList();

      if (values.isNotEmpty) {
        return values.first;
      } else {
        return null;
      }
    });
  }

  Future<UserMasterWorkout?> getUserMasterWorkoutExistForDateIfExistForTraining(
      {required String date,
      required String trainingID,
      required String userId}) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child(umWSTableName);
    Query query = ref.orderByChild("um_ws_startTime");

    return await query.get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<UserMasterWorkout> values = userMasterWorkout
          .where((element) =>
              element.UM_ID == userId &&
              element.um_ws_startDate == date &&
              element.um_ws_type.trim().toLowerCase() == 'workout' &&
              element.TS_ID == trainingID)
          .toList();

      if (values.isNotEmpty) {
        return values.first;
      } else {
        return null;
      }
    });
  }

  Future<UserMasterWorkout?> getUserMasterWorkoutExistForDateIfExistForBanner(
      {required String date,
      required String bannerId,
      required String userId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(umWSTableName).get().then((snapshot) {
      List<UserMasterWorkout> userMasterWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return UserMasterWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<UserMasterWorkout> values = userMasterWorkout
          .where((element) =>
              element.UM_ID == userId &&
              element.um_ws_startDate == date &&
              element.um_ws_type.trim().toLowerCase() == 'banner' &&
              element.WS_ID == bannerId)
          .toList();

      if (values.isNotEmpty) {
        return values.first;
      } else {
        return null;
      }
    });
  }
}
