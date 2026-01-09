import 'package:get/get.dart';
import '../controller/layout_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LayoutController());
  }
}
