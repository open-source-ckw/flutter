import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stacks/consts.dart';
import 'package:stacks/controller/home_controller.dart';

class ProfileController extends HomeController {
  HomeController controller = Get.put(HomeController())!;
  final box = GetStorage();
  List socialAccounts = [
    'images/svg/gmail.svg',
    'images/svg/facebook.svg',
    'images/svg/twitter.svg',
    'images/svg/linkedin.svg',
    'images/svg/instagramm.svg',
    'images/svg/skype.svg',
    'images/svg/discord.svg',
    'images/svg/pinterest.svg',
    'images/svg/youtube.svg'
  ];

  RxString _name = "Anonymous".obs;
  RxString _email = "".obs;
  RxString _photoURL = "".obs;

  get name => _name.value;

  get email => _email.value;

  get photoURL => _photoURL.value;

  @override
  void onInit() {
    _name.value = read(NAME) == false ? "NA" : read(NAME);
    _email.value = read(EMAIL) == false ? "NA" : read(EMAIL);
    _photoURL.value = read(PHOTO) == false ? "NA" : read(PHOTO);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  write(key, value) {
    box.write(key, value);
    update();
  }

  remove(key) {
    box.remove(key);
    update();
  }

  read(key) {
    print('box');
    print(box);
    var va = box.read(key);
    if (va == null) {
      return false;
    }

    if (va == 'false') {
      return false;
    }

    if (va == 'true') {
      return true;
    }
    return va;
  }
}
