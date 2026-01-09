import 'package:flutter/material.dart';

class WorkoutsEntity {
  dynamic id;
  String image;
  String text;
  String subtext;
  String duration;
  bool isFavorite;
  Color backgroundColor;
  String discription;

  WorkoutsEntity(
      {required this.id,
      required this.image,
      required this.text,
      required this.subtext,
      required this.duration,
      required this.isFavorite,
      required this.backgroundColor,
      required this.discription});
}
