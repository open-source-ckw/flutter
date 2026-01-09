import 'package:get/get.dart';
import '../controller/photo_gallery_controller.dart';

class PhotoGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhotoGalleryController());
  }
}
