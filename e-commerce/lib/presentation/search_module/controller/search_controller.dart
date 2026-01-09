import 'package:get/get.dart';
import '../../../core/app_api_handler.dart';

class SearchControllerGetX extends GetxController{

  @override
  void onInit() {
    super.onInit();
  }

  Future<Map<String, dynamic>> gettingResultOfSearch({passingParam}) async {
    Map<String, dynamic> data = {};
    await ApiHandlerService().getCategoriesProduct('?keyword=' + passingParam).then((value) {
      data.addAll({'products': value});
      return value;
    });
    await ApiHandlerService()
        .getCategoriesSearch('/categories?search=' + passingParam)
        .then((value) {
      data.addAll({'category': value});
      return value;
    });
    return data;
  }
}