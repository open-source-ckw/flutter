import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_globals.dart' as global;
import '../../../core/app_api_handler.dart';

class ProductDetailsController extends GetxController{

  RxBool loading = true.obs;
  RxBool loadingMore = false.obs;
  String? productDescription;
  RxString selProSize = ''.obs;
  RxString selProColor = ''.obs;
  RxString cartBtnLabel = 'Add To Cart'.obs;
  final formKey = GlobalKey<FormState>();

  /// First image of carousal....
  ScrollController? scrollController;
  ScrollController? scrollControllerSlider;
  int initPhoto = 0;
  List<dynamic> imgList = [];

  String selSizeAttr = '';
  String selColorAttr = '';
  Map<String, dynamic> attrList = {};
  RxList similarProduct = [].obs;
  List<dynamic> listProVariation = [];
  Map<String, dynamic> reviewProduct = {};
  RxMap<dynamic, dynamic> mapProVariation = {}.obs;
  List<dynamic> variationProductsList = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    loading = true.obs;
    similarProduct = [].obs;
    imgList = [];
    selProSize = ''.obs;
    selProColor = ''.obs;
    attrList = {};
    mapProVariation = {}.obs;
    cartBtnLabel = 'Add To Cart'.obs;
    super.onClose();
  }

  getProductVariation(productID) {
    Future<List<dynamic>> listVariation =
    ApiHandlerService().getProductVariation(productID);

    listVariation.then((value) {
      if (value.isNotEmpty) {
        for (var i = 0; i < value.length; i++) {
          if (value[i]['attributes'].length > 0) {
            String attrColor = '';
            String attrClothSize = '';
            for (var j = 0; j < value[i]['attributes'].length; j++) {
              /// Checking attribute name with API data and set the variable......
              /// Set attributes key and attributes variant data.......
              if (value[i]['attributes'][j]['name'] == 'Colors') {
                attrColor = value[i]['attributes'][j]['option'].toUpperCase();
              } else if (value[i]['attributes'][j]['name'] == 'ClothingSize') {
                attrClothSize = value[i]['attributes'][j]['option'].toUpperCase();
              }

              /// Old code of dynamic attribute set with attributes key.......
              /*if (attrConcat != ''){
                attrConcat += '|' + value[i]['attributes'][j]['option'];
              } else {
                attrConcat += value[i]['attributes'][j]['option'];
              }*/
            }
            mapProVariation.addAll({attrClothSize + '|' + attrColor: value[i]});
          }
        }
      }

      listProVariation = value;
      loading.value = false;
      mapProVariation;
    });
  }

  createOptions({passData}) {
    if (passData.containsKey('attributes') == true &&
        passData['attributes'] is List &&
        passData['attributes'].length >= 0) {
      for (var i = 0; i < passData['attributes'].length; i++) {
        attrList.addAll({
          passData['attributes'][i]['name']:
          passData['attributes'][i]['options']
        });
      }

      /// Selected value show colors and size.
      if (attrList.containsKey('Colors') == true) {
        selProColor.value = attrList['Colors'][0].toUpperCase();
      }
      if (attrList.containsKey('ClothingSize') == true) {
        selProSize.value = attrList['ClothingSize'][0].toUpperCase();
      }
    }
  }

  /// ------- Similar product list ------------------
  getSimilarProduct({passData}) {
    String sPid = passData['related_ids']
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(" ", "");
    String filters = '$sPid&per_page=4';
    Future<List<dynamic>> apiGetSimilarProduct =
    ApiHandlerService().getProductDetailsAPI(filters);
    apiGetSimilarProduct.then((value) {
      print('-- value --');
      print(value);
      similarProduct.value = value;
    });
  }

  /// ------- Reduce HTML Tag to string ------------
  //here goes the function
  String? parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String? parsedString =
        parse(document.body?.text).documentElement?.text;
    return parsedString;
  }

  addToCartProduct({item, productData}) async {
    loadingMore.value = true;
    /// This logic show
    /// Ex : {UserID : {Simple : {productId : {name, price, price, quantity}},
    ///                 Variable : {productId : {variationId : {name, price, price, quantity}}}}}
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (global.addToCart.containsKey(addToCartCnt) == true &&
        global.mapConfig[addToCartCnt].containsKey(item) == true) {
    } else {
      if (global.addToCart[global.isUserID][productData['type']].isNotEmpty) {
        /// All ready added product id in the variation
        if(global.addToCart[global.isUserID][productData['type']].containsKey(productData['id'].toString()) == true){
          global.addToCart[global.isUserID][productData['type']][productData['id'].toString()]
              .addAll(item[productData['id'].toString()]);
        } else {
          global.addToCart[global.isUserID][productData['type']]
              .addAll(item);
        }
        String encodedMap = json.encode(global.addToCart);
        prefs.setString(addToCartCnt, encodedMap);
      } else {
        global.addToCart[global.isUserID][productData['type']].addAll(item);
        String encodedMap = jsonEncode(global.addToCart);
        prefs.setString(addToCartCnt, encodedMap);
      }
    }

    loadingMore.value = false;
  }
}