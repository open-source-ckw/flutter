import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacks/consts.dart';

class TermsConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        shadowColor: Colors.grey.shade50,
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Terms & Conditions",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff002347),
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                ABOUT_US,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Lorem ipsum dolor",
                style: TextStyle(
                  color: Color(0xff002347),
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 15),
              Text(
                BROWSER_EXTENSION,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              Text(
                BROWSER_EXTENSION,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
