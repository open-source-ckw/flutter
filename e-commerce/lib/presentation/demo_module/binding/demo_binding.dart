import 'package:get/get.dart';
import '../controller/demo_controller.dart';

class DemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DemoController());
  }
}
