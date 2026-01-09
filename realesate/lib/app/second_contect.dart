import 'package:flutter/material.dart';

class Secondcontect extends StatelessWidget {
  const Secondcontect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            width: 800,
            child: Text(
              'Contact Information',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Location ',
                style: TextStyle(color: Colors.black87, fontSize: 18),
              )),
          Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Abcd Real Estate,Abc',
                style: TextStyle(color: Colors.grey, fontSize: 17),
              )),
          SizedBox(
            height: 5,
          ),
          Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Phone Number',
                style: TextStyle(color: Colors.black87, fontSize: 18),
              )),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '26-255-4731',
                style: TextStyle(color: Colors.grey, fontSize: 17),
              )),
          SizedBox(
            height: 5,
          ),
          Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Email',
                style: TextStyle(color: Colors.black87, fontSize: 18),
              )),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'DreamHome.com',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 17),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'if you found any technical difficulty please \ncontact as at',
                style: TextStyle(color: Colors.grey, fontSize: 17),
              )),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Dream@Home.com',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
