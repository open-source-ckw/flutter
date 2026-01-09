import 'package:flutter/material.dart';

class RatingView extends StatelessWidget {
  Map<String, dynamic> productData;
  RatingView({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
                index < productData['rating_count']
                    ? Icons.star_rate_rounded
                    : Icons.star_rate_outlined,
                size: 18,
                color: index < productData['rating_count']
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400]);
          }),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          '(${productData['rating_count'].toString()})',
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
