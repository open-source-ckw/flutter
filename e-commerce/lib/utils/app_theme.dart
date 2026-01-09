import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  useMaterial3: true,
  fontFamily: 'Quicksand',
  primaryColor: const Color(0xFFDB3022),
  colorScheme: ColorScheme.fromSwatch(
    accentColor: const Color(0xFFDB3022), // but now it should be declared like this
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.grey[100],
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Quicksand'),
    displayMedium: TextStyle(fontFamily: 'Quicksand'),
    displaySmall: TextStyle(fontFamily: 'Quicksand'),
    headlineLarge: TextStyle(fontFamily: 'Quicksand'),
    headlineMedium: TextStyle(fontFamily: 'Quicksand'),
    headlineSmall: TextStyle(fontFamily: 'Quicksand'),
    titleLarge: TextStyle(fontFamily: 'Quicksand'),
    titleMedium: TextStyle(fontFamily: 'Quicksand'),
    titleSmall: TextStyle(fontFamily: 'Quicksand'),
    bodyLarge: TextStyle(fontFamily: 'Quicksand'),
    labelLarge: TextStyle(fontFamily: 'Quicksand'),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFDB3022),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  sliderTheme: const SliderThemeData(
    activeTrackColor: Color(0xFFDB3022),
    inactiveTrackColor: Colors.grey,
    thumbColor: Color(0xFFDB3022),
    thumbShape: RoundSliderThumbShape(
      elevation: 0,
      pressedElevation: 0,
    ),
  ),
);
