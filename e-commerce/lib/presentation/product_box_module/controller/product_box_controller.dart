import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_api_handler.dart';
import '../../../core/app_auth.dart';
import '../../../core/app_globals.dart' as global;
import '../../../core/app_globals.dart';
import '../../product_favorite_module/controller/product_favorite_controller.dart';

class ProductBoxController extends GetxController{

  final productFavoriteController = Get.put(ProductFavoriteController());

  /// Added to favorites.......
  favProduct(product){
    if(global.isWishListProduct.containsKey(product['id']) == false){
      addUFavProd(product, global.isUserData['ID']);
    } else if(global.isWishListProduct.containsKey(product['id']) == true){
      removeUFavProd(product['id'], global.isUserData['ID']);
    }
  }

  void addUFavProd(product, String uid) {
    Map<String, dynamic> data = {
      'userId' : uid,
      'productId'  : product['id'].toString(),
    };

    Future<Map<String, dynamic>> resData = UserAuthService().userFavorites(data);

    resData.then((data) {
      showAddFavSnackBar(data['success_message']);
      /// Add product in the wishlist
      isWishListProduct.addAll({product['id'] : product});
      ///getProductWishList(global.isUserData['ID']);
    });
  }

  showAddFavSnackBar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
  }

  void removeUFavProd(int pid, String uid) {
    // Set basic post data Map (MD array) variable
    Map<String, dynamic> data = {
      'userId' : uid,
      'productId'  : pid.toString(),
    };

    Future<Map<String, dynamic>> resData = UserAuthService().userRemoveFavorites(data);

    resData.then((data) {
      if (data.containsKey('success_message') == true) {
        showRemoveFavSnackBar(data['success_message']);
        global.isWishListProduct.remove(pid);
      }
      ///getProductWishList(global.isUserData['ID']);
    });
  }

  showRemoveFavSnackBar(String message) {

    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  getProductWishList(String uid){

    String url  = 'getwishlist/user/$uid?';

    Future<Map<String, dynamic>> resData = ApiHandlerService().getProductWishList(url);
    resData.then((value) {

      Map<String, dynamic> productWish = value;
      if(value.containsKey('result') == true && value['result'] != null) {
        getProductDetails(productIds : productWish['result']);
        /*global.isWishListProduct.value = productWish['result'];
        /// This code will worked only for favorite listing screen.
        if (value['result'].length == global.isWishListProduct.length) {
          //productFavoriteController.loading.value = true;
          productFavoriteController.getProductDetails(productIds : productWish['result']);
        }*/
        /*for (var i = 0; i < productWish['result'].length; i++) {
          if (global.isWishListProduct.contains(productWish['result'][i]) == false) {
            global.isWishListProduct.add(productWish['result'][i]);
          }
          /// This code will worked only for favorite listing screen.
          if (value['result'].length == global.isWishListProduct.length) {
            //productFavoriteController.loading.value = true;
            productFavoriteController.getProductDetails();
          }
        }*/
      } else {
        productFavoriteController.loading.value = false;
      }
    });
  }

  getProductDetails({productIds}) {
    //global.isWishListProduct.value = {};
    String filter = productIds.join(',');
    Future<List<dynamic>> resData = ApiHandlerService().getProductDetailsAPI(filter);
    resData.then((value) {
      for(var i=0; i < value.length; i++){
        if(value.isNotEmpty){
          global.isWishListProduct.addAll({value[i]['id'] : value[i]});
        }
      }
      //loading.value = false;
      productFavoriteController.loading.value = false;
    });
  }
}