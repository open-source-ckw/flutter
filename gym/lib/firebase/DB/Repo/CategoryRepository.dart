import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:uuid/uuid.dart';

import '../Models/Categories.dart';
import 'Exercises_CategoriesRepository.dart';

class CategoryRepository {
  CategoryRepository();

  Future<List<Categories>> getAllCategories() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("Categories").get().then((snapshot) {
      List<Categories> categories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Categories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return categories;
    });
  }

  Future<List<Categories>> getAllCategoriesWIthQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    Query query = ref.orderByChild("Categories").equalTo("cs_name");
    return await ref.child("Categories").get().then((snapshot) {
      List<Categories> categories =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Categories.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return categories;
    });
  }

  Future<Categories> save({required Categories category}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Categories');

    String uuid = const Uuid().v4();

    category.CS_ID = uuid;

    print('CS_ID : $uuid');
    await ref.child(uuid).set(category.toJson()).then((value) {
      return category;
    });
    return category;
  }

  Future<Categories> update({required Categories category}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Categories');

    await ref.child(category.CS_ID).set(category.toJson()).then((value) {
      return category;
    });
    return category;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Categories');

    await ref.child(uid).remove().then((value) {
      ExercisesCategoriesRepository().deleteByCSId(csId: uid);
    });
    return true;
  }

  Future<Categories> getCategoryFromId({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Categories');

    return await ref.child(uid).get().then((value) {
      // return category;
      Categories category = Categories.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
      return category;
    });
  }
}
