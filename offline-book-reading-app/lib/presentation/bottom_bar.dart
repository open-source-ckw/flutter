import 'dart:io';

import 'package:book_reader_app/core/colors.dart';
import 'package:book_reader_app/core/responsive.dart';
import 'package:book_reader_app/presentation/about_us_screen.dart';
import 'package:book_reader_app/presentation/section_screen.dart';
import 'package:book_reader_app/presentation/setting_screen.dart';
import 'package:book_reader_app/provider/bottombar_provider.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


class BottomBar extends StatefulWidget {
  final Isar isar;
  BottomBar({super.key, required this.isar});
  static const route = '/bottom_bar';

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {

    final bottomProvider = Provider.of<BottomBarProvider>(context);

    final screens = [
      SectionScreen(isar: widget.isar),
      Center(child: Text("Search Page", style: TextStyle(color: appBlack))),
      AboutUsScreen(isar: widget.isar),
      SettingScreen(isar: widget.isar,)
    ];

    return Scaffold(
      body: screens[bottomProvider.currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8.0),
        alignment: Alignment.topCenter,
        height: Platform.isIOS ? screenHeight(context) * 0.085 : screenHeight(context) * 0.075,
        color:primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                bottomProvider.setIndex(0);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(10.0),
                    gradient: bottomProvider.currentIndex == 0 ? LinearGradient(
                      colors: [secondaryColor, lighterSecondary],
                      tileMode: TileMode.mirror,
                    ) : null
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: bottomProvider.currentIndex == 0 ? appBlack : appWhite),
                    const WidthGap(gap: 0.01),
                    bottomProvider.currentIndex == 0 ? Text("Home", style: TextStyle(color: appBlack),) : const SizedBox(),
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                Share.share("https://play.google.com/store/apps");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(10.0),
                    // color: bottomProvider.currentIndex == 1 ? secondaryColor : Colors.transparent,
                  gradient: bottomProvider.currentIndex == 1 ? LinearGradient(
                  colors: [secondaryColor, lighterSecondary],
                  transform: const GradientRotation(45),
                  tileMode: TileMode.mirror,
                ) : null
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share, color: bottomProvider.currentIndex == 1 ? appBlack : appWhite),
                    const WidthGap(gap: 0.01),
                    bottomProvider.currentIndex == 1 ? Text("Share", style: TextStyle(color: appBlack),) : const SizedBox(),
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                bottomProvider.setIndex(2);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(10.0),
                    color: bottomProvider.currentIndex == 2 ? secondaryColor : Colors.transparent,
                  gradient: bottomProvider.currentIndex == 2 ? LinearGradient(
                colors: [secondaryColor, lighterSecondary],
                  tileMode: TileMode.decal,
                ) : null
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: bottomProvider.currentIndex == 2 ? appBlack : appWhite),
                    const WidthGap(gap: 0.02),
                    bottomProvider.currentIndex == 2 ? Text("About us", style: TextStyle(color: appBlack),) : const SizedBox(),
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {
                bottomProvider.setIndex(3);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(10.0),
                  gradient: bottomProvider.currentIndex == 3 ? LinearGradient(
                colors: [secondaryColor, lighterSecondary],
                  tileMode: TileMode.mirror,
                ) : null
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings, color: bottomProvider.currentIndex == 3 ? appBlack : appWhite),
                    const WidthGap(gap: 0.01),
                    bottomProvider.currentIndex == 3 ? Text("Settings", style: TextStyle(color: appBlack),) : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
