import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_auth.dart';
import '../../../core/app_globals.dart' as global;

class ShippingController extends GetxController{
  RxBool loading = false.obs;
  Map<String, dynamic> shippingData = {};

  @override
  void onClose() {
    super.onClose();
  }

  getShippingData() async {
    loading.value = true;
    await UserAuthService().getCustomer(userID: global.isUserData['ID'].toString()).then((customerData) {
      shippingData = customerData;
      loading.value = false;
    });
  }

  editShippingData({passMapData}) async {
    loading.value = true;
    await UserAuthService().userEditCustomer(data: passMapData).then((customerData) {
      Timer(const Duration(seconds: 3), () {
        Get.back(result: true);
        loading.value = false;
        showMessageSnackBar('Shipping address changed successfully.', 'Success');
      });
    });
  }

  showMessageSnackBar(String value, String status) {
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