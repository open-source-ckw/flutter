import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bodyWidget(),
    );
  }

  bodyWidget(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset('assets/logo.png',
                  height: 70,
                  width: 70),
              //const SizedBox(width: 10,),
              const Text('ashionia', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300),),
            ],
          ),
          const SizedBox(height: 30,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.black,),
            ],
          ),
        ]);
  }
}
