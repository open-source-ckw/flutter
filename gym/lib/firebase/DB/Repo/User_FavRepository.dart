import 'package:firebase_database/firebase_database.dart';
import '../Models/User_Fav.dart';
import 'package:uuid/uuid.dart';

class User_FavRepository {
  User_FavRepository();

  static const String userFavTableName = "User_Favorite";

  Future<List<User_Fav>> getAllUser_Fav() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(userFavTableName).get().then((snapshot) {
      List<User_Fav> user_Fav =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return User_Fav.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return user_Fav;
    });
  }

  Future<List<User_Fav>> getAllUserMasterWorkoutFromUserId(
      {required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(userFavTableName);

    return await ref.get().then((snapshot) {
      List<User_Fav> user_Fav =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return User_Fav.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      user_Fav = user_Fav.where((element) => element.UM_ID == uid).toList();
      return user_Fav;
    });
  }

  Future<List<User_Fav>> getAllFavoriteByRefId(
      {required String spId, required String userId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child(userFavTableName).get().then((snapshot) {
      List<User_Fav> userFav =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return User_Fav.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      List<User_Fav> newFavorites = userFav
          .where((element) => element.UM_ID == userId && element.REF_ID == spId)
          .toList();

      return newFavorites;
    });
  }

  // Future<List<SubscriptionPlansUserMaster>> getAllSubscriptionPlansUserMasterByUMId(
  //     {required String umId}) async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref();
  //
  //   return await ref.child(userFavTableName).get().then((snapshot) {
  //     List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster = (snapshot.value as Map<
  //         dynamic,
  //         dynamic>).values.map((e) {
  //       return SubscriptionPlansUserMaster.fromJson(
  //           Map<String, dynamic>.from(e));
  //     }).toList();
  //
  //     List<SubscriptionPlansUserMaster> newCategories = subscriptionPlansUserMaster.where((
  //         element) => element.UM_ID == umId).toList();
  //
  //
  //     return newCategories;
  //   });
  //
  // }

  // Future<List<SubscriptionPlansUserMaster>> getSubscriptionPlansUserMaster(
  //     {required String spId, required String umId}) async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref();
  //
  //   return await ref.child(userFavTableName).get().then((snapshot) {
  //     List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster = (snapshot.value as Map<
  //         dynamic,
  //         dynamic>).values.map((e) {
  //       return SubscriptionPlansUserMaster.fromJson(
  //           Map<String, dynamic>.from(e));
  //     }).toList();
  //
  //     List<SubscriptionPlansUserMaster> newCategories = subscriptionPlansUserMaster.where((
  //         element) => element.SP_ID == spId && element.UM_ID == umId).toList();
  //
  //
  //     return newCategories;
  //   });
  // }

  Future<User_Fav> save({required User_Fav user_Fav}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(userFavTableName);

    String uuid = const Uuid().v4();

    user_Fav.FAV_ID = uuid;

    return await ref.child(uuid).set(user_Fav.toJson()).then((value) {
      return user_Fav;
    });
  }

  Future<User_Fav> update({required User_Fav user_Fav}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(userFavTableName);

    return await ref
        .child(user_Fav.FAV_ID)
        .set(user_Fav.toJson())
        .then((value) {
      return user_Fav;
    });
  }

  Future<bool> delete({required String favId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(userFavTableName);

    await ref.child(favId).remove();
    return true;
  }

// Future<bool> deleteBySPId({required String spId}) async {
//   DatabaseReference ref = FirebaseDatabase.instance.ref(userFavTableName);
//   List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster = await getAllSubscriptionPlansUserMaster();
//   for (var element in subscriptionPlansUserMaster){
//     if(element.SP_ID==spId){
//       await delete(spUmId: element.SP_UM_ID);
//     }
//   }
//   return true;
// }
// Future<bool> deleteByUMId({required String umId}) async {
//   DatabaseReference ref = FirebaseDatabase.instance.ref(userFavTableName);
//   List<SubscriptionPlansUserMaster> subscriptionPlansUserMaster = await getAllSubscriptionPlansUserMaster();
//   for (var element in subscriptionPlansUserMaster){
//     if(element.UM_ID==umId){
//       await delete(spUmId: element.SP_UM_ID);
//     }
//   }
//   return true;
// }
}
