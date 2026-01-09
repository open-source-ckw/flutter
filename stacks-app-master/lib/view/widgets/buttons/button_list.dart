import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stacks/consts.dart';
import 'package:stacks/controller/home_controller.dart';

class ButtonList extends StatelessWidget {
  final onTap;

  const ButtonList({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController())!;
    return Obx(() {
      var isList = controller.isList;
      isList = GetStorage().read(VIEW) != null ? GetStorage().read(VIEW) : false;
      return FloatingActionButton(
        heroTag: "linkList",
        mini: true,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
        onPressed: onTap,
        child: isList ? Image.asset('images/icon_list_selected.png') : Image.asset('images/icon_list.png'),
      );
    });
  }
}
