import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final GestureTapCallback onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = 0, required this.onRatingChanged, this.color = const Color(0xffFFB34B)});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    double iconSize = 16;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: color,
        size: iconSize,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color,
        size: iconSize,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color,
        size: iconSize,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged,
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (rating == 0) {
      return Container();
    }
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
