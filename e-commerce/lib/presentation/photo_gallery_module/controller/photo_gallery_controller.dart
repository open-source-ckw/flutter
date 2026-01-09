import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoGalleryController extends GetxController{
  final CarouselController controller = CarouselController();

  RxInt currentIndex = 0.obs;
  PageController? pageController;

  @override
  void onInit() {
    super.onInit();
  }
}