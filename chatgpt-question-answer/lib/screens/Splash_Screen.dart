import 'dart:async';
import 'package:chat_gtp/Chats/chats.dart';
import 'package:chat_gtp/screens/Authentication/login_page.dart';
import 'package:chat_gtp/screens/all_chat.dart';
import 'package:chat_gtp/screens/chat_screen.dart';
import 'package:chat_gtp/services/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const route = 'splash1';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // loadUser();
    Future.delayed(const Duration(seconds: 3), () async {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AllChatPage()),
          (route) => false,
        );

      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _SplashScreen();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropShadow(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/App_Icon.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Talk AI",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
