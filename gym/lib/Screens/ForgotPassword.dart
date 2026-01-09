import '../local/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/SignInScreen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);
  static const route = 'forgotPassword';

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _forMKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        '${getTranslated(context, 'forget_password')}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: resetPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${getTranslated(context, 'enter_email')}';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        // errorStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25.0)),
                        hintText: '${getTranslated(context, 'email')}',
                        // fillColor: Colors.blue.shade100.withOpacity(0.6),
                        fillColor:
                            Theme.of(context).disabledColor.withOpacity(0.14),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlue.shade200),
                            borderRadius: BorderRadius.circular(25.0),
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: InkWell(
                      onTap: () {
                        if (_forMKey.currentState!.validate()) {
                          context.loaderOverlay.show();
                          resetPasswordWithEmail().then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Password Reset Sent Email')));
                          }).then((value) {
                            Navigator.pushNamed(context, SignInScreen.route);
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            border: Border.all(color: Colors.blue.shade50),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text(
                          '${getTranslated(context, 'forget_password')}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
