import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/profile_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/themes/text_field_them.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: themeChange.getThem()
                  ? AppColors.darkBackground
                  : AppColors.background,
              body: Column(
                children: [
                  SizedBox(
                    height: Responsive.width(45, context),
                    width: Responsive.width(100, context),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: 50,
                          child: Center(
                            child: controller.profileImage.isEmpty
                                ? /*ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: CachedNetworkImage(
                                      imageUrl: Constant.userPlaceHolder,
                                      fit: BoxFit.cover,
                                      height: Responsive.width(30, context),
                                      width: Responsive.width(30, context),
                                      placeholder: (context, url) =>
                                          Constant.loader(),
                                      errorWidget: (context, url, error) =>
                                          Image.network(
                                              Constant.userPlaceHolder),
                                    ),
                                  )*/
                                CircleAvatar(
                                    maxRadius: 60,
                                    minRadius: 60,
                                    backgroundColor: AppColors.darkModePrimary,
                                    child: Text(
                                        controller.driverModel.value.fullName
                                            .toString()
                                            .characters
                                            .first,
                                        style: GoogleFonts.poppins(
                                            fontSize: 45.0,
                                            fontWeight: FontWeight.w500,
                                            color: themeChange.getThem()
                                                ? Colors.black
                                                : Colors.white)),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Constant().hasValidUrl(controller
                                                .profileImage.value) ==
                                            false
                                        ? Image.file(
                                            File(controller.profileImage.value),
                                            height:
                                                Responsive.width(30, context),
                                            width:
                                                Responsive.width(30, context),
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: controller
                                                .profileImage.value
                                                .toString(),
                                            fit: BoxFit.cover,
                                            height:
                                                Responsive.width(30, context),
                                            width:
                                                Responsive.width(30, context),
                                            placeholder: (context, url) =>
                                                Constant.loader(context),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.network(
                                                    Constant.userPlaceHolder),
                                          ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          right: Responsive.width(36, context),
                          child: InkWell(
                            onTap: () {
                              buildBottomSheet(
                                  context, controller, themeChange);
                            },
                            child: ClipOval(
                              child: Container(
                                color: themeChange.getThem()
                                    ? AppColors.darkGray
                                    : AppColors.gray,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/ic_edit_profile.png',
                                    width: 22,
                                    height: 22,
                                  ),
                                  /*SvgPicture.asset(
                                    'assets/icons/ic_edit_profile.svg',
                                    width: 22,
                                    height: 22,
                                  ),*/
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: controller.isLoading.value
                        ? Constant.loader(context)
                        : Container(
                            decoration: BoxDecoration(
                                /* color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))*/
                                ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextFieldThem.buildTextFiled(context,
                                            hintText: 'Full name'.tr,
                                            controller: controller
                                                .fullNameController.value),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                            validator: (value) =>
                                                value != null &&
                                                        value.isNotEmpty
                                                    ? null
                                                    : 'Required',
                                            keyboardType: TextInputType.number,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            controller: controller
                                                .phoneNumberController.value,
                                            textAlign: TextAlign.start,
                                            enabled: false,
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
                                                  onChanged: (value) {
                                                    controller
                                                            .countryCode.value =
                                                        value.dialCode
                                                            .toString();
                                                  },
                                                  textStyle:
                                                      GoogleFonts.poppins(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? Colors.white
                                                              : Colors.black),
                                                  dialogTextStyle:
                                                      GoogleFonts.poppins(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? Colors.white
                                                              : Colors.black),
                                                  searchStyle:
                                                      GoogleFonts.poppins(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? Colors.white
                                                              : Colors.black),
                                                  searchDecoration:
                                                      InputDecoration(
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                      borderSide: BorderSide(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppColors
                                                                  .darkTextFieldBorder
                                                              : AppColors
                                                                  .textFieldBorder,
                                                          width: 1),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                      borderSide: BorderSide(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppColors
                                                                  .darkTextFieldBorder
                                                              : AppColors
                                                                  .textFieldBorder,
                                                          width: 1),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                      borderSide: BorderSide(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppColors
                                                                  .darkTextFieldBorder
                                                              : AppColors
                                                                  .textFieldBorder,
                                                          width: 1),
                                                    ),
                                                    errorBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                      borderSide: BorderSide(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppColors
                                                                  .darkTextFieldBorder
                                                              : AppColors
                                                                  .textFieldBorder,
                                                          width: 1),
                                                    ),
                                                    hintText: "Country code",
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                      borderSide: BorderSide(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppColors
                                                                  .darkTextFieldBorder
                                                              : AppColors
                                                                  .textFieldBorder,
                                                          width: 1),
                                                    ),
                                                  ),
                                                  dialogBackgroundColor:
                                                      themeChange.getThem()
                                                          ? AppColors
                                                              .darkBackground
                                                          : AppColors
                                                              .background,
                                                  initialSelection: controller
                                                      .countryCode.value,
                                                  comparator: (a, b) => b.name!
                                                      .compareTo(
                                                          a.name.toString()),
                                                  flagDecoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(2)),
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppColors
                                                              .darkTextFieldBorder
                                                          : AppColors
                                                              .textFieldBorder,
                                                      width: 1),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppColors
                                                              .darkTextFieldBorder
                                                          : AppColors
                                                              .textFieldBorder,
                                                      width: 1),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: themeChange
                                                              .getThem()
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
                                                      color: themeChange
                                                              .getThem()
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
                                                      color: themeChange
                                                              .getThem()
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
                                            controller: controller
                                                .emailController.value,
                                            enable: false),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ButtonThem.buildButton(
                                          context,
                                          title: "Update Profile".tr,
                                          onPress: () async {
                                            ShowToastDialog.showLoader(
                                                "Please wait".tr);
                                            if (controller.profileImage.value
                                                .isNotEmpty) {
                                              controller.profileImage.value =
                                                  await Constant
                                                      .uploadUserImageToFireStorage(
                                                          File(
                                                              controller
                                                                  .profileImage
                                                                  .value),
                                                          "profileImage/${FireStoreUtils.getCurrentUid()}",
                                                          File(controller
                                                                  .profileImage
                                                                  .value)
                                                              .path
                                                              .split('/')
                                                              .last);
                                            }

                                            DriverUserModel driverUserModel =
                                                controller.driverModel.value;
                                            driverUserModel.fullName =
                                                controller.fullNameController
                                                    .value.text;
                                            driverUserModel.profilePic =
                                                controller.profileImage.value;

                                            FireStoreUtils.updateDriverUser(
                                                    driverUserModel)
                                                .then((value) {
                                              ShowToastDialog.closeLoader();
                                              ShowToastDialog.showToast(
                                                  "Profile update successfully"
                                                      .tr);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ));
        });
  }

  buildBottomSheet(BuildContext context, ProfileController controller,
      DarkThemeProvider themeChange) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select".tr,
                      style: GoogleFonts.poppins(
                        color:
                            themeChange.getThem() ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(
                                    source: ImageSource.camera),
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: themeChange.getThem()
                                      ? Colors.white
                                      : Colors.black,
                                  size: 32,
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Text(
                                "Camera".tr,
                                style: GoogleFonts.poppins(
                                  color: themeChange.getThem()
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(
                                    source: ImageSource.gallery),
                                icon: Icon(
                                  Icons.photo_library_sharp,
                                  color: themeChange.getThem()
                                      ? Colors.white
                                      : Colors.black,
                                  size: 32,
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Text(
                                "Gallery".tr,
                                style: GoogleFonts.poppins(
                                  color: themeChange.getThem()
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }
}
