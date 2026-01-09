import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_api_handler.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_globals.dart' as global;

class ProductBagController extends GetxController{

  RxBool loading = true.obs;
  RxBool outOfStock = false.obs;

  getProductAddToCartItem() async {
    loading.value = true;
    await ApiHandlerService()
        .getProductAddToCartItems(global.addToCart[global.isUserID])
        .then((value) {
      global.addToCart[global.isUserID] = value;
      /// After get all add to cart product set subtotal.
      sumOfAllProducts();
      loading.value = false;
    });
  }

  sumOfAllProducts() {
    if (global.addToCart[global.isUserID]['simple'].isNotEmpty ||
        global.addToCart[global.isUserID]['variable'].isNotEmpty) {
      dynamic total = 0;
      dynamic qty = 0;

      global.subTotal = 0;
      global.addToCart[global.isUserID]['simple'].forEach((key, value) {
        total = double.parse(value['price']);
        if (value['stock_qty'] <= 0) {
          qty = 0;
        } else {
          qty = value['qty'];
        }

        global.subTotal += (total * qty);
      });
      global.addToCart[global.isUserID]['variable'].forEach((key, value) {
        total = double.parse(value['price']);
        if (value['stock_qty'] <= 0) {
          qty = 0;
        } else {
          qty = value['qty'];
        }
        global.subTotal += (total * qty);
      });
      update();
    }
  }

  Future incrementDecrementCounter(dynamic id, bool incDec) async {

    loading.value = true;

    /// Simple products....
    if (global.addToCart[global.isUserID].containsKey('simple') == true) {
      if (global.addToCart[global.isUserID]['simple'].containsKey(id) == true &&
          incDec == true) {
        global.addToCart[global.isUserID]['simple'][id]['qty'] =
            global.addToCart[global.isUserID]['simple'][id]['qty'] + 1;
      } else if (global.addToCart[global.isUserID]['simple'].containsKey(id) ==
          true && incDec == false) {
        global.addToCart[global.isUserID]['simple'][id]['qty'] =
            global.addToCart[global.isUserID]['simple'][id]['qty'] - 1;
      }
    }

    /// Variation products....
    if (global.addToCart[global.isUserID].containsKey('variable') == true) {
      if (global.addToCart[global.isUserID]['variable'].containsKey(id) ==
          true && incDec == true) {
        global.addToCart[global.isUserID]['variable'][id]['qty'] =
            global.addToCart[global.isUserID]['variable'][id]['qty'] + 1;
      } else if (global.addToCart[global.isUserID]['variable']
          .containsKey(id) == true && incDec == false) {
        global.addToCart[global.isUserID]['variable'][id]['qty'] =
            global.addToCart[global.isUserID]['variable'][id]['qty'] - 1;
      }
    }
    /// After increment decrement change subtotal.
    sumOfAllProducts();
    loading.value = false;

    final SharedPreferences
    prefs = await SharedPreferences.getInstance();

    /// Set data in local data.....
    String encodedMap = json.encode(global.addToCart);
    prefs.setString(addToCartCnt, encodedMap);
  }

  showDeleteProductSnackBar(pId, String value, String status) {
    Get.showSnackbar(
      GetSnackBar(
        message: value,
        borderRadius: 20,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(15),
        backgroundColor: status == "Success" ? Colors.green : Colors.red,
        icon: const Icon(Icons.delete_forever),
        mainButton: TextButton(
          child: const Text('Ok', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          onPressed: () async {
            loading.value = true;
            outOfStock.value = false;
            final SharedPreferences prefs =
            await SharedPreferences.getInstance();
            if (global.addToCart[global.isUserID]['simple']
                .containsKey(pId) ==
                true) {
              global.addToCart[global.isUserID]['simple']
                  .remove(pId);
            }
            if (global.addToCart[global.isUserID]['variable']
                .containsKey(pId) ==
                true) {
              global.addToCart[global.isUserID]['variable']
                  .remove(pId);
            }
            String encodedMap = json.encode(global.addToCart);
            prefs.setString(addToCartCnt, encodedMap);
            /// After get all add to cart product set subtotal.
            sumOfAllProducts();
            loading.value = false;
          },
        ),
      ),
    );
  }
}