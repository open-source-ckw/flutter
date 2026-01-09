import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../Models/NotificationAlert.dart';
import '../Models/ReminderWorkout.dart';
import '../Models/ScheduledWorkout.dart';

class NotificationAlertRepository {
  NotificationAlertRepository();

  static const String naTableName = "NotificationAlert";

  Future<List<NotificationAlert>> getAllNotificationAlert() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);

    return await ref.get().then((snapshot) {
      if (snapshot.value != null) {
        List<NotificationAlert> notificationAlert =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return NotificationAlert.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        return notificationAlert;
      }
      return [];
    });
  }

  Future<List<NotificationAlert>> getAllNotificationAlertFromUserId(
      {required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);
    return await ref.get().then((snapshot) {
      if (snapshot.value != null) {
        List<NotificationAlert> notificationAlert =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return NotificationAlert.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        notificationAlert =
            notificationAlert.where((element) => element.UM_ID == uid).toList();
        return notificationAlert;
      }
      return [];
    });
  }

  Future<List<NotificationAlert>> getAllNotificationAlertByRefId(
      {required String refId, required String userId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(naTableName).get().then((snapshot) {
      if (snapshot.value != null) {
        List<NotificationAlert> userNotificationAlert =
            (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
          return NotificationAlert.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        List<NotificationAlert> newFavorites = userNotificationAlert
            .where((element) =>
                element.UM_ID == userId && element.na_refId == refId)
            .toList();

        return newFavorites;
      }
      return [];
    });
  }

/*  Future<List<NotificationAlert>> getNotificationAlert(
      {required String wsId, required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(naTableName).get().then((snapshot) {
      List<ReminderWorkouts> reminderWorkouts =
      (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<ReminderWorkouts> newCategories = reminderWorkouts
          .where((element) => element.WS_ID == wsId && element.UM_ID == umId)
          .toList();

      return newCategories;
    });
  }*/

  Future<NotificationAlert> save(
      {required NotificationAlert notificationAlert}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);

    String uuid = const Uuid().v4();

    notificationAlert.NA_ID = uuid;

    return await ref.child(uuid).set(notificationAlert.toJson()).then((value) {
      return notificationAlert;
    });
  }

  Future<NotificationAlert> update(
      {required NotificationAlert notificationAlert}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);

    return await ref
        .child(notificationAlert.NA_ID)
        .set(notificationAlert.toJson())
        .then((value) {
      return notificationAlert;
    });
  }

  Future<bool> delete({required String na_id}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);

    await ref.child(na_id).remove();
    return true;
  }

  Future<bool> deleteByUMId({required String umId}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);
    List<NotificationAlert> notificationAlert = await getAllNotificationAlert();
    for (var element in notificationAlert) {
      if (element.UM_ID == umId) {
        await delete(na_id: element.NA_ID);
      }
    }
    return true;
  }

/*  Future<bool> deleteByWSId({required String WSId}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);
    List<ReminderWorkouts> reminderWorkouts = await getAllReminderWorkouts();
    for (var element in reminderWorkouts) {
      if (element.WS_ID == WSId) {
        await delete(rw_id: element.RW_ID);
      }
    }
    return true;
  }*/

  Future<bool> isExist({required String uid, required String dateTime}) async {
    List<NotificationAlert> list = await getAllNotificationAlert();
    final result = list
        .any((element) => element.UM_ID == uid && element.na_adt == dateTime);
    return result;
  }

// Future<List<NotificationAlert>> getAllNotificationAlertIdByStartDate({required uid,required String startDateTime}) async{
//   DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);
//
//   Query query = ref.orderByChild("rw_scheduledForDay").startAfter(startDateTime);/*.endBefore(endDate,key: "sw_scheduledForDate");*/
//   return await query.get().then((snapshot) {
//     if(snapshot.value!=null) {
//       List<ReminderWorkouts> reminderWorkouts =
//       (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
//         return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
//       }).toList();
//
//       // print(scheduledWorkouts);
//       final result = reminderWorkouts.where((element) => element.UM_ID==uid && element.rw_reminderTime==setTime &&  element.rw_scheduledForDay==startDate);
//       return result.toList();
//     }
//     return [];
//   });
//
//
// }

// Future<ReminderWorkouts?> getReminderWorkoutsFromUserIdByStartDate({required uid, required String wsId,required String day}) async{
//   DatabaseReference ref = FirebaseDatabase.instance.ref(naTableName);
//
//   Query query = ref.orderByChild("rw_scheduledForDay");/*.endBefore(endDate,key: "sw_scheduledForDate");*/
//   return await query.get().then((snapshot) {
//     if(snapshot.value!=null) {
//       List<ReminderWorkouts> reminderWorkouts =
//       (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
//         return ReminderWorkouts.fromJson(Map<String, dynamic>.from(e));
//       }).toList();
//
//       // print(scheduledWorkouts);
//       final result = reminderWorkouts.where((element) => element.UM_ID==uid && element.WS_ID==wsId && element.rw_scheduledForDay==day);
//       // print('result:$result');
//       return result.isNotEmpty?result.first:null;
//     }
//     return null;
//   });
//
//
// }
}
