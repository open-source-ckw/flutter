import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacks/consts.dart';

class AboutUs extends StatelessWidget {
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
          "About Stacks",
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
              Image.asset("images/stacks-logo.png", height: 100, width: 100),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "STACKS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff002347),
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
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
                "Browser Extension",
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
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(75,5,75,5),
                    child: Text(
                      "DOWNLOAD EXTENSION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff5ed6d5),
                        fontSize: 16,
                        letterSpacing: 0.80,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Color(0xff56d3d2))))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
