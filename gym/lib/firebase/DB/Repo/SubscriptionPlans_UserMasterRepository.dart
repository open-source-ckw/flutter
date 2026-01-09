import 'package:firebase_database/firebase_database.dart';
import '../Models/SubscriptionPlans_UserMaster.dart';
import 'package:uuid/uuid.dart';

class SubscriptionPlansUserMasterRepository {
  SubscriptionPlansUserMasterRepository();

  static const String spUmTableName = "SubscriptionPlans_UserMaster";

  Future<List<SubscriptionPlansUserMaster>>
      getAllSubscriptionPlansUserMaster() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(spUmTableName).get().then((snapshot) {
      List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return SubscriptionPlansUserMaster.fromJson(
            Map<String, dynamic>.from(e));
      }).toList();

      return subscriptionPlansUserMaster;
    });
  }

  Future<List<SubscriptionPlansUserMaster>>
      getAllSubscriptionPlansUserMasterBySPId({required String spId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(spUmTableName).get().then((snapshot) {
      List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return SubscriptionPlansUserMaster.fromJson(
            Map<String, dynamic>.from(e));
      }).toList();

      List<SubscriptionPlansUserMaster> newCategories =
          subscriptionPlansUserMaster
              .where((element) => element.SP_ID == spId)
              .toList();

      return newCategories;
    });
  }

  Future<List<SubscriptionPlansUserMaster>>
      getAllSubscriptionPlansUserMasterByUMId({required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(spUmTableName).get().then((snapshot) {
      List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return SubscriptionPlansUserMaster.fromJson(
            Map<String, dynamic>.from(e));
      }).toList();

      List<SubscriptionPlansUserMaster> newCategories =
          subscriptionPlansUserMaster
              .where((element) => element.UM_ID == umId)
              .toList();

      return newCategories;
    });
  }

  Future<List<SubscriptionPlansUserMaster>> getSubscriptionPlansUserMaster(
      {required String spId, required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(spUmTableName).get().then((snapshot) {
      List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return SubscriptionPlansUserMaster.fromJson(
            Map<String, dynamic>.from(e));
      }).toList();

      List<SubscriptionPlansUserMaster> newCategories =
          subscriptionPlansUserMaster
              .where(
                  (element) => element.SP_ID == spId && element.UM_ID == umId)
              .toList();

      return newCategories;
    });
  }

  Future<SubscriptionPlansUserMaster> save(
      {required SubscriptionPlansUserMaster
          subscriptionPlansUserMaster}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(spUmTableName);

    String uuid = const Uuid().v4();

    subscriptionPlansUserMaster.SP_UM_ID = uuid;

    return await ref
        .child(uuid)
        .set(subscriptionPlansUserMaster.toJson())
        .then((value) {
      return subscriptionPlansUserMaster;
    });
  }

  Future<SubscriptionPlansUserMaster> update(
      {required SubscriptionPlansUserMaster
          subscriptionPlansUserMaster}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(spUmTableName);

    return await ref
        .child(subscriptionPlansUserMaster.SP_UM_ID)
        .set(subscriptionPlansUserMaster.toJson())
        .then((value) {
      return subscriptionPlansUserMaster;
    });
  }

  Future<bool> delete({required String spUmId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(spUmTableName);

    await ref.child(spUmId).remove();
    return true;
  }

  Future<bool> deleteBySPId({required String spId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(spUmTableName);
    List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster =
        await getAllSubscriptionPlansUserMaster();
    for (var element in subscriptionPlansUserMaster) {
      if (element.SP_ID == spId) {
        await delete(spUmId: element.SP_UM_ID);
      }
    }
    return true;
  }

  Future<bool> deleteByUMId({required String umId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(spUmTableName);
    List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster =
        await getAllSubscriptionPlansUserMaster();
    for (var element in subscriptionPlansUserMaster) {
      if (element.UM_ID == umId) {
        await delete(spUmId: element.SP_UM_ID);
      }
    }
    return true;
  }
}
