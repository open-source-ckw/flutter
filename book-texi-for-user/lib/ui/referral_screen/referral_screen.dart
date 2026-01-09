import 'package:clipboard/clipboard.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/referral_controller.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ReferralController>(
        init: ReferralController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppColors.darkBackground
                : AppColors.background,
            body: controller.isLoading.value
                ? Constant.loader()
                : Column(
              children: [
                Expanded(
                  child: Container(
                    width: Responsive.width(100, context),
                    decoration: BoxDecoration(
                        color: themeChange.getThem()
                            ? AppColors.darkGray
                            : AppColors.gray,
                        image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/ic_referral_bg.png'),
                            fit: BoxFit.fill)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/referral_image.png',
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeChange.getThem()
                          ? AppColors.darkGray
                          : AppColors.gray,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                          color: themeChange.getThem()
                              ? AppColors.darkContainerBorder
                              : AppColors.containerBorder,
                          width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "Invite Friend & Businesses".tr,
                            style: GoogleFonts.poppins(
                                color: themeChange.getThem()
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          Text(
                            "Earn ${Constant.amountShow(amount: Constant.referralAmount.toString())} each"
                                .tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: themeChange.getThem()
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Invite Friend & Businesses".tr,
                                  style: GoogleFonts.poppins(
                                      color: themeChange.getThem()
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Invite WayFinder to sign up using your link and you’ll get ${Constant.amountShow(amount: Constant.referralAmount.toString())}  "
                                      .tr,
                                  style: GoogleFonts.poppins(
                                      color: themeChange.getThem()
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w200),
                                ),
                                /* Text(
                                        "Invite GoRide to sign up using your link and you’ll get ${Constant.amountShow(amount: Constant.referralAmount.toString())}  "
                                            .tr,
                                        style: GoogleFonts.poppins(
                                            color: themeChange.getThem() ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.w200),
                                      ),*/
                                const SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    FlutterClipboard.copy(controller
                                        .referralModel
                                        .value
                                        .referralCode
                                        .toString())
                                        .then((value) {
                                      ShowToastDialog.showToast(
                                          "Coupon code copied".tr);
                                    });
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(12),
                                    dashPattern: const [5, 5, 5, 5],
                                    color: AppColors.textFieldBorder,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                controller.referralModel.value
                                                    .referralCode
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    color:
                                                    themeChange.getThem()
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              )),
                                          Text("Tap to Copy".tr,
                                              style: GoogleFonts.poppins(
                                                  color: themeChange
                                                      .getThem()
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight:
                                                  FontWeight.w200))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppColors.darkInvite
                                            : AppColors.background,
                                        borderRadius:
                                        BorderRadius.circular(40),
                                        boxShadow: themeChange.getThem()
                                            ? null
                                            : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.10),
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(10.0),
                                        child: /*SvgPicture.asset(
                                                  'assets/icons/ic_invite.svg',
                                                  width: 22,
                                                  color: themeChange.getThem()
                                                      ? Colors.white
                                                      : Colors.black),*/
                                        Image.asset(
                                          'assets/icons/ic_invite.png',
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Invite a Friend".tr,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          color: themeChange.getThem()
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppColors.darkInvite
                                            : AppColors.background,
                                        borderRadius:
                                        BorderRadius.circular(40),
                                        boxShadow: themeChange.getThem()
                                            ? null
                                            : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.10),
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(10.0),
                                        child: /*SvgPicture.asset(
                                                  'assets/icons/ic_register.svg',
                                                  width: 22,
                                                  color: themeChange.getThem()
                                                      ? Colors.white
                                                      : Colors.black),*/
                                        Image.asset(
                                          'assets/icons/ic_register.png',
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "They register".tr,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          color: themeChange.getThem()
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppColors.darkInvite
                                            : AppColors.background,
                                        borderRadius:
                                        BorderRadius.circular(40),
                                        boxShadow: themeChange.getThem()
                                            ? null
                                            : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.10),
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/icons/ic_invite.png',
                                          width: 22,
                                        ),
                                        /*SvgPicture.asset(
                                                  'assets/icons/ic_invite.svg',
                                                  width: 22,
                                                  color: themeChange.getThem()
                                                      ? Colors.white
                                                      : Colors.black),*/
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Get Reward to complete first order"
                                            .tr,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          color: themeChange.getThem()
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "REFER FRIEND".tr,
                          btnWidthRatio: Responsive.width(100, context),
                          onPress: () async {
                            ShowToastDialog.showLoader("Please wait".tr);
                            share(controller);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> share(ReferralController controller) async {
    ShowToastDialog.closeLoader();
    await FlutterShare.share(
      title: 'WayFinder'.tr,
      text:
      'Hey there, thanks for choosing WayFinder. Hope you love our product. If you do, share it with your friends using code ${controller.referralModel.value.referralCode.toString()} and get ${Constant.amountShow(amount: Constant.referralAmount)}.'
          .tr,
      // text: 'Hey there, thanks for choosing GoRide. Hope you love our product. If you do, share it with your friends using code ${controller.referralModel.value.referralCode.toString()} and get ${Constant.amountShow(amount: Constant.referralAmount)}.'.tr,
    );
  }
}
