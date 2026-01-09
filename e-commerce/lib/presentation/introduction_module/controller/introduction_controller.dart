import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login_module/login_view.dart';

class IntroductionController extends GetxController{
  SharedPreferences? prefs;
  var currentPage = 0.obs;
  //int currentPage = 0;

  List imageArr = [
    'assets/two-fashionable-young-women-casual-trendy-spring-coat-boots-with-heels-black-hat-stylish-handbag.jpg',
    'assets/beautiful-fashion-woman-posing-with-elegant-suit.jpg',
    'assets/vertical-portrait-young-stylish-girl-grey-background-high-quality-photo.jpg',
  ];

  List<String> title = [
    'We provide high quality product for you',
    'Your choice is our first priority',
    'Search your fashion style on fashionia right now!'
  ];

  List<String> description = [
    'Next',
    'Next',
    'Get Started',
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  navigateLoginPage() {
    storeSplashScreenStatus(true);
    Get.offAllNamed(LoginView.route);
  }

  // Sets the Splash screen status
  void storeSplashScreenStatus(bool isSplash) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setBool('isSplash', isSplash);
  }
}