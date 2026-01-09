import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/controller/home_controller.dart';
import 'package:stacks/routes/app_pages.dart';
import 'package:stacks/theme/app_colors.dart';

class MenuActivity extends StatelessWidget {
  HomeController controller = Get.put(HomeController())!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.changePage(2);
      },
      child: Container(
        width: 45,
        height: 52,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 30, color: ModalRoute.of(context)!.settings.name == Routes.ACTIVITY ? Color(0xff5ed6d5) : greyColor),
            SizedBox(height: 6),
            Text(
              "Activity",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ModalRoute.of(context)!.settings.name == Routes.ACTIVITY ? Color(0xff5ed6d5) : Color(0xff002347),
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
