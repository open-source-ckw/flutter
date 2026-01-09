import 'dart:convert';
import 'package:fashionia/presentation/layout_module/layout_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_auth.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_globals.dart' as global;
import '../../static_module/important_dialog_app.dart';

class LoginController extends GetxController{
  SharedPreferences? prefs;
  RxBool loading = false.obs;
  RxBool isPassObscure = true.obs;

  @override
  void onInit() {
    Future.delayed(Duration.zero, () {
      importantDialogApp();
    });
    super.onInit();
  }

  submitLoginForm({email, password}) async {
    loading.value = true;
    Map<String, dynamic> data = {'username': email.text, 'password': password.text};
    Future<Map<String, dynamic>> result = UserAuthService().userLogin(data);

    await result.then((value) async {
      if(value == null){
        loading.value = false;
        showError('Something went wrong');
      } else if(value.containsKey('error_message') == true){
        loading.value = false;
        showError(value['error_message']);
      } else if (value.containsKey('ID') == true){
        var userData = jsonEncode(value);
        await _storeUserDetails(userData);
        await Future.delayed(
          const Duration(seconds: 3),
        );
        loading.value = false;
        if(global.isLoginSkip == true){
          //Navigator.pop(context, true);
          Get.back(canPop: true, result: true);
        } else {
          Get.offAllNamed(LayoutView.route);
          //Navigator.pushReplacementNamed(context, LayOutPage.route);
        }
      }
    });
  }

  // Sets the login status
  Future<void> _storeUserDetails(userD) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setString('isLogData', userD);
    prefs?.setBool('IsLogged', true);
    /// Add to cart data prepared....
    _getLoginStatus();
  }

  Future<String> _getLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    var userDetails = jsonDecode(prefs?.getString('isLogData') ?? '');
    global.isUserData.value = userDetails;
    global.isLoggedIn.value = prefs?.getBool('IsLogged') ?? false;
    await preAddToCart(userID: global.isUserData['ID']);
    return prefs?.getString('isLogData') ?? '';
  }

  // Sets the login screen skip status
  void storeSkipScreenStatus(bool isSkip) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setBool('isLoginSkip', isSkip);
    await preAddToCart(userID: '0');
    _getSkipScreenStatus();
  }

  _getSkipScreenStatus() async {
    prefs = await SharedPreferences.getInstance();
    global.addToCart.value = jsonDecode(prefs?.getString(addToCartCnt) ?? '');
    global.isLoginSkip = prefs?.getBool('isLoginSkip') ?? false;
  }

  preAddToCart({userID}) async {
    prefs = await SharedPreferences.getInstance();
    /// {userID : {Simple : {ProductId: qty}, Variable : {ProductId: qty}}}
    Map<String, dynamic> addToCartMap = {};
    if(global.addToCart.isNotEmpty){
      addToCartMap = {
        userID : global.addToCart[global.isUserID],
      };
    } else {
      addToCartMap = {
        userID : {
          'simple' : {},
          'variable': {}
        }
      };
    }
    global.isUserID = userID;

    String encodedMap = json.encode(addToCartMap);
    prefs?.setString(addToCartCnt, encodedMap);
    await _getPreAddToCart();
  }

  _getPreAddToCart() async {
    prefs = await SharedPreferences.getInstance();
    global.addToCart.value = jsonDecode(prefs?.getString(addToCartCnt) ?? '');
  }

  showError(msg) {
    showLoginSnackBar(msg, 'error');
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