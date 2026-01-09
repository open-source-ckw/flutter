import 'package:get/get.dart';
import '../controller/internet_connectivity_controller.dart';
import '../internet_connectivity_view.dart';

class InternetConnectivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InternetConnectivityController());
    // TODO: implement dependencies
    Get.lazyPut<GetXNetworkManager>(() => GetXNetworkManager());
  }
}
