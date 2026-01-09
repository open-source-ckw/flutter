import 'package:flutter/material.dart';

class OneContect extends StatelessWidget {
  const OneContect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          'Contact Us to Buy and Sell',
          style: TextStyle(color: Colors.grey, fontSize: 25),
        ),
        Text(
          'Homes Online',
          style: TextStyle(color: Colors.grey, fontSize: 25),
        ),
      ]),
    );
  }
}
