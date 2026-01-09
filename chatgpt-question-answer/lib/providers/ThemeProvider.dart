import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  // ThemeMode themeMode = ThemeMode.system;
  //
  // static const Color darkBGColor = Color(0xff0B152A);
  // static const Color darkBoxColor = Color(0xff404040);
  //
  // bool get isDarkMode {
  //   if (themeMode == ThemeMode.system) {
  //     final brightness = SchedulerBinding.instance.window.platformBrightness;
  //     return brightness == Brightness.dark;
  //   } else {
  //     return themeMode == ThemeMode.dark;
  //   }
  // }
  //
  // void toggleTheme(bool isOn) {
  //   themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
  //   notifyListeners();
  // }
}

class MyThemes {
  static final darkTheme = ThemeData(
    // scaffoldBackgroundColor: Color(0xff090d15),
    scaffoldBackgroundColor: Color(0xff0e1420),
    appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 3),
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xffedf2f4),
    //scaffoldBackgroundColor: Color(0xffF3F5F6),
    // scaffoldBackgroundColor: Color(0xffF6F6FF),
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
  );
}
