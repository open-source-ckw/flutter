import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../Models/ScheduledWorkout.dart';

class ScheduledWorkoutRepository {
  ScheduledWorkoutRepository();

  static const String swTableName = "ScheduledWorkout";

  Future<List<ScheduledWorkout>> getAllScheduledWorkout() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);

    return await ref.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ScheduledWorkout> scheduledWorkout =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ScheduledWorkout.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        return scheduledWorkout;
      }
      return [];
    });
  }

  Future<List<ScheduledWorkout>> getAllScheduledWorkoutFromUserId(
      {required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);
    return await ref.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ScheduledWorkout> scheduledWorkout =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ScheduledWorkout.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        scheduledWorkout =
            scheduledWorkout.where((element) => element.UM_ID == uid).toList();
        return scheduledWorkout;
      }
      return [];
    });
  }

  Future<List<ScheduledWorkout>> getAllScheduledWorkoutByREFId(
      {required String refId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(swTableName).get().then((snapshot) {
      List<ScheduledWorkout> scheduledWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ScheduledWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ScheduledWorkout> newCategories =
          scheduledWorkout.where((element) => element.REF_ID == refId).toList();

      return newCategories;
    });
  }

  Future<List<ScheduledWorkout>> getScheduledWorkout(
      {required String refId, required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(swTableName).get().then((snapshot) {
      List<ScheduledWorkout> scheduledWorkout =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ScheduledWorkout.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ScheduledWorkout> newCategories = scheduledWorkout
          .where((element) => element.REF_ID == refId && element.UM_ID == umId)
          .toList();

      return newCategories;
    });
  }

  Future<ScheduledWorkout> save(
      {required ScheduledWorkout scheduledWorkout}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);

    String uuid = const Uuid().v4();

    scheduledWorkout.SW_ID = uuid;

    return await ref.child(uuid).set(scheduledWorkout.toJson()).then((value) {
      return scheduledWorkout;
    });
  }

  Future<ScheduledWorkout> update(
      {required ScheduledWorkout scheduledWorkout}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);

    return await ref
        .child(scheduledWorkout.SW_ID)
        .set(scheduledWorkout.toJson())
        .then((value) {
      return scheduledWorkout;
    });
  }

  Future<bool> delete({required String sw_ID}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);

    await ref.child(sw_ID).remove();
    return true;
  }

  Future<bool> deleteByUMId({required String umId}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);
    List<ScheduledWorkout> scheduledWorkout = await getAllScheduledWorkout();
    for (var element in scheduledWorkout) {
      if (element.UM_ID == umId) {
        await delete(sw_ID: element.SW_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByREFId({required String REFId}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);
    List<ScheduledWorkout> scheduledWorkout = await getAllScheduledWorkout();
    for (var element in scheduledWorkout) {
      if (element.REF_ID == REFId) {
        await delete(sw_ID: element.SW_ID);
      }
    }
    return true;
  }

  Future<bool> isExist(
      {required String uid,
      required String refId,
      required String date}) async {
    List<ScheduledWorkout> list = await getAllScheduledWorkout();
    final result = list.any((element) =>
        element.UM_ID == uid &&
        element.REF_ID == refId &&
        element.sw_scheduledForDate == date);
    return result;
  }

  Future<List<ScheduledWorkout>> getAllScheduledWorkoutFromUserIdByStartDate(
      {required uid,
      required String refId,
      required String startDate,
      required String endDate}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);

    Query query = ref.orderByChild("sw_scheduledForDate").startAfter(
        startDate); /*.endBefore(endDate,key: "sw_scheduledForDate");*/
    return await query.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ScheduledWorkout> scheduledWorkouts =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ScheduledWorkout.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        // print(scheduledWorkouts);
        final result = scheduledWorkouts.where(
            (element) => element.UM_ID == uid && element.REF_ID == refId);
        return result.toList();
      }
      return [];
    });
  }

  Future<ScheduledWorkout?> getScheduledWorkoutFromUserIdByStartDate(
      {required uid, required String refId, required String date}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(swTableName);

    Query query = ref.orderByChild(
        "sw_scheduledForDate"); /*.endBefore(endDate,key: "sw_scheduledForDate");*/
    return await query.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ScheduledWorkout> scheduledWorkouts =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ScheduledWorkout.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        // print(scheduledWorkouts);
        final result = scheduledWorkouts.where((element) =>
            element.UM_ID == uid &&
            element.REF_ID == refId &&
            element.sw_scheduledForDate == date);
        // print('result:$result');
        return result.isNotEmpty ? result.first : null;
      }
      return null;
    });
  }
}
