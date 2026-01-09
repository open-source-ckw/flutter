import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/theme/app_colors.dart';

import '../../../consts.dart';

class ButtonGrid extends StatelessWidget {
  final onTap;

  const ButtonGrid({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController())!;
    return Obx(() {
      var isList = controller.isList;
      isList = GetStorage().read(VIEW) != null ? GetStorage().read(VIEW) : false;
      return FloatingActionButton(
        heroTag: "linkGrid",
        mini: true,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
        onPressed: onTap,
        child: isList ? Image.asset('images/icon_grid.png') : Image.asset('images/icon_grid_selected.png'),
      );
    });
  }
}
