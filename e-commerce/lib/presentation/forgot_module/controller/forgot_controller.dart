import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_auth.dart';

class ForgotPasswordController extends GetxController{

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }


  forgotPassword({passEmail}) async {
    loading.value = true;
    Map<String, dynamic> data = {'login': passEmail.text.trim()};
    await UserAuthService().userForgotPassword(data).then((value) async {
      if(value == null){
        showError('Something went wrong');
      } else if(value.containsKey('code') == true && value['code'] == '101'){
        showError(value['msg']);
      } else if (value.containsKey('code') == true && value['code'] == '200'){
        loading.value = false;
        showLoginSnackBar(value['msg'], 'Success');
        await Future.delayed(
          const Duration(seconds: 3),
        );
        Get.back(closeOverlays: true);
      }
    });

  }

  /// Snackbar message.......
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