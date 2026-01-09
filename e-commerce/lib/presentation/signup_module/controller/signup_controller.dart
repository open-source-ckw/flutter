import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_auth.dart';

class SignupController extends GetxController{

  RxBool loading = false.obs;
  RxBool isPassObscure = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void userSignup({passName, passEmail, passPassword}) {
    loading.value = true;
    Map<String, dynamic> arrPostData = {
      'username': passName.text.trim(),
      'email': passEmail.text.trim(),
      'password': passPassword.text.trim()
    };
    UserAuthService().userSignUp(arrPostData).then((value) async {
      if (value == null) {
        showError('Something went wrong');
      } else {
        if (value.containsKey('data') == true && (value['code'] == 'existing_user_login' || value['code'] == 'existing_user_email' || value['code'] == 'rest_invalid_param')) {
          showError(value['message']);
        }
        if (value.containsKey('data') != true) {
          loading.value = false;
          showLoginSnackBar('Your account has been registered. Please login your account.', 'Success');
          Timer(const Duration(seconds: 3), () {
            Get.back(closeOverlays: true);
          });
        }
      }
    });
  }

  showError(msg) {
    showLoginSnackBar(msg, 'error');
    loading.value = false;
  }

  showLoginSnackBar(String value, String status) {
    Get.showSnackbar(
      GetSnackBar(
        message: value,
        duration: const Duration(seconds: 3),
        backgroundColor: status == "Success" ? Colors.green : Colors.red,
      ),
    );
  }

}