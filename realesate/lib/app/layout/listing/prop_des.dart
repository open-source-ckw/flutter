import 'package:flutter/material.dart';

class PropDescription extends StatelessWidget {
  Map<String, dynamic> mapData = {};

  PropDescription(this.mapData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Description',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(mapData['Description'] ?? '',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
          ]),
    );
  }
}
