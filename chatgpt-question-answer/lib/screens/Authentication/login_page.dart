// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_gtp/constants/constants.dart';
import 'package:chat_gtp/screens/Authentication/sign_up.dart';
import 'package:chat_gtp/screens/all_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drop_shadow/drop_shadow.dart';
import '../../constants/app_constants.dart';
import '../../constants/apple_services.dart';
import '../../constants/apple_signin_available.dart';
import '../../constants/google_auth.dart';
import '../../constants/local_data.dart';
import '../chat_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'forget_password.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  FirebaseAuth? auth = FirebaseAuth.instance;
  final _forMKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  AuthService authService = AuthService();

  bool isAvailable = true;

  Future<void> signInUsingEmailAndPassword(
      {required String email, required String password}) async {
    // if (context.loaderOverlay.visible) {
    //   context.loaderOverlay.hide();
    // }
    if (_forMKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {}, onError: (e) {
        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppConstants.errorSnackColor,
              content: Text(AppConstants.getErrorMsg(1))));
        } else if (e.code == "invalid-email") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppConstants.warningSnackColor,
              content: Text(
                AppConstants.getWarningMsg(1),
                style: TextStyle(color: Colors.black),
              )));
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppConstants.errorSnackColor,
              content: Text(AppConstants.getErrorMsg(2))));
        } else if (e.code == "invalid-email-verified") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppConstants.warningSnackColor,
              content: Text(
                AppConstants.getWarningMsg(2),
                style: TextStyle(color: Colors.black),
              )));
        } else if (e.code == 'too-many-requests') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppConstants.errorSnackColor,
              content: Text(
                AppConstants.getErrorMsg(12),
              )));
        }
      });
    }
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

