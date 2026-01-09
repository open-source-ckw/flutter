import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/SplashScreen.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);
  static const route = 'splash1';

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  UserMaster? userMaster;
  UserRepository userRepository = UserRepository();

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    print('user');
    print(user);
    if (user != null) {
      var singleUser = await userRepository.getUserFromId(uid: user.uid);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // context.loaderOverlay.hide();
      if (singleUser != false) {
        setState(() {
          userMaster = singleUser;
        });
      }
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    Future.delayed(const Duration(seconds: 3), () async {
      // SharedPreferences pre = await SharedPreferences.getInstance();

      if (userMaster != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
        );
      }
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 110,
                height: 110,
                child: Image.asset(
                  "assets/images/ic_launcher.png",
                  // fit: BoxFit.cover,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              "GymiFit",
              style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).textTheme.headline5!.color),
            ),
          ],
        ),
      ),
    );
  }
}
