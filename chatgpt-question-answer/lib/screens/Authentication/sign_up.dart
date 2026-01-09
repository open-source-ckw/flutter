import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../constants/constants.dart';
import '../../constants/local_data.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseAuth? auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure1 = true;

  // late InternetProvider internetProvider;

  Future<void> signUp() async {
    String email = emailController.text.trim();
    String pass = passwordController.text.trim();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) {
        if (value.user != null) {
          value.user!.sendEmailVerification();
          /*UserMaster userMaster = UserMaster(
              UM_ID: '',
              um_f_name: firstName.text.trim().toString(),
              um_l_name: lastName.text.trim().toString(),
              um_email: value.user!.email.toString(),
              um_image: value.user!.photoURL ?? "",
              um_dob: '',
              um_gender: currentActiveGender.toString(),
              um_type: currentActiveType.toString(),
              auth_id: value.user!.uid);
          userRepository.createUser(userMaster);*/

           sharedPreferences.setString(
               LocalData.appData['faFullName']!, nameController.text.trim());
/*
          sharedPreferences.setString(
              AppConstants.faLastName, lastName.toString());
*/
          sharedPreferences.setBool(
              LocalData.appData['faEmailVerified']!, value.user!.emailVerified);
          /* sharedPreferences.setString(
              AppConstants.faPassword, password.toString());*/
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppConstants.snackColor,
              content: Text(AppConstants.getSuccessMsg(2))));
          Future.delayed(Duration(seconds: 5)).then((value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          });
        }
      }, onError: (e) {
        if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppConstants.warningSnackColor,
              content: Text(
                AppConstants.getWarningMsg(3),
                style: TextStyle(color: Colors.black),
              )));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // internetProvider = Provider.of<InternetProvider>(context,listen: false);
    // checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    // internetProvider = Provider.of<InternetProvider>(context,listen: true);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      // appBar: AppBar(
      //   toolbarHeight: 70,
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   title: Text("Sign Up",),
      //   centerTitle: true,
      // ),

      bottomNavigationBar: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  signUp();
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    color: appPrimaryColor,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  "Register Now",
                  style: TextStyle(
                      color: Colors.white,
                      // fontFamily: "Raleway black",
                      fontSize: 15),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have an Account?",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: appPrimaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),

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

                  // Email
                  const SizedBox(height: 25),

                  Text(
                    "Full Name",
                    style: TextStyle(
                      color: appPrimaryColor,
                      // fontFamily: "Raleway black",
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 13),

                  TextFormField(
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        // color: Colors.white,
                        // fontFamily: "Raleway black",
                        fontSize: 15,
                      ),
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter Full Name",
                          hintStyle: TextStyle(color: Colors.grey))),
                  const SizedBox(height: 15),

                  Text(
                    "Email",
                    style: TextStyle(
                      color: appPrimaryColor,
                      // fontFamily: "Raleway black",
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 13),

                  TextFormField(
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        // color: Colors.white,
                        // fontFamily: "Raleway black",
                        fontSize: 15,
                      ),
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: AppConstants.validateEmail,
                      decoration: const InputDecoration(
                          hintText: "Enter Email",
                          hintStyle: TextStyle(color: Colors.grey))),
                  const SizedBox(height: 15),

                  // firebase LogIn Password
                  Text(
                    "Password",
                    style: TextStyle(
                      color: appPrimaryColor,
                      // fontFamily: "Raleway black",
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        // color: Colors.white,
                        // fontFamily: "Raleway black",
                        fontSize: 15,
                      ),
                      controller: passwordController,
                      obscureText: _isObscure,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Password is required");
                        } else if (value.length < 7) {
                          return ("password more than 8 digit");
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.grey),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
