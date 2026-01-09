import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:uuid/uuid.dart';

import '../Models/ActivityModel2.dart';

class Activity2Repository {
  Activity2Repository();

  static const String acTable2Name = "Activity";

  Future<List<ActivityModel2>> getAllActivity() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(acTable2Name).get().then((snapshot) {
      List<ActivityModel2> activityModel2 =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return ActivityModel2.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return activityModel2;
    });
  }

  Future<ActivityModel2> save({required ActivityModel2 activityModel2}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(acTable2Name);

    String uuid = const Uuid().v4();

    activityModel2.AC2_ID = uuid;

    print('AC_ID : $uuid');
    await ref.child(uuid).set(activityModel2.toJson()).then((value) {
      return activityModel2;
    });
    return activityModel2;
  }

  Future<ActivityModel2> update(
      {required ActivityModel2 activityModel2}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(acTable2Name);

    await ref
        .child(activityModel2.AC2_ID)
        .set(activityModel2.toJson())
        .then((value) {
      return activityModel2;
    });
    return activityModel2;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(acTable2Name);

    await ref.child(uid).remove();
    return true;
  }

  Future<ActivityModel2?> getActivityFromId({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(acTable2Name);

    await ref.child(uid).get().then((value) {
      // return category;
      ActivityModel2 activityModel2 = ActivityModel2.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
      print(activityModel2.toString());
      return activityModel2;
    });
    return null;
  }
}
