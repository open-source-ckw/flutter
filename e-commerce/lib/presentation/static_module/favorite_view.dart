import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/app_globals.dart' as global;
import '../login_module/login_view.dart';
import '../product_box_module/controller/product_box_controller.dart';

class FavoriteIconView extends StatelessWidget {
  final productBoxController = Get.put(ProductBoxController());
  Map<String, dynamic> productData;
  FavoriteIconView({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FaIcon favIcon = const FaIcon(
      FontAwesomeIcons.heart,
      color: Colors.grey,
      size: 20,
    );
    FaIcon favIconSolid = FaIcon(
      FontAwesomeIcons.solidHeart,
      color: Theme.of(context).primaryColor,
      size: 20,
    );

    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: Colors.white,
      onPressed: () {
        if(global.isLoggedIn.isTrue){
          productBoxController.favProduct(productData);
        } else {
          Get.toNamed(LoginView.route)?.then((value){
            if(value == true) {
              productBoxController.getProductWishList(global.isUserData['ID']);
              productBoxController.favProduct(productData);
            }
          });
        }
      },
      child: Obx(() => (global.isWishListProduct.isNotEmpty &&
          global.isWishListProduct.containsKey(productData['id']) == true) ? favIconSolid : favIcon),
    );
  }
}
