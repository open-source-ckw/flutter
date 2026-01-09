import 'package:flutter/material.dart';

class CThemeData {
  late ThemeData appThemeData;

  getTheme(data) {
    if (data.length > 0) {
      appThemeData = ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF3F5F8)),
        primaryColor: hexColor(data['color_primary']),
        primaryColorLight: hexColor(data['color_secondary']),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: hexColor(data['color_font_basic']), fontSize: 20),
          bodyMedium: TextStyle(
              color: hexColor(data['color_font_basic']), fontSize: 15),
          titleMedium:
              TextStyle(color: hexColor(data['color_white']), fontSize: 15),
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: const TextStyle(color: Colors.red),
          focusColor: Colors.red,
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.red, style: BorderStyle.solid),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.red, style: BorderStyle.none),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color(0xFF000000),
                width: 0.0,
                style: BorderStyle.none
            ),
            borderRadius: BorderRadius.circular(10),
          ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 0.0,
                  style: BorderStyle.none
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIconColor: Colors.grey,
            suffixIconColor: Colors.grey,
            errorStyle: const TextStyle(fontSize: 11),
            errorMaxLines: 2
        ),
        colorScheme: ColorScheme.fromSwatch(errorColor: hexColor(data['color_red']),).copyWith(error: Colors.red, primary: hexColor(data['color_primary']), secondary: hexColor(data['color_secondary'])),
      );
    } else {
      appThemeData = ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xFF3ee7b7),
        scaffoldBackgroundColor: Colors.white70,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 20),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 15),
          titleMedium: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }
  }

  //color_primary
  Color hexColor(String hXColor) {
    return Color(int.parse(hXColor.toUpperCase().replaceAll('#', '0xFF')));
  }
}
