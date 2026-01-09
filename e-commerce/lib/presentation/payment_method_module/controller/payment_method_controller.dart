import 'package:get/get.dart';

import '../../../core/app_api_handler.dart';

class PaymentMethodController extends GetxController{

  RxBool isLoading = true.obs;
  List listPaymentData = [];
  RxString selPayGateway = ''.obs;
  RxString selPayGatewayTitle = ''.obs;

  getPayListData() async {
    await ApiHandlerService().getPaymentList().then((paymentListData) {
      listPaymentData = paymentListData;
      isLoading.value = false;
    });
  }

}