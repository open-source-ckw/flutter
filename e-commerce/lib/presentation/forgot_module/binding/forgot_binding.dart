import 'package:get/get.dart';
import '../controller/forgot_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController());
  }
}
