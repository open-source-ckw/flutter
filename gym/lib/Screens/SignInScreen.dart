// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unnecessary_null_comparison

// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../firebase/Aurthentication/AppleServices.dart';
import '../firebase/Aurthentication/AppleSigninAvailable.dart';
import '../local/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/HomeScreen.dart';
import '../Screens/ProfileSetup.dart';
import '../Screens/ForgotPassword.dart';
import '../Util/Constants.dart';
import '../firebase/Aurthentication/authentication.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/DB/Models/UserMaster.dart';
import 'SignUpScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const route = 'signIn';

  // static const route = '/';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isObscure = true;

  TextEditingController emailorphone = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  UserRepository userRepository = UserRepository();

  Future<void> signInUsingEmailAndPassword(
      {required String email, required String password}) async {
    if (_forMKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {}, onError: (e) {
        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red.shade500,
              content: Text('${getTranslated(context, 'not_register')}')));
        } else if (e.code == "invalid-email") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red.shade500,
              content: Text('${getTranslated(context, 'invalid-email')}')));
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red.shade500,
              content: Text('${getTranslated(context, 'wrong-password')}')));
        } else if (e.code == "invalid-email-verified") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red.shade500,
              content:
                  Text('${getTranslated(context, 'invalid-email-verified')}')));
        }
      });
    }
  }

  Future<void> signIn() async {
    return await Future.delayed(
      const Duration(seconds: 3),
      () async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? email = sharedPreferences.getString(Constants.faEmail);
        // String password;
        // This is when perform auto login, If user is already login then don't required to do login again.
        if (email != null) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            //Responsible for auto-login
            UserMaster userMaster =
                await userRepository.getUserFromId(uid: user.uid);
            if (userMaster == null) {
              if (context.loaderOverlay.visible) {
                context.loaderOverlay.hide();
              }
              Navigator.pushReplacementNamed(context, SignInScreen.route);
              return null;
            } else {
              if (user.emailVerified) {
                return await checkProfileSetup(userMaster: userMaster);
              }
              showVerifyEmailToast(context);
              return null;
            }
          }
        } else {
          String email = emailorphone.text.trim();
          String password = this.password.text.trim();

          if (email != '' && password != '') {
            return await signInUsingEmailAndPassword(
                    email: email, password: password)
                .then((value) async {
              User? user = FirebaseAuth.instance.currentUser;

              if (user == null) {
                if (context.loaderOverlay.visible) {
                  context.loaderOverlay.hide();
                }
                return null;
              } else {
                await user.reload();
                UserMaster? userMaster =
                    await userRepository.getUserFromId(uid: user.uid);

                // print(user);
                // print(userMaster);
                /*// Add login user data in to local data to prevent auto login
                await setSharedPref(
                    email: email,
                    password: password,
                    emailVerified: user.emailVerified);*/
                if (user.emailVerified) {
                  // Add login user data in to local data to prevent auto login
                  await setSharedPref(
                    email: email,
                    password: password,
                    emailVerified: user.emailVerified,
                    // user.uid,
                    uuid: user.uid,
                  );
                  // print(user.emailVerified);
                  return await checkProfileSetup(userMaster: userMaster);
                } else {
                  //TODO: Resend verification email if used didn't verified yet.
                  User? auth = FirebaseAuth.instance.currentUser;
                  await auth!.sendEmailVerification();
                }
                showVerifyEmailToast(context);
                return null;
              }
            });
          }
          if (mounted) {
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          }
        }
        return null;
      },
    );
  }

  void showVerifyEmailToast(BuildContext context) {
    if (context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${getTranslated(context, 'verify_first')}')));
      return false;
    });
  }

  checkProfileSetup({required UserMaster? userMaster}) async {
    if (userMaster != null) {
      String reDirectRoute = ProfileSetup.route;
      reDirectRoute = userMaster.um_gender.trim() == ''
          ? ProfileSetup.route
          : HomeScreen.route;
      if (mounted) {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
          Navigator.pushReplacementNamed(context, reDirectRoute);
        }
      }
    } else {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  Future<bool> checkProfileSetupOLD({required UserMaster? userMaster}) async {
    if (userMaster != null) {
      String reDirectRoute = ProfileSetup.route;
      reDirectRoute = userMaster.um_gender.trim() == ''
          ? ProfileSetup.route
          : HomeScreen.route;
      bool returnValue = userMaster.um_gender.trim() == '' ? true : false;
      if (mounted) {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
      }
      return await Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.pushReplacementNamed(context, reDirectRoute);
        return returnValue;
      });
    } else {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
      return false;
    }
  }

  Future<void> setSharedPref(
      {required String email,
      required String password,
      required bool emailVerified,
      required String uuid,
      bool isGoogleSignedIn = false}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    await pre.setString(Constants.faEmail, email);
    await pre.setString(Constants.faUUID, uuid);
    await pre.setString(Constants.faPassword, password);
    await pre.setBool(Constants.faEmailVerified, emailVerified);
    await pre.setBool(Constants.faIsGoogleSignedIn, isGoogleSignedIn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.loaderOverlay.show();
    // });
    // signIn();
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final _firebaseAuth = FirebaseAuth.instance;

    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  /*Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    reference.onDisconnect();

    await FirebaseAuth.instance.signOut().then((value) async {
      await Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.route, (route) => false);
    });

    setState(() {});
  }*/
  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();

    await FirebaseAuth.instance.signOut().then((value) async {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.route,
            (route) => false,
      );
    });

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    return LoaderOverlay(
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      useDefaultLoading: false,
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: Form(
        key: _forMKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: _body(),
        ),
      ),
    );
  }

  _body(){
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                        '${getTranslated(context, 'sign_in')}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: TextFormField(
                  controller: emailorphone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     backgroundColor: Colors.red.shade500,
                      //     content: const Text('please enter email')));
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
                  controller: password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     backgroundColor: Colors.red.shade500,
                      //     content: const Text('please enter password')));
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
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlue.shade200),
                          borderRadius: BorderRadius.circular(25.0))),
                  obscureText: _isObscure,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: ElevatedButton(
                    child: Text(
                      '${getTranslated(context, 'sign_in')}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0, letterSpacing: 1.0,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(MediaQuery.of(context).size.width, 50),
                        backgroundColor: Colors.lightBlue[900],
                        elevation: 3, //elevation of button
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.all(15) //content padding inside button
                    ),
                    onPressed: () async {
                      if (_forMKey.currentState!.validate()) {
                        context.loaderOverlay.show();
                        signIn();
                      }
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ForgetPassword.route);
                  },
                  child: Text(
                    '${getTranslated(context, 'forget_password')}',
                    style: TextStyle(
                        fontSize: 14.0,
                        // color: Colors.black54,
                        letterSpacing: 0.5),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: SignInButton(
                  Buttons.Apple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () async {
                    this.context.loaderOverlay.show();
                    await signInWithApple().then((value) async {
                      if (value != null && value != '') {
                        User? user = value;
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
                            um_weight: 00.00,
                            um_image: '',
                            um_dob: '');
                        await userRepository
                            .save(user: userMaster)
                            .then((usrValue) async {
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          await sharedPreferences.setString(
                              Constants.faUUID, usrValue.UM_ID);
                          await setSharedPref(
                              email: usrValue.um_email.toString(),
                              password: '',
                              emailVerified: user.emailVerified,
                              isGoogleSignedIn: true,
                              uuid: usrValue.UM_ID);
                          await checkProfileSetup(userMaster: usrValue);
                        });
                      } else if (this.context.loaderOverlay.visible) {
                        this.context.loaderOverlay.hide();
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: SignInButton(
                  Buttons.Google,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () async {
                    this.context.loaderOverlay.show();
                    await authenticationRepository
                        .signUpWithGmailId()
                        .then((value) async {
                      if (value != null && value.user != null) {
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
                            um_weight: 00.00,
                            um_image: user.photoURL!,
                            um_dob: '');
                        await userRepository
                            .save(user: userMaster)
                            .then((value) async {
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          await sharedPreferences.setString(
                              Constants.faUUID, user.uid);
                          await setSharedPref(
                              email: user.email!.toString(),
                              password: '',
                              emailVerified: user.emailVerified,
                              isGoogleSignedIn: true,
                              uuid: user.uid);
                          await checkProfileSetup(userMaster: value);
                        });
                      }
                    });
                    if (this.context.loaderOverlay.visible) {
                      this.context.loaderOverlay.hide();
                    }
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${getTranslated(context, 'do_not_have_account')}',
                    style: TextStyle(
                        fontSize: 16.0,
                        // color: Colors.black54,
                        letterSpacing: 0.5),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.route);
                    },
                    child: Text(
                      ' ${getTranslated(context, 'sign_up')}',
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
          )
        ],
      ),
    );
  }
}
