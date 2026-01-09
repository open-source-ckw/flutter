import 'package:get/get.dart';
import '../controller/shipping_controller.dart';

class ShippingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShippingController());
  }
}
