import 'package:flutter/material.dart';

class Theme extends StatelessWidget {
  const Theme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xFF3ee7b7),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white, fontSize: 20),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 15),
            titleMedium: TextStyle(color: Colors.grey, fontSize: 15),
          )),
    );
  }
}
