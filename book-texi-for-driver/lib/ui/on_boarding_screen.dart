import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/controller/on_boarding_controller.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/ui/auth_screen/login_screen.dart';
import 'package:driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/DarkThemeProvider.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: controller.isLoading.value
              ? Constant.loader(context)
              : Stack(
                  children: [
                    // controller.selectedPageIndex.value == 0
                    //     ? Image.asset("assets/images/onboarding_1.png")
                    //     : controller.selectedPageIndex.value == 1
                    //         ? Image.asset("assets/images/onboarding_2.png")
                    //         : Image.asset("assets/images/onboarding_3.png"),

                    // SizedBox(
                    //     width: width,
                    //     height: height,
                    //     child: Image.asset(
                    //       "assets/images/on_boarding_image.png",
                    //       fit: BoxFit.fitWidth,
                    //     )),

                    CustomPaint(
                      painter: BluePainter(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: PageView.builder(
                                controller: controller.pageController,
                                onPageChanged: controller.selectedPageIndex,
                                itemCount: controller.onBoardingList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                              onTap: () {
                                                controller.pageController
                                                    .jumpToPage(2);
                                              },
                                              child: Text(
                                                'Skip'.tr,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    letterSpacing: 1.5,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(60),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                  .onBoardingList[index].image
                                                  .toString(),
                                              fit: BoxFit.cover,
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              controller
                                                  .onBoardingList[index].title
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Text(
                                                controller.onBoardingList[index]
                                                    .description
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                    letterSpacing: 1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DotIndicator(
                                    controller: controller,
                                    themeChange: themeChange),
                                ButtonThem.buildButton(
                                  context,
                                  btnWidthRatio: 0.5,
                                  title: controller.selectedPageIndex.value == 2
                                      ? 'Get started'.tr
                                      : 'Next'.tr,
                                  btnRadius: 30,
                                  onPress: () {
                                    if (controller.selectedPageIndex.value ==
                                        2) {
                                      Preferences.setBoolean(
                                          Preferences.isFinishOnBoardingKey,
                                          true);
                                      Get.offAll(const LoginScreen());
                                    } else {
                                      controller.pageController.jumpToPage(
                                          controller.selectedPageIndex.value +
                                              1);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget oldBody(
      DarkThemeProvider themeChange, context, OnBoardingController controller) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // controller.selectedPageIndex.value == 0
        //     ? Image.asset("assets/images/onboarding_1.png")
        //     : controller.selectedPageIndex.value == 1
        //         ? Image.asset("assets/images/onboarding_2.png")
        //         : Image.asset("assets/images/onboarding_3.png"),

        SizedBox(
            width: width,
            height: height,
            child: Image.asset(
              "assets/images/on_boarding_image.png",
              fit: BoxFit.fitWidth,
            )),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.selectedPageIndex,
                  itemCount: controller.onBoardingList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: controller.onBoardingList[index].image
                                    .toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Constant.loader(context),
                                errorWidget: (context, url, error) =>
                                    Image.network(Constant.userPlaceHolder),
                              ),
                            ),
                          ),
                        ),

                        /*    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        child: CachedNetworkImage(
                                          imageUrl: controller
                                              .onBoardingList[index].image
                                              .toString(),
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.55,
                                          placeholder: (context, url) =>
                                              Constant.loader(context),
                                          errorWidget: (context, url, error) =>
                                              Image.network(
                                                  Constant.userPlaceHolder),
                                        ),
                                      ),
                                    ),*/
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                controller.onBoardingList[index].title
                                    .toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    letterSpacing: 1.5),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  controller.onBoardingList[index].description
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      letterSpacing: 1.5),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ),
            Expanded(
                child: Column(
              children: [
                InkWell(
                  onTap: () {
                    controller.pageController.jumpToPage(2);
                  },
                  child: Text(
                    'Skip'.tr,
                    style: const TextStyle(
                        fontSize: 16,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onBoardingList.length,
                      (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.selectedPageIndex.value == index
                              ? 30
                              : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: controller.selectedPageIndex.value == index
                                ? themeChange.getThem()
                                    ? AppColors.darkModePrimary
                                    : AppColors.primary
                                : const Color(0xffD4D5E0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                          )),
                    ),
                  ),
                ),
                ButtonThem.buildButton(
                  context,
                  title: controller.selectedPageIndex.value == 2
                      ? 'Get started'.tr
                      : 'Next'.tr,
                  btnRadius: 30,
                  onPress: () {
                    if (controller.selectedPageIndex.value == 2) {
                      Preferences.setBoolean(
                          Preferences.isFinishOnBoardingKey, true);
                      Get.offAll(const LoginScreen());
                    } else {
                      controller.pageController
                          .jumpToPage(controller.selectedPageIndex.value + 1);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ))
          ],
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  final OnBoardingController controller;
  final DarkThemeProvider themeChange;

  const DotIndicator(
      {super.key, required this.controller, required this.themeChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.onBoardingList.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 15.0,
              width: controller.selectedPageIndex.value == index ? 30 : 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: controller.selectedPageIndex.value == index
                    ? Colors.blue.shade900
                    : const Color(0xffD4D5E0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Paint paintTwo = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.blue.shade800;
    // paint.color = AppColors.darkBackground;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();

    // Start paint from 20% height to the left
    ovalPath.moveTo(0, height * 0.2);

    // paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);

    // Paint a curve from current position to bottom left of screen at width * 0.1
    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);

    // draw remaining line to bottom left side
    ovalPath.lineTo(0, height);

    // Close line to reset it back
    ovalPath.close();

    paint.color = Colors.blue.shade400;
    // paintTwo.color = Colors.deepPurpleAccent.shade400;
    // paintTwo.color = const Color(0xffc7f5fc);
    paintTwo.color = Colors.blue.shade900;
    canvas.drawPath(ovalPath, paint);
    canvas.drawCircle(Offset(width * 0.9, height * 0.1 - 13), 35.00, paintTwo);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
