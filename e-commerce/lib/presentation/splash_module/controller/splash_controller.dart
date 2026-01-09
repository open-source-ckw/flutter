import 'dart:async';
import 'dart:convert';
import 'package:fashionia/presentation/layout_module/layout_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_globals.dart' as global;
import '../../introduction_module/introduction_view.dart';
import '../../login_module/login_view.dart';

class SplashController extends GetxController{

  @override
  void onInit() {
    getUserStatus();
    getLoginScreenSkipStatus().then((value) {
      global.isLoginSkip = value;
    });
    getSplashScreenStatus().then((value) {
      global.isSplash = value;
    });
    super.onInit();
  }

  Future<String?> getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('isLogData') != null){
      var userDetails = jsonDecode(prefs.getString('isLogData') ?? '');
      global.isLoggedIn.value = prefs.getBool('IsLogged')!;
      global.isUserData.value = userDetails;
      if(global.isUserData.isNotEmpty) {
        global.isUserID = global.isUserData['ID'];
      } else {
        global.isUserID = '0';
      }
      navigationOtherView();
    } else {
      navigationOtherView();
    }
    return null;
  }

  // Gets the splash screen in status
  Future<bool> getSplashScreenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    bool isSplash = prefs.getBool('isSplash') ?? false;
    return isSplash;
  }

  // Gets the login screen skip status
  Future<bool> getLoginScreenSkipStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    bool isSplash = prefs.getBool('isLoginSkip') ?? false;
    return isSplash;
  }

  navigationOtherView() {
    Timer(const Duration(seconds: 3), (){
      if(global.isSplash != true){
        Get.offAllNamed(IntroductionView.route);
      } else {
        Get.offAllNamed((global.isLoggedIn.value || global.isLoginSkip) ? LayoutView.route : LoginView.route);
      }
    });
  }
}