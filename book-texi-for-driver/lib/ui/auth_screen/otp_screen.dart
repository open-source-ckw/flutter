import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/otp_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/ui/auth_screen/information_screen.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../themes/responsive.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GetX<OtpController>(
        init: OtpController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    top: -122,
                    child: Image.asset(
                      "assets/images/login_car_background.png",
                    )),
                Positioned(
                    top: 95,
                    left: 30,
                    // bottom: 45,
                    child: Image.asset(
                      "assets/images/car_login.png",
                      width: 100,
                      height: 100,
                    )),
                Positioned(
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // padding: const EdgeInsets.all(20),
                      width: width,
                      height: height - 160,
                      decoration: BoxDecoration(
                          color: themeChange.getThem()
                              ? AppColors.darkBackground
                              : AppColors.background,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image.asset("assets/images/login_image.png",
                              //     width: Responsive.width(100, context)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text("Verify Phone Number".tr,
                                          style: GoogleFonts.poppins(
                                              color: themeChange.getThem()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 25)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                          "We just send a verification code to \n${controller.countryCode.value + controller.phoneNumber.value}"
                                              .tr,
                                          style: GoogleFonts.poppins(
                                              color: themeChange.getThem()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: PinCodeTextField(
                                        length: 6,
                                        appContext: context,
                                        keyboardType: TextInputType.phone,
                                        textStyle: GoogleFonts.poppins(
                                            color: themeChange.getThem()
                                                ? Colors.white
                                                : Colors.black),
                                        pinTheme: PinTheme(
                                          fieldHeight: 50,
                                          fieldWidth: 50,
                                          activeColor: themeChange.getThem()
                                              ? AppColors.darkTextFieldBorder
                                              : AppColors.textFieldBorder,
                                          selectedColor: themeChange.getThem()
                                              ? AppColors.darkTextFieldBorder
                                              : AppColors.textFieldBorder,
                                          inactiveColor: themeChange.getThem()
                                              ? AppColors.darkTextFieldBorder
                                              : AppColors.textFieldBorder,
                                          activeFillColor: themeChange.getThem()
                                              ? AppColors.darkTextField
                                              : AppColors.textField,
                                          inactiveFillColor:
                                              themeChange.getThem()
                                                  ? AppColors.darkTextField
                                                  : AppColors.textField,
                                          selectedFillColor:
                                              themeChange.getThem()
                                                  ? AppColors.darkTextField
                                                  : AppColors.textField,
                                          shape: PinCodeFieldShape.box,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enableActiveFill: true,
                                        cursorColor: AppColors.primary,
                                        controller:
                                            controller.otpController.value,
                                        onCompleted: (v) async {},
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ButtonThem.buildButton(
                                      context,
                                      title: "Verify".tr,
                                      onPress: () async {
                                        if (controller.otpController.value.text
                                                .length ==
                                            6) {
                                          ShowToastDialog.showLoader(
                                              "Verify OTP".tr);

                                          PhoneAuthCredential credential =
                                              PhoneAuthProvider.credential(
                                                  verificationId: controller
                                                      .verificationId.value,
                                                  smsCode: controller
                                                      .otpController
                                                      .value
                                                      .text);
                                          await FirebaseAuth.instance
                                              .signInWithCredential(credential)
                                              .then((value) async {
                                            if (value.additionalUserInfo!
                                                .isNewUser) {
                                              log("----->new user");
                                              DriverUserModel userModel =
                                                  DriverUserModel();
                                              userModel.id = value.user!.uid;
                                              userModel.countryCode =
                                                  controller.countryCode.value;
                                              userModel.phoneNumber =
                                                  controller.phoneNumber.value;
                                              userModel.loginType =
                                                  Constant.phoneLoginType;

                                              ShowToastDialog.closeLoader();
                                              Get.to(const InformationScreen(),
                                                  arguments: {
                                                    "userModel": userModel,
                                                  });
                                            } else {
                                              log("----->old user");
                                              FireStoreUtils.userExitOrNot(
                                                      value.user!.uid)
                                                  .then((userExit) {
                                                ShowToastDialog.closeLoader();
                                                if (userExit == true) {
                                                  Get.to(
                                                      const DashBoardScreen());
                                                } else {
                                                  DriverUserModel userModel =
                                                      DriverUserModel();
                                                  userModel.id =
                                                      value.user!.uid;
                                                  userModel.countryCode =
                                                      controller
                                                          .countryCode.value;
                                                  userModel.phoneNumber =
                                                      controller
                                                          .phoneNumber.value;
                                                  userModel.loginType =
                                                      Constant.phoneLoginType;

                                                  Get.to(
                                                      const InformationScreen(),
                                                      arguments: {
                                                        "userModel": userModel,
                                                      });
                                                }
                                              });
                                            }
                                          }).catchError((error) {
                                            ShowToastDialog.closeLoader();
                                            ShowToastDialog.showToast(
                                                "Code is Invalid".tr);
                                          });
                                        } else {
                                          ShowToastDialog.showToast(
                                              "Please Enter Valid OTP".tr);
                                        }

                                        // print(controller.countryCode.value);
                                        // print(controller.phoneNumberController.value.text);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget oldBody(
      context, OtpController controller, DarkThemeProvider themeChange) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/login_image.png",
              width: Responsive.width(100, context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("Verify Phone Number".tr,
                      style: GoogleFonts.poppins(
                          color: themeChange.getThem()
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                      "We just send a verification code to \n${controller.countryCode.value + controller.phoneNumber.value}"
                          .tr,
                      style: GoogleFonts.poppins(
                        color:
                            themeChange.getThem() ? Colors.white : Colors.black,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: PinCodeTextField(
                    length: 6,
                    appContext: context,
                    keyboardType: TextInputType.phone,
                    pinTheme: PinTheme(
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: themeChange.getThem()
                          ? AppColors.darkTextFieldBorder
                          : AppColors.textFieldBorder,
                      selectedColor: themeChange.getThem()
                          ? AppColors.darkTextFieldBorder
                          : AppColors.textFieldBorder,
                      inactiveColor: themeChange.getThem()
                          ? AppColors.darkTextFieldBorder
                          : AppColors.textFieldBorder,
                      activeFillColor: themeChange.getThem()
                          ? AppColors.darkTextField
                          : AppColors.textField,
                      inactiveFillColor: themeChange.getThem()
                          ? AppColors.darkTextField
                          : AppColors.textField,
                      selectedFillColor: themeChange.getThem()
                          ? AppColors.darkTextField
                          : AppColors.textField,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enableActiveFill: true,
                    cursorColor: AppColors.primary,
                    controller: controller.otpController.value,
                    onCompleted: (v) async {},
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonThem.buildButton(
                  context,
                  title: "Verify".tr,
                  onPress: () async {
                    if (controller.otpController.value.text.length == 6) {
                      ShowToastDialog.showLoader("Verify OTP".tr);

                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: controller.verificationId.value,
                              smsCode: controller.otpController.value.text);
                      await FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) async {
                        if (value.additionalUserInfo!.isNewUser) {
                          log("----->new user");
                          DriverUserModel userModel = DriverUserModel();
                          userModel.id = value.user!.uid;
                          userModel.countryCode = controller.countryCode.value;
                          userModel.phoneNumber = controller.phoneNumber.value;
                          userModel.loginType = Constant.phoneLoginType;

                          ShowToastDialog.closeLoader();
                          Get.to(const InformationScreen(), arguments: {
                            "userModel": userModel,
                          });
                        } else {
                          log("----->old user");
                          FireStoreUtils.userExitOrNot(value.user!.uid)
                              .then((userExit) {
                            ShowToastDialog.closeLoader();
                            if (userExit == true) {
                              Get.to(const DashBoardScreen());
                            } else {
                              DriverUserModel userModel = DriverUserModel();
                              userModel.id = value.user!.uid;
                              userModel.countryCode =
                                  controller.countryCode.value;
                              userModel.phoneNumber =
                                  controller.phoneNumber.value;
                              userModel.loginType = Constant.phoneLoginType;

                              Get.to(const InformationScreen(), arguments: {
                                "userModel": userModel,
                              });
                            }
                          });
                        }
                      }).catchError((error) {
                        ShowToastDialog.closeLoader();
                        ShowToastDialog.showToast("Code is Invalid".tr);
                      });
                    } else {
                      ShowToastDialog.showToast("Please Enter Valid OTP".tr);
                    }

                    // print(controller.countryCode.value);
                    // print(controller.phoneNumberController.value.text);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
