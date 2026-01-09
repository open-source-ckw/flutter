import 'package:get/get.dart';
import '../../../core/app_globals.dart' as global;

class LayoutController extends GetxController{

  RxInt pageIndex = 0.obs;

  @override
  void onClose() {
    pageIndex = 0.obs;
    super.onClose();
  }

}