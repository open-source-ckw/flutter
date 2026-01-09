import 'package:get/get.dart';
import '../controller/order_details_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderDetailsController());
  }
}
