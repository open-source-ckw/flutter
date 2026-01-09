import 'package:get/get.dart';
import '../controller/product_favorite_controller.dart';

class ProductFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductFavoriteController());
  }
}
