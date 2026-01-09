import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../Models/Equipments.dart';
import 'Exercises_EquipmentsRepository.dart';

class EquipmentsRepository {
  EquipmentsRepository();

  Future<List<Equipments>> getAllEquipments() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    return await ref.child("Equipments").get().then((snapshot) {
      // print(snapshot.value);
      List<Equipments> equipments =
          (snapshot.value as Map<dynamic, dynamic>).values.map((e) {
        return Equipments.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return equipments;
    });
  }

  Future<Equipments> save({required Equipments equipments}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Equipments');

    String uuid = const Uuid().v4();

    equipments.EQ_ID = uuid;
    print('EQ_ID : $uuid');

    await ref.child(uuid).set(equipments.toJson()).then((value) {
      return equipments;
    });
    return equipments;
  }

  Future<Equipments> update({required Equipments equipments}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Equipments');

    await ref.child(equipments.EQ_ID).set(equipments.toJson()).then((value) {
      return equipments;
    });
    return equipments;
  }

  Future<bool> delete({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Equipments');

    await ref.child(uid).remove().then((value) {
      ExercisesEquipmentsRepository().deleteByEQId(eqId: uid);
    });
    return true;
  }

  Future<Equipments> getEquipmentsFromId({required String uid}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Equipments');

    return await ref.child(uid).get().then((value) {
      // return category;
      Equipments equipments = Equipments.fromJson(
          Map<String, dynamic>.from(value.value as Map<dynamic, dynamic>));
      return equipments;
    });
  }
}