/*  signIn() async {
    // context.loaderOverlay.show();
    String email = emailController.text.trim();
    String passw = passwordController.text.trim();

    await signInUsingEmailAndPassword(email: email, password: passw)
        .then((value) async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // if (context.loaderOverlay.visible) {
        //   context.loaderOverlay.hide();
        // }
        //TODO: Add alert here
      } else {
        await user.reload();
        // UserMaster? userMaster = await userRepository.getUserFromId(user.uid);
        // If user verified then logged in otherwise send verification email
        if (user.emailVerified) {
          // Add login user data in to local data to prevent auto login
          await setSharedPref(
            email: email,
            password: passw,
            emailVerified: user.emailVerified,
            // user.uid,
            uuid: user.uid,
          );
          // print(user.emailVerified);
          if (mounted) {
            */ /*if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }*/ /*
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
                (route) => false);
          }
        } else {
          */ /*if (context.loaderOverlay.visible) {
            context.loaderOverlay.hide();
          }*/ /*
          //TODO: Resend verification email if used didn't verified yet.
          showVerifyEmailToast(context);
          User? auth = FirebaseAuth.instance.currentUser;
          await auth!.sendEmailVerification();
        }
      }
    });
  }*/

  signIn() async {
    // context.loaderOverlay.show();
    String email = emailController.text.trim();
    String passw = passwordController.text.trim();

    await signInUsingEmailAndPassword(email: email, password: passw)
        .then((value) async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
        //TODO: Add alert here
      } else {
        await user.reload();
        // UserMaster? userMaster = await userRepository.getUserFromId(user.uid);
        // If user verified then logged in otherwise send verification email
        if (user.emailVerified) {
          // Add login user data in to local data to prevent auto login
          await setSharedPref(
            email: email,
            password: passw,
            emailVerified: user.emailVerified,
            // user.uid,
            uuid: user.uid,
          );
          // print(user.emailVerified);
          if (mounted) {
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
            return await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AllChatPage()),
                (route) => false);
          }
        } else {
          if (context.loaderOverlay.visible) {
            context.loaderOverlay.hide();
          }
          //TODO: Resend verification email if used didn't verified yet.
          showVerifyEmailToast(context);
          User? auth = FirebaseAuth.instance.currentUser;
          await auth!.sendEmailVerification();
        }
      }
    });
  }

  void showVerifyEmailToast(BuildContext context) {
    if (context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppConstants.warningSnackColor,
          content: Text(AppConstants.getWarningMsg(2),
              style: TextStyle(
                color: Colors.black,
              ))));
      return false;
    });
  }

  Future<void> setSharedPref(
      {required String email,
      required String password,
      required bool emailVerified,
      required String uuid,
      bool isGoogleSignedIn = false}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    await pre.setString(LocalData.appData['faEmail']!, email);
    await pre.setString(LocalData.appData['faUUID']!, uuid);
    await pre.setString(LocalData.appData['faPassword']!, password);
    await pre.setBool(LocalData.appData['faEmailVerified']!, emailVerified);
    await pre.setBool(
        LocalData.appData['faIsGoogleSignedIn']!, isGoogleSignedIn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    return LoaderOverlay(
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      useDefaultLoading: true,
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(child: CircularProgressIndicator()),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _forMKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),

                    DropShadow(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/App_Icon.jpg',
                            width: 120,
                            height: 120,
                          )),
                    ),

                    SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            color: appPrimaryColor,
                            // fontFamily: "Raleway black",
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 13),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        // color: Colors.white,
                        // fontFamily: "Raleway black",
                        fontSize: 15,
                      ),
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: AppConstants.validateEmail,
                      decoration: InputDecoration(
                          hintText: "Enter Email",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(height: 15),

                    // firebase LogIn Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            color: appPrimaryColor,
                            // fontFamily: "Raleway black",
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          // color: Colors.white,
                          // fontFamily: "Raleway black",
                          fontSize: 15,
                        ),
                        controller: passwordController,
                        obscureText: _isObscure,
                        // onChanged: (value){
                        //   setState(() {});
                        // },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Password is required");
                          } else if (value.length < 7) {
                            return ("password more than 8 digit");
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        )),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassword()));
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: appPrimaryColor),
                      ),
                    ),

                    const SizedBox(height: 30),

                    InkWell(
                      onTap: () async {
                        if (_forMKey.currentState!.validate()) {
                          context.loaderOverlay.show();
                          signIn();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: appPrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        // margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Login Now",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SignInButton(
                          Buttons.Google,
                          onPressed: () async {
                            context.loaderOverlay.show();

                            try {
                              await authenticationRepository
                                  .signUpWithGmailId()
                                  .then((value) async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.setString(
                                    LocalData.appData['faUUID']!,
                                    value!.user!.uid);
                                setSharedPref(
                                    email: value.user!.email.toString(),
                                    password: '',
                                    emailVerified: value.user!.emailVerified,
                                    isGoogleSignedIn: true,
                                    uuid: value.user!.uid);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllChatPage()),
                                    (route) => false);
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor:
                                          AppConstants.errorSnackColor,
                                      content: Text(
                                        AppConstants.getErrorMsg(num),
                                      )));

                              if (context.loaderOverlay.visible) {
                                context.loaderOverlay.hide();
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (appleSignInAvailable.isAvailable)
                      Center(
                        child: Container(
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SignInButton(
                            Buttons.AppleDark,
                            onPressed: () async {
                              context.loaderOverlay.show();
                              try {
                                await signInWithApple().then((value) async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString(
                                      LocalData.appData['faUUID']!, value.uid);
                                  setSharedPref(
                                      email: value.email.toString(),
                                      password: '',
                                      emailVerified: value.emailVerified,
                                      isGoogleSignedIn: true,
                                      uuid: value.uid);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllChatPage()),
                                      (route) => false);
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:
                                            AppConstants.errorSnackColor,
                                        content: Text(
                                          AppConstants.getErrorMsg(num),
                                        )));

                                if (context.loaderOverlay.visible) {
                                  context.loaderOverlay.hide();
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),

                    /*Center(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SignInButton(
                          Buttons.FacebookNew,
                          onPressed: () {
                            authenticationRepository
                                .signInWithFacebook()
                                .then((value) async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString(
                                  LocalData.appData['faUUID']!, value.user!.uid);
                              setSharedPref(
                                  email: value.user!.email!.toString(),
                                  password: '',
                                  emailVerified: value.user!.emailVerified,
                                  isGoogleSignedIn: true,
                                  uuid: value.user!.uid);
                            }).then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen()),
                                  (route) => false);
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),*/

                    const SizedBox(height: 30),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Do you Have an Account?",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                            TextSpan(
                                text: " Register Now",
                                style: TextStyle(
                                    color: appPrimaryColor, fontSize: 15))
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
