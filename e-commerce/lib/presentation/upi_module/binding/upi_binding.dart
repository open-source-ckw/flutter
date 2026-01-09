import 'package:get/get.dart';
import '../controller/upi_controller.dart';

class UpiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpiController());
  }
}
