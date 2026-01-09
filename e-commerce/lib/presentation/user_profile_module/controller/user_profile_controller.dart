import 'package:get/get.dart';
import '../../../core/app_auth.dart';

class UserProfileController extends GetxController{

  RxBool loading = true.obs;
  List<dynamic> webPages = [];
  RxMap onePage = {}.obs;

  @override
  void onInit() {
    getWebPage();
    super.onInit();
  }

  getWebPage() async {
    Future<List<dynamic>> getPages = UserAuthService().getWebPages();

    getPages.then((value) {
      if (value.isNotEmpty) {
        webPages = value;
        for (var i = 0; i < webPages.length; i++) {
          onePage.addAll({webPages[i]['title']['rendered']: webPages[i]});
        }
        loading.value = false;
      } else {
        loading.value = false;
      }
    });
  }
}