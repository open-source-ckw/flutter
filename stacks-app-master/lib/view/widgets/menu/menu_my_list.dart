import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/routes/app_pages.dart';
import 'package:stacks/theme/app_colors.dart';

class MenuMyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return GestureDetector(
        onTap: () {
          controller.changePage(0);
        },
        child: Container(
          width: 45,
          height: 52,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.list,
                  size: 30,
                  color: ModalRoute.of(context)!.settings.name == Routes.HOME || ModalRoute.of(context)!.settings.name == '/Home' || ModalRoute.of(context)!.settings.name == null
                      ? Color(0xff5ed6d5)
                      : greyColor),
              SizedBox(height: 6),
              Text(
                "MY LIST",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ModalRoute.of(context)!.settings.name == Routes.HOME || ModalRoute.of(context)!.settings.name == '/Home' || ModalRoute.of(context)!.settings.name == null
                      ? Color(0xff5ed6d5)
                      : Color(0xff002347),
                  fontSize: 10,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ));
  }
}
