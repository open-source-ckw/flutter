import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../Models/ReminderWorkout.dart';
import '../Models/ScheduledWorkout.dart';

class ReminderWorkoutsRepository {
  ReminderWorkoutsRepository();

  static const String rwTableName = "ReminderWorkouts";

  Future<List<ReminderWorkouts>> getAllReminderWorkouts() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);

    return await ref.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ReminderWorkouts> reminderWorkouts =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        return reminderWorkouts;
      }
      return [];
    });
  }

  Future<List<ReminderWorkouts>> getAllReminderWorkoutsFromUserId(
      {required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);
    return await ref.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ReminderWorkouts> reminderWorkouts =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        reminderWorkouts =
            reminderWorkouts.where((element) => element.UM_ID == uid).toList();
        return reminderWorkouts;
      }
      return [];
    });
  }

  Future<List<ReminderWorkouts>> getAllReminderWorkoutsByWSId(
      {required String wsId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(rwTableName).get().then((snapshot) {
      List<ReminderWorkouts> reminderWorkouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ReminderWorkouts> newCategories =
          reminderWorkouts.where((element) => element.WS_ID == wsId).toList();

      return newCategories;
    });
  }

  Future<List<ReminderWorkouts>> getReminderWorkouts(
      {required String wsId, required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(rwTableName).get().then((snapshot) {
      List<ReminderWorkouts> reminderWorkouts =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ReminderWorkouts> newCategories = reminderWorkouts
          .where((element) => element.WS_ID == wsId && element.UM_ID == umId)
          .toList();

      return newCategories;
    });
  }

  Future<ReminderWorkouts> save(
      {required ReminderWorkouts reminderWorkouts}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);

    String uuid = const Uuid().v4();

    reminderWorkouts.RW_ID = uuid;

    return await ref.child(uuid).set(reminderWorkouts.toJson()).then((value) {
      return reminderWorkouts;
    });
  }

  Future<ReminderWorkouts> update(
      {required ReminderWorkouts reminderWorkouts}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);

    return await ref
        .child(reminderWorkouts.RW_ID)
        .set(reminderWorkouts.toJson())
        .then((value) {
      return reminderWorkouts;
    });
  }

  Future<bool> delete({required String rw_id}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);

    await ref.child(rw_id).remove();
    return true;
  }

  Future<bool> deleteByUMId({required String umId}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);
    List<ReminderWorkouts> reminderWorkouts = await getAllReminderWorkouts();
    for (var element in reminderWorkouts) {
      if (element.UM_ID == umId) {
        await delete(rw_id: element.RW_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByWSId({required String WSId}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);
    List<ReminderWorkouts> reminderWorkouts = await getAllReminderWorkouts();
    for (var element in reminderWorkouts) {
      if (element.WS_ID == WSId) {
        await delete(rw_id: element.RW_ID);
      }
    }
    return true;
  }

  Future<bool> isExist({required String uid, required String day}) async {
    List<ReminderWorkouts> list = await getAllReminderWorkouts();
    final result = list.any(
        (element) => element.UM_ID == uid && element.rw_scheduledForDay == day);
    return result;
  }

  Future<List<ReminderWorkouts>> getAllReminderWorkoutsFromUserIdByStartDate(
      {required uid,
      required String startDate,
      required String setTime}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);

    Query query = ref.orderByChild("rw_scheduledForDay").startAfter(
        startDate); /*.endBefore(endDate,key: "sw_scheduledForDate");*/
    return await query.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ReminderWorkouts> reminderWorkouts =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        // print(scheduledWorkouts);
        final result = reminderWorkouts.where((element) =>
            element.UM_ID == uid &&
            element.rw_reminderTime == setTime &&
            element.rw_scheduledForDay == startDate);
        return result.toList();
      }
      return [];
    });
  }

  Future<ReminderWorkouts?> getReminderWorkoutsFromUserIdByStartDate(
      {required uid, required String wsId, required String day}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(rwTableName);

    Query query = ref.orderByChild(
        "rw_scheduledForDay"); /*.endBefore(endDate,key: "sw_scheduledForDate");*/
    return await query.get().then((snapshot) {
      if (snapshot.value != null) {
        List<ReminderWorkouts> reminderWorkouts =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        // print(scheduledWorkouts);
        final result = reminderWorkouts.where((element) =>
            element.UM_ID == uid &&
            element.WS_ID == wsId &&
            element.rw_scheduledForDay == day);
        // print('result:$result');
        return result.isNotEmpty ? result.first : null;
      }
      return null;
    });
  }
}
