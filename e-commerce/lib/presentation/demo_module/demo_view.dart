import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/demo_controller.dart';

class DemoView extends StatefulWidget {
  const DemoView({Key? key}) : super(key: key);
  static const route = '/demo_view';

  @override
  State<DemoView> createState() => _DemoViewState();
}

class _DemoViewState extends State<DemoView> {
  final demoController = Get.put(DemoController());

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}