import 'dart:async';
import 'dart:convert';

import 'package:fashionia/presentation/login_module/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_auth.dart';
import '../../../core/app_globals.dart' as global;

class AppSettingsController extends GetxController{
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    isLoading = false.obs;
    super.onClose();
  }

  void userProfileUpdate({arrPostData}) {
    isLoading.value = true;

    UserAuthService().userEditSignUp(arrPostData).then((value) {
      if (value == null) {
        showError('Something went wrong');
      } else {
        if (value.containsKey('data') == true && value['data']['status'] == 400) {
          showError(value['message']);
        }
        if (value.containsKey('data') != true) {
          showLoginSnackBar('User are successfully updated.', 'Success');

          if(value['name'] != ''){
            global.isUserData['display_name'] = value['name'];
            global.isUserData['user_url'] = value['url'];
          }

          isLoading.value = false;
          /*Timer(const Duration(milliseconds: 1000), () {
            Get.back();
          });*/
        }
      }
    });
  }

  void userAccountDelete({arrPostData}) {

    isLoading.value = true;

    UserAuthService().userDeleteAccount(arrPostData).then((value) async {
      if (value == null) {
        showError('Something went wrong');
      } else {
        if (value.containsKey('data') == true && value['data']['status'] == 400) {
          showError(value['message']);
        }
        if (value.containsKey('data') != true) {
          showLoginSnackBar('Your user are successfully deleted.', 'Success');

          if(value['name'] != ''){
            global.isUserData['display_name'] = value['name'];
            global.isUserData['user_url'] = value['url'];
          }

          await storeUserDetails();

          isLoading.value = false;
          Get.offAllNamed(LoginView.route);
        }
      }
    });
  }

  /// After logout button click process......................
  Future<void> storeUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = {};
    global.isWishListProduct.value = {};
    pref.setString('isLogData', data.toString());
    pref.setBool('IsLogged', false);
    pref.setBool('isLoginSkip', false);
    await _getLoginStatus();
  }

  Future<String> _getLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userDetails = jsonDecode(pref.getString('isLogData') ?? '');
    global.isUserData.value = userDetails;
    global.isLoggedIn.value = pref.getBool('IsLogged') ?? false;
    global.isLoginSkip = pref.getBool('isLoginSkip') ?? false;
    return pref.getString('isLogData') ?? '';
  }

  showError(msg) {
    showLoginSnackBar(msg, 'error');
    isLoading.value = false;
  }

  showLoginSnackBar(String value, String status) {
    Get.showSnackbar(
      GetSnackBar(
        message: value,
        borderRadius: 20,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(15),
        backgroundColor: status == "Success" ? Colors.green : Colors.red,
      ),
    );
  }
}