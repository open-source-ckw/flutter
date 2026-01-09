// ignore_for_file: prefer_const_constructors

import 'dart:async';

import '../local/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Util/Constants.dart';
import '../firebase/Aurthentication/authentication.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PhoneVerification.dart';
import 'SignInScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static String route = 'signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _isObscure = true;

  AuthenticationRepository authRepository = AuthenticationRepository();
  UserRepository userRepository = UserRepository();

  Future<void> signUp() async {
    String email = this.email.text.trim();
    String password = pass.text.trim();
    /*UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text, password: pass.text
    );*/
    if (_forMKey.currentState!.validate()) {
      // context.loaderOverlay.show();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {}, onError: (e) {
        if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('${getTranslated(context, 'email-already-in-use')}')));
        }
      });

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {

        UserMaster userMaster = UserMaster(
            UM_ID: user.uid,
            um_activityinterest: '',
            um_email: user.email.toString(),
            um_gender: '',
            um_goalweight: 00.00,
            um_goalweightin: 'kg',
            um_weightin: 'kg',
            um_heightin: 'cm',
            um_isapplehealth: false,
            um_height: 00.00,
            um_isdarkmode: false,
            um_ispinlock: false,
            um_maingoal: '',
            um_name: fullName.text.trim().toString(),
            um_phone: phone.text.trim().toString(),
            um_traininglevel: '',
            um_weight: 00.00,
            um_image: user.photoURL ?? '',
            um_dob: '');
        user.sendEmailVerification();
        await userRepository.save(user: userMaster).then((value) async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString(
              Constants.faPhone, user.phoneNumber.toString());
          await sharedPreferences.setString(
              Constants.faFullName, user.displayName.toString());
          await sharedPreferences.setBool(
              Constants.faEmailVerified, user.emailVerified);
          await sharedPreferences.setString(Constants.faPassword, password);
        }).then((value) {
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please Check Your Email and Verify Your Email")));
          Future.delayed(Duration(seconds: 3)).then((value) {
            Navigator.pushNamed(context, SignInScreen.route);
          });
        });
      }
    }
  }

  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      useDefaultLoading: false,
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Form(
            key: _forMKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //addRepaintBoundaries: false,
                    //shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                                '${getTranslated(context, 'sign_up')}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 30.0, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: TextFormField(
                          controller: fullName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${getTranslated(context, 'enter_fullName')}';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            // errorStyle: TextStyle(fontSize: 0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25.0)),
                              hintText: '${getTranslated(context, 'fullName')}',
                              fillColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.14),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlue.shade200),
                                  borderRadius: BorderRadius.circular(25.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: email,
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
                              fillColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.14),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlue.shade200),
                                  borderRadius: BorderRadius.circular(25.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${getTranslated(context, 'enter_num')}';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            // errorStyle: TextStyle(fontSize: 0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25.0)),
                              hintText: '${getTranslated(context, 'phone')}',
                              fillColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.14),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlue.shade200),
                                  borderRadius: BorderRadius.circular(25.0))),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          controller: pass,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${getTranslated(context, 'enter_password')}';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            // errorStyle: TextStyle(fontSize: 0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25.0)),
                            hintText: '${getTranslated(context, 'password')}',
                            fillColor: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.14),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlue.shade200),
                                borderRadius: BorderRadius.circular(25.0)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                          obscureText: _isObscure,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio<bool>(
                              groupValue: isAgree,
                              value: true,
                              onChanged: (bool? value) {
                                setState(() {
                                  isAgree = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                '${getTranslated(context, 'accept_privacy_policy')}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.deepOrange,
                                    letterSpacing: 0.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: InkWell(
                          onTap: () {
                            if (_forMKey.currentState!.validate()) {
                              context.loaderOverlay.show();
                              signUp();
                            }
                            // Navigator.pushNamed(context, PhoneVerification.route);
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
                              '${getTranslated(context, 'sign_up')}',
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${getTranslated(context, 'already_have_account')}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  // color: Colors.black54,
                                  letterSpacing: 0.5),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                ' ${getTranslated(context, 'sign_in')}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                    letterSpacing: 0.5),
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      /*Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Expanded(
                                      child: Text(
                                    'Sign In with',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                    ),
                                  )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.apple,
                                        size: 30,
                                      ),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.facebook,
                                        size: 30,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.google,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async{
                                       await authRepository.signUpWithGmailId().then((value)async {
                                         if(value!=null && value.user!=null)
                                           {
                                             User user = value.user!;
                                             UserMaster userMaster = UserMaster(
                                                 UM_ID: user.uid,
                                                 um_activityinterest: '',
                                                 um_email: user.email.toString(),
                                                 um_gender: '',
                                                 um_goalweight: 00.00,
                                                 um_goalweightin: 'kg',
                                                 um_weightin: 'kg',
                                                 um_heightin: 'cm',
                                                 um_isapplehealth: false,
                                                 um_height: 00.00,
                                                 um_isdarkmode: false,
                                                 um_ispinlock: false,
                                                 um_maingoal: '',
                                                 um_name: user.displayName.toString(),
                                                 um_phone: '',
                                                 um_traininglevel: '',
                                                 um_weight: 00.00);
                                             await userRepository.save(user: userMaster).then((value) async {
                                               SharedPreferences sharedPreferences =
                                               await SharedPreferences.getInstance();
                                               await sharedPreferences.setString(Constants.faUUID, user.uid);
                                             await setSharedPref(email: user.email!.toString(), password: '', emailVerified: user.emailVerified,isGoogleSignedIn: true);
                                             }).then((value){
                                               Navigator.pushNamed(context, SignInScreen.route);
                                             });
                                           }
                                       });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),*/
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

  Future<void> setSharedPref(
      {required String email,
      required String password,
      required bool emailVerified,
      bool isGoogleSignedIn = false}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    await pre.setString(Constants.faEmail, email);
    await pre.setString(Constants.faPassword, password);
    await pre.setBool(Constants.faEmailVerified, emailVerified);
    await pre.setBool(Constants.faIsGoogleSignedIn, isGoogleSignedIn);
  }
}
