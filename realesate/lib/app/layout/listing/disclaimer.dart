import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  Map<String, dynamic> mapData = {};

  Disclaimer(this.mapData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Disclaimer',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
              ),
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "India's Dreams Homes Estate: a magnuficent 4+ acrs parcel directly on Biscayane Bay that is comprised of 2 homes,Downtown India.",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  )),
            ]));
  }
}
