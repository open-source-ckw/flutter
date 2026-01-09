import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/controller/auth_controller.dart';
import 'package:stacks/theme/app_colors.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController? controller = Get.put(AuthController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
