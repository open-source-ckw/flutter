import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SplashProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> initializeApp() async {
    // Example: simulate loading (API call, auth check, etc.)
    await Future.delayed(const Duration(milliseconds: 3500));

    _isLoading = false;
    notifyListeners();
  }
}
