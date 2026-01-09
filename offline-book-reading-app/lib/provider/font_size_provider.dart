import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeProvider extends ChangeNotifier {
  int _fontSize = 16;
  int _height = 1;
  bool _isBold = false;

  int get fontSize => _fontSize;
  bool get isBold => _isBold;
  int get height => _height;

  FontSizeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getInt('fontSize') ?? 16;
    _height = prefs.getInt('lineHeight') ?? 1;
    _isBold = prefs.getBool('isBold') ?? false;
    notifyListeners();
  }

  Future<void> updateFontSize(int newSize) async {
    _fontSize = newSize;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fontSize', newSize);
    notifyListeners();
  }

  Future<void> lineHeight(int newHeight) async {
    _height = newHeight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lineHeight', newHeight);
    notifyListeners();
  }

  void toggleBold(bool value) async {
    _isBold = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBold', value);
    notifyListeners();
  }
}