import 'package:chat_gtp/constants/app_constants.dart';
import 'package:chat_gtp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'login_page.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _isObscure = false;
  bool _isObscure1 = false;
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();
  TextEditingController resetPassword = TextEditingController();

  Future<void> resetPasswordWithEmail() async {
    if (_forMKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetPassword.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Form(
      key: _forMKey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: DropShadow(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/App_Icon.jpg',
                            width: 120,
                            height: 120,
                          )),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Email', style: TextStyle(color: appPrimaryColor)),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                      validator: AppConstants.validateEmail,
                      // style: TextStyle(color: Colors.white),
                      controller: resetPassword,
                      decoration: InputDecoration(
                          hintText: 'Example@gamil.com',
                          hintStyle: TextStyle(color: Colors.grey))),
                  SizedBox(height: height * 0.065),
                  GestureDetector(
                    onTap: () {
                      resetPasswordWithEmail().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Check your email and change password')));
                      });
                    },
                    child: Container(
                      width: width,
                      // height: 20,
                      padding: EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: appPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text('Submit',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an acount?',
                          style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          'Sign in!',
                          style: TextStyle(color: appPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
