import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_globals.dart' as global;
import '../forgot_module/forgot_view.dart';
import '../layout_module/layout_view.dart';
import '../signup_module/signup_view.dart';
import '../static_module/important_dialog_app.dart';
import 'controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static const route = '/login_view';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final loginController = Get.put(LoginController());
  dynamic passEmail, passPassword;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailCnt = TextEditingController();
  TextEditingController passwordCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
      body: Obx(() => loginController.loading.isTrue ? bodyProgress() : bodyWidget(),)
    );
  }

  bodyWidget(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign in',
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: emailCnt,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      border: InputBorder.none,
                      hintText: 'Email *',
                      labelText: 'Email *',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 0, color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (String? value) {
                      if (value!.trim().isNotEmpty) {
                        final RegExp regex = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (!regex.hasMatch(value.trim())) {
                          return 'Please enter a valid email';
                        }
                        else {
                          return null;
                        }
                      } else {
                        return 'Please enter your email';
                      }
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSaved: (String? val) {
                      passEmail = val!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => TextFormField(
                    controller: passwordCnt,
                    obscureText: loginController.isPassObscure.value,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      errorMaxLines: 2,
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        icon: Icon(
                          loginController.isPassObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          loginController.isPassObscure.value = !loginController.isPassObscure.value;
                        },
                      ),
                      hintText: 'Password *',
                      labelText: 'Password *',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 0.0,
                          ), borderRadius: BorderRadius.circular(12)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 0, color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.trim().length < 6) {
                        return 'Your password have a numeric value and it has more than 6 characters';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    onSaved: (String? val) {
                      passPassword = val!;
                    },
                  ),),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(ForgotPasswordView.route);
                        },
                        child: const Text(
                          'Forgot Password?',
                          style:
                          TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(ForgotPasswordView.route);
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        loginController.submitLoginForm(email: emailCnt, password: passwordCnt);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width, 40),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Sign in',
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(SignupView.route);
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (global.isLoginSkip == false) ?
                  Column(
                    children: [
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              loginController.loading.value = true;
                              loginController.storeSkipScreenStatus(true);
                              loginController.loading.value = false;
                              Get.offAllNamed(LayoutView.route);
                            },
                            child: Text(
                              'Continue as guest',
                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ): const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyProgress() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        bodyWidget(),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}