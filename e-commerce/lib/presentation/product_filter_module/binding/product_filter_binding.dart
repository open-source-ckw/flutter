import 'package:get/get.dart';
import '../controller/product_filter_controller.dart';

class ProductFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductFilterController());
  }
}
