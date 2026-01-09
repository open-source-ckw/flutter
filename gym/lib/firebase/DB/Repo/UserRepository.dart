import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../../Storage/StorageHandler.dart';
import '../Models/UserMaster.dart';
import '../Repo/SubscriptionPlans_UserMasterRepository.dart';

import 'package:image_picker/image_picker.dart';

// import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  UserRepository();

  StorageHandler storageHandler = StorageHandler();

  /*
  Future<List<UserMaster>> getAllUsers() async {
    final ref = FirebaseFirestore.instance;

    return await ref.collection("UserMaster").get().then((snapshot) {
      List<UserMaster> users =
          (snapshot.docs as Map<dynamic, dynamic>).values.map((e) {
        return UserMaster.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return users;
    });
  }
  */

  Future<List<UserMaster>> getAllUsers() async {
    final ref = FirebaseFirestore.instance.collection("UserMaster");

    final snapshot = await ref.get();

    List<UserMaster> users = snapshot.docs.map((doc) {
      return UserMaster.fromJson(doc.data());
    }).toList();

    return users;
  }


  Future<bool> isUserSignedIn(email) async {
    try {
      final result =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      return result.isNotEmpty;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<UserMaster> save({required UserMaster user}) async {
    final ref = FirebaseFirestore.instance.collection('UserMaster');

    List<UserMaster> users = await getAllUsers();
    List<String> usersId = users.map((e) => e.UM_ID).toList();
    if (usersId.contains(user.UM_ID)) {
      user = await getUserFromId(uid: user.UM_ID);
    } else {
      await ref.doc(user.UM_ID).set(user.toJson()).then((value) {
        return user;
      });
    }

    return user;
  }

  Future<UserMaster> update({required UserMaster user}) async {
    final ref = FirebaseFirestore.instance.collection('UserMaster');

    await ref.doc(user.UM_ID).set(user.toJson()).then((value) {
      return user;
    });
    return user;
  }

  /*Future<UserMaster> updateUser(File? image, UserMaster user) async {
    final _firebaseStorage = FirebaseStorage.instance;

    DatabaseReference ref =
        FirebaseDatabase.instance.ref('UserMaster/${user.UM_ID}');
    UserMaster updatedUser = user;
    // String? imageofUser = userMaster.um_image;
    if (image != null) {
      print(image);
      String? photoUrl = await uploadImage(image);
      print(photoUrl);
      updatedUser.um_image = photoUrl!.toString();
      // updatedUser = imageofUser as UserMaster;
    }
    print(user);
    // final userWithId = await query.
    await ref.update(user.toJson()).then((value) {
      ref.set(user.toJson());
      return user;
    });
    return user;
  }*/

  Future<UserMaster> updateUser(File? image, UserMaster user) async {
    final _firebaseStorage = FirebaseStorage.instance;
    final ref = FirebaseFirestore.instance
        .collection('UserMaster')
        .doc(user.UM_ID);

    UserMaster updatedUser = user;

    // Upload image if provided
    if (image != null) {
      print("Uploading image...");
      String? photoUrl = await uploadImage(image);
      print("Uploaded photo URL: $photoUrl");
      updatedUser.um_image = photoUrl ?? "";
    }

    // Update Firestore document
    await ref.set(updatedUser.toJson(), SetOptions(merge: true));

    return updatedUser;
  }

  /*Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('UserMaster');

    await ref.child(uid).remove().then((value) {
      SubscriptionPlansUserMasterRepository().deleteByUMId(umId: uid);
    });
    return true;
  }*/

  Future<bool> delete({required String uid}) async {
    final ref = FirebaseFirestore.instance.collection('UserMaster');

    await ref.doc(uid).delete();
    await SubscriptionPlansUserMasterRepository().deleteByUMId(umId: uid);

    return true;
  }


  /*Future<dynamic> getUserFromId({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('UserMaster');

    return await ref.child(uid).get().then((value) {
      print(value.value);
      if (value.value != null) {
        // return userMaster;
        UserMaster userMaster = UserMaster.fromJson(
            Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
        // print(userMaster.toString());}
        return userMaster;
      }
      return false;
    });
  }*/

  Future<dynamic> getUserFromId({required String uid}) async {
    final ref = FirebaseFirestore.instance.collection('UserMaster').doc(uid);

    final snapshot = await ref.get();

    if (snapshot.exists) {
      UserMaster userMaster =
      UserMaster.fromJson(snapshot.data() as Map<String, dynamic>);
      return userMaster;
    } else {
      return false;
    }
  }

  Future<bool> isExistByUid({required String uid}) async {
    dynamic result = await getUserFromId(uid: uid);

    return result != null;
  }

  Future<bool> isExistByEmail({required String email}) async {
    dynamic result = await getAllUsers();

    return result != null;
  }

  uploadImage(File image) async {
    final _firebaseStorage = FirebaseStorage.instance;
    // final _imagePicker = ImagePicker();
    String? imageUrl;
    // File? image;
    // XFile? image;
    // //Check Permissions
    // // await Permission.photos.request();
    //
    // // var permissionStatus = await Permission.photos.status;
    //
    //
    // image = (await _imagePicker.pickImage(source: ImageSource.gallery));
    // var file = File(image);

    //Upload to Firebase
    var snapshot =
        await _firebaseStorage.ref().child('public/$image').putFile(image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);
    // setState(() {
    //   imageUrl = downloadUrl;
    // });
    return downloadUrl;
    // if (permissionStatus.isGranted) {
    //   //Select Image
    //   image = await _imagePicker.getImage(source: ImageSource.gallery);
    //   var file = File(image!.path);
    //
    //   if (image != null){
    //     //Upload to Firebase
    //     var snapshot = await _firebaseStorage.ref()
    //         .child('images/imageName')
    //         .putFile(file);
    //     var downloadUrl = await snapshot.ref.getDownloadURL();
    //     // setState(() {
    //     //   imageUrl = downloadUrl;
    //     // });
    //     return ;
    //   } else {
    //     print('No Image Path Received');
    //   }
    // } else {
    //   print('Permission not granted. Try Again with permission access');
    // }
  }

//get URL of uploaded image
}
