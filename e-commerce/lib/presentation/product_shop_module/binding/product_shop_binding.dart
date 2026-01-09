import 'package:get/get.dart';
import '../controller/product_shop_controller.dart';

class ProductShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductShopController());
  }
}
