import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/information_controller.dart';
import 'package:customer/model/referral_model.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/text_field_them.dart';
import 'package:customer/ui/dashboard_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<InformationController>(
        init: InformationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppColors.background
                : AppColors.darkBackground,
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
                                      child: Text("Sign up".tr,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: themeChange.getThem() ? Colors.white : Colors.black,

                                              fontSize: 25)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                          "Create your account to start using WayFinder"
                                          // "Create your account to start using GoRide"
                                              .tr,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              color: themeChange.getThem() ? Colors.white : Colors.black,

                                              fontSize: 16)),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFieldThem.buildTextFiled(context,
                                        hintText: 'Full name'.tr,
                                        controller: controller
                                            .fullNameController.value),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        validator: (value) =>
                                        value != null && value.isNotEmpty
                                            ? null
                                            : 'Required',
                                        keyboardType: TextInputType.number,
                                        textCapitalization:
                                        TextCapitalization.sentences,
                                        controller: controller
                                            .phoneNumberController.value,
                                        textAlign: TextAlign.start,
                                        enabled: controller.loginType.value ==
                                            Constant.phoneLoginType
                                            ? false
                                            : true,
                                        style: GoogleFonts.poppins(
                                            color: themeChange.getThem() ? Colors.white : Colors.black),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: themeChange.getThem()
                                                ? AppColors.darkTextField
                                                : AppColors.textField,
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12),
                                            prefixIcon: CountryCodePicker(
                                              onChanged: (value) {
                                                controller.countryCode.value =
                                                    value.dialCode.toString();
                                              },
                                              textStyle: GoogleFonts.poppins(
                                                  color: themeChange.getThem()
                                                      ? Colors.white
                                                      : Colors.black),
                                              dialogTextStyle: GoogleFonts.poppins(
                                                  color: themeChange.getThem()
                                                      ? Colors.white
                                                      : Colors.black),
                                              searchStyle: GoogleFonts.poppins(
                                                  color: themeChange.getThem()
                                                      ? Colors.white
                                                      : Colors.black),
                                              searchDecoration: InputDecoration(
                                                disabledBorder: UnderlineInputBorder(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange.getThem()
                                                          ? AppColors
                                                          .darkTextFieldBorder
                                                          : AppColors.textFieldBorder,
                                                      width: 1),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange.getThem()
                                                          ? AppColors
                                                          .darkTextFieldBorder
                                                          : AppColors.textFieldBorder,
                                                      width: 1),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange.getThem()
                                                          ? AppColors
                                                          .darkTextFieldBorder
                                                          : AppColors.textFieldBorder,
                                                      width: 1),
                                                ),
                                                errorBorder: UnderlineInputBorder(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange.getThem()
                                                          ? AppColors
                                                          .darkTextFieldBorder
                                                          : AppColors.textFieldBorder,
                                                      width: 1),
                                                ),
                                                hintText: "Country code",
                                                border: UnderlineInputBorder(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange.getThem()
                                                          ? AppColors
                                                          .darkTextFieldBorder
                                                          : AppColors.textFieldBorder,
                                                      width: 1),
                                                ),
                                              ),
                                              dialogBackgroundColor:
                                              themeChange.getThem()
                                                  ? AppColors.darkBackground
                                                  : AppColors.background,
                                              initialSelection:
                                              controller.countryCode.value,
                                              comparator: (a, b) => b.name!
                                                  .compareTo(a.name.toString()),
                                              flagDecoration:
                                              const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2)),
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: themeChange.getThem()
                                                      ? AppColors
                                                      .darkTextFieldBorder
                                                      : AppColors
                                                      .textFieldBorder,
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: themeChange.getThem()
                                                      ? AppColors
                                                      .darkTextFieldBorder
                                                      : AppColors
                                                      .textFieldBorder,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: themeChange.getThem()
                                                      ? AppColors
                                                      .darkTextFieldBorder
                                                      : AppColors
                                                      .textFieldBorder,
                                                  width: 1),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: themeChange.getThem()
                                                      ? AppColors
                                                      .darkTextFieldBorder
                                                      : AppColors
                                                      .textFieldBorder,
                                                  width: 1),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: themeChange.getThem()
                                                      ? AppColors
                                                      .darkTextFieldBorder
                                                      : AppColors
                                                      .textFieldBorder,
                                                  width: 1),
                                            ),
                                            hintText: "Phone number".tr)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFieldThem.buildTextFiled(context,
                                        hintText: 'Email'.tr,
                                        controller:
                                        controller.emailController.value,
                                        enable: controller.loginType.value ==
                                            Constant.googleLoginType
                                            ? false
                                            : true),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFieldThem.buildTextFiled(context,
                                        hintText: 'Coupon Code (Optional)'.tr,
                                        controller: controller
                                            .referralCodeController.value,
                                        enable: controller.loginType.value ==
                                            Constant.googleLoginType
                                            ? false
                                            : true),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    ButtonThem.buildButton(
                                      context,
                                      title: "Create account".tr,
                                      onPress: () async {
                                        if (controller.fullNameController.value
                                            .text.isEmpty) {
                                          ShowToastDialog.showToast(
                                              "Please enter full name".tr);
                                        } else if (controller.emailController
                                            .value.text.isEmpty) {
                                          ShowToastDialog.showToast(
                                              "Please enter email".tr);
                                        } else if (controller
                                            .phoneNumberController
                                            .value
                                            .text
                                            .isEmpty) {
                                          ShowToastDialog.showToast(
                                              "Please enter phone".tr);
                                        } else if (Constant.validateEmail(
                                            controller.emailController.value
                                                .text) ==
                                            false) {
                                          ShowToastDialog.showToast(
                                              "Please enter valid email".tr);
                                        } else {
                                          if (controller.referralCodeController
                                              .value.text.isNotEmpty) {
                                            FireStoreUtils
                                                .checkReferralCodeValidOrNot(
                                                controller
                                                    .referralCodeController
                                                    .value
                                                    .text)
                                                .then((value) async {
                                              if (value == true) {
                                                ShowToastDialog.showLoader(
                                                    "Please wait".tr);
                                                UserModel userModel =
                                                    controller.userModel.value;
                                                userModel.fullName = controller
                                                    .fullNameController
                                                    .value
                                                    .text;
                                                userModel.email = controller
                                                    .emailController.value.text;
                                                userModel.countryCode =
                                                    controller
                                                        .countryCode.value;
                                                userModel.phoneNumber =
                                                    controller
                                                        .phoneNumberController
                                                        .value
                                                        .text;
                                                userModel.isActive = true;
                                                userModel.createdAt =
                                                    Timestamp.now();

                                                await FireStoreUtils
                                                    .getReferralUserByCode(
                                                    controller
                                                        .referralCodeController
                                                        .value
                                                        .text)
                                                    .then((value) async {
                                                  if (value != null) {
                                                    ReferralModel
                                                    ownReferralModel =
                                                    ReferralModel(
                                                        id: FireStoreUtils
                                                            .getCurrentUid(),
                                                        referralBy:
                                                        value.id,
                                                        referralCode: Constant
                                                            .getReferralCode());
                                                    await FireStoreUtils
                                                        .referralAdd(
                                                        ownReferralModel);
                                                  } else {
                                                    ReferralModel
                                                    referralModel =
                                                    ReferralModel(
                                                        id: FireStoreUtils
                                                            .getCurrentUid(),
                                                        referralBy: "",
                                                        referralCode: Constant
                                                            .getReferralCode());
                                                    await FireStoreUtils
                                                        .referralAdd(
                                                        referralModel);
                                                  }
                                                });

                                                await FireStoreUtils.updateUser(
                                                    userModel)
                                                    .then((value) {
                                                  ShowToastDialog.closeLoader();
                                                  print("------>$value");
                                                  if (value == true) {
                                                    Get.offAll(
                                                        const DashBoardScreen());
                                                  }
                                                });
                                              } else {
                                                ShowToastDialog.showToast(
                                                    "Referral code Invalid".tr);
                                              }
                                            });
                                          } else {
                                            ShowToastDialog.showLoader(
                                                "Please wait".tr);
                                            UserModel userModel =
                                                controller.userModel.value;
                                            userModel.fullName = controller
                                                .fullNameController.value.text;
                                            userModel.email = controller
                                                .emailController.value.text;
                                            userModel.countryCode =
                                                controller.countryCode.value;
                                            userModel.phoneNumber = controller
                                                .phoneNumberController
                                                .value
                                                .text;
                                            userModel.isActive = true;
                                            userModel.createdAt =
                                                Timestamp.now();

                                            ReferralModel referralModel =
                                            ReferralModel(
                                                id: FireStoreUtils
                                                    .getCurrentUid(),
                                                referralBy: "",
                                                referralCode: Constant
                                                    .getReferralCode());
                                            await FireStoreUtils.referralAdd(
                                                referralModel);


                                            await FireStoreUtils.updateUser(
                                                userModel)
                                                .then((value) {
                                              ShowToastDialog.closeLoader();
                                              print("------>$value");
                                              if (value == true) {
                                                Get.offAll(
                                                    const DashBoardScreen(),
                                                );
                                              }
                                            });
                                          }
                                        }
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

  Widget oldBody(context, InformationController controller,
      DarkThemeProvider themeChange) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/login_image.png",
              width: Responsive.width(100, context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Sign up".tr,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text("Create your account to start using WayFinder".tr,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400)),
                ),/* Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text("Create your account to start using GoRide".tr,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400)),
                ),*/
                const SizedBox(
                  height: 20,
                ),
                TextFieldThem.buildTextFiled(context,
                    hintText: 'Full name'.tr,
                    controller: controller.fullNameController.value),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Required',
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    controller: controller.phoneNumberController.value,
                    textAlign: TextAlign.start,
                    enabled:
                    controller.loginType.value == Constant.phoneLoginType
                        ? false
                        : true,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: themeChange.getThem()
                            ? AppColors.darkTextField
                            : AppColors.textField,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                        prefixIcon: CountryCodePicker(
                          onChanged: (value) {
                            controller.countryCode.value =
                                value.dialCode.toString();
                          },
                          dialogBackgroundColor: themeChange.getThem()
                              ? AppColors.darkBackground
                              : AppColors.background,
                          initialSelection: controller.countryCode.value,
                          comparator: (a, b) =>
                              b.name!.compareTo(a.name.toString()),
                          flagDecoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              width: 1),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              width: 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              width: 1),
                        ),
                        hintText: "Phone number".tr)),
                const SizedBox(
                  height: 10,
                ),
                TextFieldThem.buildTextFiled(context,
                    hintText: 'Email'.tr,
                    controller: controller.emailController.value,
                    enable:
                    controller.loginType.value == Constant.googleLoginType
                        ? false
                        : true),
                const SizedBox(
                  height: 10,
                ),
                TextFieldThem.buildTextFiled(context,
                    hintText: 'Coupon Code (Optional)'.tr,
                    controller: controller.referralCodeController.value,
                    enable:
                    controller.loginType.value == Constant.googleLoginType
                        ? false
                        : true),
                const SizedBox(
                  height: 60,
                ),
                ButtonThem.buildButton(
                  context,
                  title: "Create account".tr,
                  onPress: () async {
                    if (controller.fullNameController.value.text.isEmpty) {
                      ShowToastDialog.showToast("Please enter full name".tr);
                    } else if (controller.emailController.value.text.isEmpty) {
                      ShowToastDialog.showToast("Please enter email".tr);
                    } else if (controller
                        .phoneNumberController.value.text.isEmpty) {
                      ShowToastDialog.showToast("Please enter phone".tr);
                    } else if (Constant.validateEmail(
                        controller.emailController.value.text) ==
                        false) {
                      ShowToastDialog.showToast("Please enter valid email".tr);
                    } else {
                      if (controller
                          .referralCodeController.value.text.isNotEmpty) {
                        FireStoreUtils.checkReferralCodeValidOrNot(
                            controller.referralCodeController.value.text)
                            .then((value) async {
                          if (value == true) {
                            ShowToastDialog.showLoader("Please wait".tr);
                            UserModel userModel = controller.userModel.value;
                            userModel.fullName =
                                controller.fullNameController.value.text;
                            userModel.email =
                                controller.emailController.value.text;
                            userModel.countryCode =
                                controller.countryCode.value;
                            userModel.phoneNumber =
                                controller.phoneNumberController.value.text;
                            userModel.isActive = true;
                            userModel.createdAt = Timestamp.now();

                            await FireStoreUtils.getReferralUserByCode(
                                controller
                                    .referralCodeController.value.text)
                                .then((value) async {
                              if (value != null) {
                                ReferralModel ownReferralModel = ReferralModel(
                                    id: FireStoreUtils.getCurrentUid(),
                                    referralBy: value.id,
                                    referralCode: Constant.getReferralCode());
                                await FireStoreUtils.referralAdd(
                                    ownReferralModel);
                              } else {
                                ReferralModel referralModel = ReferralModel(
                                    id: FireStoreUtils.getCurrentUid(),
                                    referralBy: "",
                                    referralCode: Constant.getReferralCode());
                                await FireStoreUtils.referralAdd(referralModel);
                              }
                            });

                            await FireStoreUtils.updateUser(userModel)
                                .then((value) {
                              ShowToastDialog.closeLoader();
                              print("------>$value");
                              if (value == true) {
                                Get.offAll(const DashBoardScreen());
                              }
                            });
                          } else {
                            ShowToastDialog.showToast(
                                "Referral code Invalid".tr);
                          }
                        });
                      } else {
                        ShowToastDialog.showLoader("Please wait".tr);
                        UserModel userModel = controller.userModel.value;
                        userModel.fullName =
                            controller.fullNameController.value.text;
                        userModel.email = controller.emailController.value.text;
                        userModel.countryCode = controller.countryCode.value;
                        userModel.phoneNumber =
                            controller.phoneNumberController.value.text;
                        userModel.isActive = true;
                        userModel.createdAt = Timestamp.now();

                        ReferralModel referralModel = ReferralModel(
                            id: FireStoreUtils.getCurrentUid(),
                            referralBy: "",
                            referralCode: Constant.getReferralCode());
                        await FireStoreUtils.referralAdd(referralModel);

                        await FireStoreUtils.updateUser(userModel)
                            .then((value) {
                          ShowToastDialog.closeLoader();
                          print("------>$value");
                          if (value == true) {
                            Get.offAll(const DashBoardScreen());
                          }
                        });
                      }
                    }
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
