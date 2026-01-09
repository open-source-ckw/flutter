import 'package:flutter/material.dart';

class TopCarousalEntity {
  String id;
  String heading;
  String subText;
  String buttonText;
  Color backgroundColor;
  String image;

  TopCarousalEntity(
      {required this.id,
      required this.heading,
      required this.subText,
      required this.buttonText,
      required this.backgroundColor,
      required this.image});
}
