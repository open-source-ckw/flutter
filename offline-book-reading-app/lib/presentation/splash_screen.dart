import 'package:book_reader_app/core/responsive.dart';
import 'package:book_reader_app/presentation/bottom_bar.dart';
import 'package:book_reader_app/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatelessWidget {
  final Isar isar;
  const SplashScreen({super.key, required this.isar});
  static const route = '/Splash_screen';

  @override
  Widget build(BuildContext context) {

    return Consumer<SplashProvider>(
      builder: (context, splashProvider, _) {
        if (splashProvider.isLoading) {
          return Scaffold(
            body: Container(
              height: screenHeight(context),
              width: screenWidth(context),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/app-images/splash_scr_img.png"),
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover)),
            ),
          );
        } else {
          // Navigate to BottomBar screen once loading completes
          Future.microtask(() {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(isar: isar),));
          });

          // Return empty container temporarily to avoid build error
          return Container(
            height: screenHeight(context),
            width: screenWidth(context),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/app-images/splash_scr_img.png"),
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover)),
          );
        }
      },
    );
  }
}