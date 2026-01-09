import 'package:get/get.dart';

String isUserID = '0';

bool isSplash = false;
RxBool isLoggedIn = false.obs;
bool isLoginSkip = false;

//Map<String, dynamic> isUserData = {};
RxMap isUserData = {}.obs;
//Map<String, dynamic> addToCart = {};
RxMap addToCart = {}.obs;
Map mapConfig = {};

//List<dynamic> isWishListProduct = [];
//RxList isWishListProduct = [].obs;
RxMap isWishListProduct = {}.obs;

/// Calculate total amount of products....
dynamic subTotal = 0;
dynamic grandTotal = 0;