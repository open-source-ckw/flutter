import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller/signup_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);
  static const route = '/signup_view';

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final signupController = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic passName, passEmail, passPassword;
  TextEditingController passwordCnt = TextEditingController();
  TextEditingController nameCnt = TextEditingController();
  TextEditingController emailCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        body: Obx(() => signupController.loading.isTrue ? bodyProgress() : bodyWidget(),),
    );
  }

  bodyWidget(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sign up',style: TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.w800),),
            const SizedBox(height: 40,),
            Form(
              key: _formKey,
              child:     Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameCnt,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      border: InputBorder.none,
                      hintText: 'Name *',
                      labelText: 'Name *',
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (String? val) {
                      passName = val!;
                    },
                  ),
                  const SizedBox(height: 10,),
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
                    validator: (String? value){
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
                    onSaved: (String? value){
                      passEmail = value;
                    },
                  ),
                  const SizedBox(height: 10,),
                  Obx(() => TextFormField(
                    controller: passwordCnt,
                    obscureText: signupController.isPassObscure.value,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        icon: Icon(
                          signupController.isPassObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          signupController.isPassObscure.value = !signupController.isPassObscure.value;
                        },
                      ),
                      hintText: 'Password *',
                      labelText: 'Password *',
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.trim().length < 6) {
                        return 'your password have a numeric value and it has more than 6 characters';
                      }
                      return null;
                    },
                    onSaved: (String? val) {
                      passPassword = val!;
                    },
                  ),),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: const Text('Already have an account?',style: TextStyle(color: Colors.black,fontSize: 18),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_forward,color: Theme.of(context).primaryColor,),
                      )
                    ],
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                      onPressed: (){
                        if (_formKey.currentState!
                            .validate()) {
                          _formKey.currentState?.save();
                          signupController.userSignup(passName: nameCnt, passEmail: emailCnt, passPassword: passwordCnt);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: Size(MediaQuery.of(context).size.width, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Sign up',style: TextStyle(color: Colors.white))),
                ],
              ),
            )
          ],
        ) ,
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