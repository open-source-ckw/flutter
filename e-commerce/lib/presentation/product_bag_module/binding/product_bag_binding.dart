import 'package:get/get.dart';
import '../controller/product_bag_controller.dart';

class ProductBagBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductBagController());
  }
}
