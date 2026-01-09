import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_api_handler.dart';
import '../../../core/app_auth.dart';
import '../../../core/app_globals.dart' as global;
import '../../../core/app_constant.dart';
import '../../product_box_module/controller/product_box_controller.dart';

class HomeController extends GetxController{

  final productBoxController = Get.put(ProductBoxController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  RxList listCategoryImages = [].obs;
  RxList listNewProductData = [].obs;
  RxList listTrendProductData = [].obs;

  var allProductList = [].obs; // Make it an observable list

  RxInt currentPosition = 0.obs;
  final CarouselController controller = CarouselController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getCartList() async {
    final SharedPreferences pref = await _prefs;

    if (pref.getString(addToCartCnt) != null) {
      String encodedMap = pref.getString(addToCartCnt) ?? '';

      Map<dynamic, dynamic> decodedMap = jsonDecode(encodedMap);

      global.addToCart.value = decodedMap;
    }

    if(global.isLoggedIn.isTrue){
      productBoxController.getProductWishList(global.isUserData['ID']);
    }
  }

  getCategoryImages() async {
    await ApiHandlerService().getMainCategories().then((categoryList) {
      for (int i = 0; i < categoryList.length; i++) {
        if (categoryList[i]['image'] is Map &&
            categoryList[i]['image'].containsKey('src') == true) {
          listCategoryImages.add(categoryList[i]);
        }
      }
    });

    /// Random image show in the home screen
    listCategoryImages.shuffle();
    // Set the number of items you want to display
    int numberOfItemsToShow = 4; // Change this as needed
    // Take the first `numberOfItemsToShow` items from the shuffled list
    listCategoryImages.value = listCategoryImages.take(numberOfItemsToShow).toList();
  }

  getNewProduct() async {
    await ApiHandlerService().getProducts().then((productList) {
      listNewProductData.value = productList;
    });
  }

  getTrendProduct() async {
    await ApiHandlerService().getTrendyProducts().then((trendyProductsList) {
      listTrendProductData.value = trendyProductsList;
    });
  }

  Future<void> pullRefresh() async {
    getCategoryImages();
    getNewProduct();
    getTrendProduct();
    await Future.delayed(const Duration(seconds: 2));
  }

  getAllProducts() async {
    final newProducts = ApiHandlerService().getProducts();
    final trendyProducts = ApiHandlerService().getTrendyProducts();

    final results = await Future.wait([newProducts, trendyProducts]);

      listNewProductData.value = results[0];
      listTrendProductData.value = results[1];
  }

}