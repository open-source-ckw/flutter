import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../Models/Exercises.dart';
import '../Models/SubscriptionPlans.dart';
import '../Repo/SubscriptionPlans_UserMasterRepository.dart';
import 'package:uuid/uuid.dart';

class SubscriptionPlansRepository {
  SubscriptionPlansRepository();

  Future<List<SubscriptionPlans>> getAllSubscriptionPlans() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("SubscriptionPlans").get().then((snapshot) {
      List<SubscriptionPlans> subscriptionPlans =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return SubscriptionPlans.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return subscriptionPlans;
    });
  }

  Future<SubscriptionPlans> save(
      {required SubscriptionPlans subscriptionPlans}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('SubscriptionPlans');

    String uuid = const Uuid().v4();

    subscriptionPlans.SP_ID = uuid;

    print('SP_ID : $uuid');

    await ref.child(uuid).set(subscriptionPlans.toJson()).then((value) {
      return subscriptionPlans;
    });
    return subscriptionPlans;
  }

  Future<SubscriptionPlans> update(
      {required SubscriptionPlans subscriptionPlans}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('SubscriptionPlans');

    await ref
        .child(subscriptionPlans.SP_ID)
        .set(subscriptionPlans.toJson())
        .then((value) {
      return subscriptionPlans;
    });
    return subscriptionPlans;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('SubscriptionPlans');

    await ref.child(uid).remove().then((value) {
      SubscriptionPlansUserMasterRepository().deleteBySPId(spId: uid);
    });
    return true;
  }

  Future<SubscriptionPlans?> getSubscriptionPlansFromId(
      {required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('SubscriptionPlans');

    await ref.child(uid).get().then((value) {
      // return category;
      SubscriptionPlans subscriptionPlans = SubscriptionPlans.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
      print(subscriptionPlans.toString());
      return subscriptionPlans;
    });
    return null;
  }
}
