import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/login_controller.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/ui/auth_screen/information_screen.dart';
import 'package:customer/ui/dashboard_screen.dart';
import 'package:customer/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/Preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
             /*backgroundColor: themeChange.getThem()
                 ? AppColors.background
                 : AppColors.darkBackground,*/
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    top: -122,
                    child: Image.asset(
                      "assets/images/login_car_background.png",
                    ),
                ),
                Positioned(
                    top: 95,
                    left: 30,
                    // bottom: 45,
                    child: Image.asset(
                      "assets/images/car_login.png",
                      width: 100,
                      height: 100,
                    ),
                ),
                Positioned(
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: width,
                      height: height - 208,
                      decoration: BoxDecoration(
                          color: themeChange.getThem()
                              ? AppColors.darkBackground
                              : AppColors.background,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Login".tr,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: themeChange.getThem()
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 25),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                    "Welcome Back! We are happy to have \nyou back"
                                        .tr,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        color: themeChange.getThem()
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                  validator: (value) =>
                                      value != null && value.isNotEmpty
                                          ? null
                                          : 'Required',
                                  keyboardType: TextInputType.phone,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller:
                                      controller.phoneNumberController.value,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                      color: themeChange.getThem()
                                          ? Colors.white
                                          : Colors.black),
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
                                        closeIcon: Icon(Icons.close, color: themeChange.getThem()
                                            ? Colors.white
                                            : Colors.black),
                                        onChanged: (value) {
                                          controller.countryCode.value =
                                              value.dialCode.toString();
                                        },
                                        dialogBackgroundColor:
                                            themeChange.getThem()
                                                ? AppColors.darkBackground
                                                : AppColors.background,
                                        initialSelection:
                                            controller.countryCode.value,
                                        comparator: (a, b) => b.name!
                                            .compareTo(a.name.toString()),
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
                                          prefixIconColor: themeChange.getThem()
                                              ? Colors.white
                                              : Colors.black,
                                          disabledBorder: UnderlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20),
                                                ),
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
                                            borderRadius: const BorderRadius.all(
                                                    Radius.circular(20),
                                                ),
                                            borderSide: BorderSide(
                                                color: themeChange.getThem()
                                                    ? AppColors
                                                        .darkTextFieldBorder
                                                    : AppColors.textFieldBorder,
                                                width: 1,
                                            ),
                                          ),
                                        ),
                                        flagDecoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2),
                                          ),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                        ),
                                        borderSide: BorderSide(
                                            color: themeChange.getThem()
                                                ? AppColors.darkTextFieldBorder
                                                : AppColors.textFieldBorder,
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: themeChange.getThem()
                                                ? AppColors.darkTextFieldBorder
                                                : AppColors.textFieldBorder,
                                            width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                        ),
                                        borderSide: BorderSide(
                                            color: themeChange.getThem()
                                                ? AppColors.darkTextFieldBorder
                                                : AppColors.textFieldBorder,
                                            width: 1),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: themeChange.getThem()
                                                ? AppColors.darkTextFieldBorder
                                                : AppColors.textFieldBorder,
                                            width: 1),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: themeChange.getThem()
                                                ? AppColors.darkTextFieldBorder
                                                : AppColors.textFieldBorder,
                                            width: 1),
                                      ),
                                      hintText: "Phone number".tr),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ButtonThem.buildButton(
                                context,
                                title: "Next".tr,
                                onPress: () {
                                  controller.sendCode();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 40),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Divider(
                                      height: 1,  color: themeChange.getThem()
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        "OR".tr,
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: themeChange.getThem()
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Expanded(
                                        child: Divider(
                                      height: 1,  color: themeChange.getThem()
                                            ? Colors.white
                                            : Colors.black,
                                    )),
                                  ],
                                ),
                              ),
                              ButtonThem.buildBorderButton(
                                context,
                                title: "Login with google".tr,
                                iconVisibility: true,
                                iconAssetImage: 'assets/icons/ic_google.png',
                                onPress: () async {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  await controller
                                      .signInWithGoogle()
                                      .then((value) {
                                    ShowToastDialog.closeLoader();
                                    if (value != null) {
                                      if (value.additionalUserInfo!.isNewUser) {
                                        print("----->new user");
                                        UserModel userModel = UserModel();
                                        userModel.id = value.user!.uid;
                                        userModel.email = value.user!.email;
                                        userModel.fullName =
                                            value.user!.displayName;
                                        userModel.profilePic =
                                            value.user!.photoURL;
                                        userModel.loginType =
                                            Constant.googleLoginType;

                                        ShowToastDialog.closeLoader();
                                        Get.to(const InformationScreen(),
                                            arguments: {
                                              "userModel": userModel,
                                            });
                                      } else {
                                        print("----->old user");
                                        FireStoreUtils.userExitOrNot(
                                                value.user!.uid)
                                            .then((userExit) async {
                                          ShowToastDialog.closeLoader();
                                          if (userExit == true) {
                                            UserModel? userModel =
                                                await FireStoreUtils
                                                    .getUserProfile(
                                                        value.user!.uid);
                                            if (userModel != null) {
                                              if (userModel.isActive == true) {
                                                Get.offAll(
                                                    const DashBoardScreen());
                                              } else {
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                ShowToastDialog.showToast(
                                                    "This user is disable please contact administrator"
                                                        .tr);
                                              }
                                            }
                                          } else {
                                            UserModel userModel = UserModel();
                                            userModel.id = value.user!.uid;
                                            userModel.email = value.user!.email;
                                            userModel.fullName =
                                                value.user!.displayName;
                                            userModel.profilePic =
                                                value.user!.photoURL;
                                            userModel.loginType =
                                                Constant.googleLoginType;

                                            Get.to(const InformationScreen(),
                                                arguments: {
                                                  "userModel": userModel,
                                                });
                                          }
                                        });
                                      }
                                    }
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Visibility(
                                  visible: Platform.isIOS,
                                  child: ButtonThem.buildBorderButton(
                                    context,
                                    title: "Login with apple".tr,
                                    iconVisibility: true,
                                    iconAssetImage: themeChange.getThem()
                                        ? 'assets/icons/ic_apple.png'
                                        : "assets/icons/ic_apple_bright.png",
                                    onPress: () async {
                                      ShowToastDialog.showLoader(
                                          "Please wait".tr);
                                      await controller
                                          .signInWithApple()
                                          .then((value) {
                                        ShowToastDialog.closeLoader();
                                        if (value != null) {
                                          if (value
                                              .additionalUserInfo!.isNewUser) {
                                            log("----->new user");
                                            UserModel userModel = UserModel();
                                            userModel.id = value.user!.uid;
                                            //userModel.email = value.user!.email;
                                            userModel.email = (Preferences.getString(Preferences.signInWithAppleEmail).toString().isNotEmpty) ? Preferences.getString(Preferences.signInWithAppleEmail).toString() : 'unknown@apple.com';
                                            userModel.profilePic =
                                                value.user!.photoURL;
                                            /// Add new line because full name show null
                                            //userModel.fullName = (value.user!.displayName != null) ? value.user!.displayName : '';
                                            userModel.fullName = (Preferences.getString(Preferences.signInWithAppleDisplayName).toString().isNotEmpty) ? Preferences.getString(Preferences.signInWithAppleDisplayName).toString() : 'Unknown';
                                            userModel.loginType =
                                                Constant.appleLoginType;

                                            ShowToastDialog.closeLoader();
                                            Get.to(const InformationScreen(),
                                                arguments: {
                                                  "userModel": userModel,
                                                });
                                          } else {
                                            print("----->old user");
                                            FireStoreUtils.userExitOrNot(
                                                    value.user!.uid)
                                                .then((userExit) async {
                                              ShowToastDialog.closeLoader();

                                              if (userExit == true) {
                                                UserModel? userModel =
                                                    await FireStoreUtils
                                                        .getUserProfile(
                                                            value.user!.uid);
                                                if (userModel != null) {
                                                  if (userModel.isActive ==
                                                      true) {
                                                    Get.offAll(
                                                        const DashBoardScreen());
                                                  } else {
                                                    await FirebaseAuth.instance
                                                        .signOut();
                                                    ShowToastDialog.showToast(
                                                        "This user is disable please contact administrator"
                                                            .tr);
                                                  }
                                                }
                                              } else {
                                                UserModel userModel =
                                                    UserModel();
                                                userModel.id = value.user!.uid;
                                                //userModel.email = value.user!.email;
                                                userModel.email = (Preferences.getString(Preferences.signInWithAppleEmail).toString().isNotEmpty) ? Preferences.getString(Preferences.signInWithAppleEmail).toString() : 'unknown@apple.com';
                                                userModel.profilePic =
                                                    value.user!.photoURL;
                                                /// Add new line because full name show null
                                                //userModel.fullName = (value.user!.displayName != null) ? value.user!.displayName : '';
                                                userModel.fullName = (Preferences.getString(Preferences.signInWithAppleDisplayName).toString().isNotEmpty) ? Preferences.getString(Preferences.signInWithAppleDisplayName).toString() : 'Unknown';
                                                userModel.loginType =
                                                    Constant.appleLoginType;

                                                Get.to(
                                                    const InformationScreen(),
                                                    arguments: {
                                                      "userModel": userModel,
                                                    });
                                              }
                                            });
                                          }
                                        }
                                      });
                                    },
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              color: themeChange.getThem()
                  ? AppColors.darkBackground
                  : AppColors.background,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      // text: 'By tapping "Next" you agree to '.tr,
                      style: GoogleFonts.poppins(),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const TermsAndConditionScreen(
                                  type: "terms",
                                ));
                              },
                            text: 'Terms & Conditions'.tr,
                            style: GoogleFonts.poppins(
                                color: themeChange.getThem()
                                    ? Colors.white
                                    : Colors.black,
                                 fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                            text: ' and ',
                            style: GoogleFonts.poppins(
                              color: themeChange.getThem()
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const TermsAndConditionScreen(
                                  type: "privacy",
                                ));
                              },
                            text: 'Privacy Policy'.tr,
                            style: GoogleFonts.poppins(
                                color: themeChange.getThem()
                                    ? Colors.white
                                    : Colors.black, fontWeight: FontWeight.w500)),
                        // can add more TextSpans here...
                      ],
                    ),
                  ),
              ),
            ),
          );
        });
  }

  Widget oldLoginBody(
      context, LoginController controller, DarkThemeProvider themeChange) {
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
                  child: Text("Login".tr,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                      "Welcome Back! We are happy to have \n you back".tr,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    validator: (value) =>
                        value != null && value.isNotEmpty ? null : 'Required',
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    controller: controller.phoneNumberController.value,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        color: themeChange.getThem()
                            ? Colors.white
                            : Colors.black),
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
                  height: 30,
                ),
                ButtonThem.buildButton(
                  context,
                  title: "Next".tr,
                  onPress: () {
                    controller.sendCode();
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: Row(
                    children: [
                      const Expanded(
                          child: Divider(
                        height: 1,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "OR".tr,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Expanded(
                          child: Divider(
                        height: 1,
                      )),
                    ],
                  ),
                ),
                ButtonThem.buildBorderButton(
                  context,
                  title: "Login with google".tr,
                  iconVisibility: true,
                  iconAssetImage: 'assets/icons/ic_google.png',
                  onPress: () async {
                    ShowToastDialog.showLoader("Please wait".tr);
                    await controller.signInWithGoogle().then((value) {
                      ShowToastDialog.closeLoader();
                      if (value != null) {
                        if (value.additionalUserInfo!.isNewUser) {
                          print("----->new user");
                          UserModel userModel = UserModel();
                          userModel.id = value.user!.uid;
                          userModel.email = value.user!.email;
                          userModel.fullName = value.user!.displayName;
                          userModel.profilePic = value.user!.photoURL;
                          userModel.loginType = Constant.googleLoginType;

                          ShowToastDialog.closeLoader();
                          Get.to(const InformationScreen(), arguments: {
                            "userModel": userModel,
                          });
                        } else {
                          print("----->old user");
                          FireStoreUtils.userExitOrNot(value.user!.uid)
                              .then((userExit) async {
                            ShowToastDialog.closeLoader();
                            if (userExit == true) {
                              UserModel? userModel =
                                  await FireStoreUtils.getUserProfile(
                                      value.user!.uid);
                              if (userModel != null) {
                                if (userModel.isActive == true) {
                                  Get.offAll(const DashBoardScreen());
                                } else {
                                  await FirebaseAuth.instance.signOut();
                                  ShowToastDialog.showToast(
                                      "This user is disable please contact administrator"
                                          .tr);
                                }
                              }
                            } else {
                              UserModel userModel = UserModel();
                              userModel.id = value.user!.uid;
                              userModel.email = value.user!.email;
                              userModel.fullName = value.user!.displayName;
                              userModel.profilePic = value.user!.photoURL;
                              userModel.loginType = Constant.googleLoginType;

                              Get.to(const InformationScreen(), arguments: {
                                "userModel": userModel,
                              });
                            }
                          });
                        }
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                    visible: Platform.isIOS,
                    child: ButtonThem.buildBorderButton(
                      context,
                      title: "Login with apple".tr,
                      iconVisibility: true,
                      iconAssetImage: 'assets/icons/ic_apple.png',
                      onPress: () async {
                        ShowToastDialog.showLoader("Please wait".tr);
                        await controller.signInWithApple().then((value) {
                          ShowToastDialog.closeLoader();
                          if (value != null) {
                            if (value.additionalUserInfo!.isNewUser) {
                              log("----->new user");
                              UserModel userModel = UserModel();
                              userModel.id = value.user!.uid;
                              userModel.email = value.user!.email;
                              userModel.profilePic = value.user!.photoURL;
                              userModel.loginType = Constant.appleLoginType;

                              ShowToastDialog.closeLoader();
                              Get.to(const InformationScreen(), arguments: {
                                "userModel": userModel,
                              });
                            } else {
                              print("----->old user");
                              FireStoreUtils.userExitOrNot(value.user!.uid)
                                  .then((userExit) async {
                                ShowToastDialog.closeLoader();

                                if (userExit == true) {
                                  UserModel? userModel =
                                      await FireStoreUtils.getUserProfile(
                                          value.user!.uid);
                                  if (userModel != null) {
                                    if (userModel.isActive == true) {
                                      Get.offAll(const DashBoardScreen());
                                    } else {
                                      await FirebaseAuth.instance.signOut();
                                      ShowToastDialog.showToast(
                                          "This user is disable please contact administrator"
                                              .tr);
                                    }
                                  }
                                } else {
                                  UserModel userModel = UserModel();
                                  userModel.id = value.user!.uid;
                                  userModel.email = value.user!.email;
                                  userModel.profilePic = value.user!.photoURL;
                                  userModel.loginType =
                                      Constant.googleLoginType;

                                  Get.to(const InformationScreen(), arguments: {
                                    "userModel": userModel,
                                  });
                                }
                              });
                            }
                          }
                        });
                      },
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
