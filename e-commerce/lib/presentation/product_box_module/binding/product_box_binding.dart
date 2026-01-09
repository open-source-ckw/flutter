import 'package:get/get.dart';
import '../controller/product_box_controller.dart';

class ProductBoxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductBoxController());
  }
}
