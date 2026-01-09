import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/controller/auth_controller.dart';
import 'package:stacks/theme/app_colors.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController? controller = Get.put(AuthController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to Stacks!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff002347),
                fontSize: 30,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {
                // Get.toNamed(Routes.HOME);
                controller!.loginGoogle();

              },
              child: Container(
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xff56d3d2),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 62,
                        vertical: 13,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 21,
                            height: 21,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset('images/login-google.png'),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "GOOGLE SIGN IN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff002347),
                              fontSize: 16,
                              letterSpacing: 0.80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                controller!.loginFacebook();
              },
              child: Container(
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xffffb34b),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 57,
                        right: 53,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset('images/login-facebook.png')),
                          SizedBox(width: 15),
                          Text(
                            "FACEBOOK SIGN IN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff002347),
                              fontSize: 16,
                              letterSpacing: 0.80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
