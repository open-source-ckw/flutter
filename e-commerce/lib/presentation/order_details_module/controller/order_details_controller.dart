import 'package:get/get.dart';
import '../../../core/app_api_handler.dart';

class OrderDetailsController extends GetxController {

  RxBool isLoading = false.obs;
  RxMap orderProductItems = {}.obs;

  getProductOrderItem({passingAPIData}) async {
    isLoading.value = true;
    await ApiHandlerService().getProductOrderListItems(passingAPIData).then((value) {
      orderProductItems.value = value;
      isLoading.value = false;
    });
  }
}