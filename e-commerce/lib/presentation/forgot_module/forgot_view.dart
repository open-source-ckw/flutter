import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/forgot_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);
  static const route = '/forgot_view';

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final forgotPasswordController = Get.put(ForgotPasswordController());
  final _formKey = GlobalKey<FormState>();
  dynamic passEmail;
  TextEditingController emailCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Obx(() => forgotPasswordController.loading.isTrue ? bodyProgress() : bodyWidget()));
  }

  bodyWidget(){
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please enter your email address. You will receive a link to create a new password via email.',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailCnt,
                      decoration: InputDecoration(
                        filled: true,
                        focusColor: Colors.white,
                        border: InputBorder.none,
                        fillColor: Colors.white,
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
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isNotEmpty) {
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
                      onSaved: (String? val) {
                        passEmail = val!;
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!
                                .validate()) {
                              forgotPasswordController.forgotPassword(passEmail: emailCnt);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size(MediaQuery.of(context).size.width, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('Send',
                              style: TextStyle(
                                  color: Colors.white))),
                    ),
                  ],
                )
              ],
            ),
          )),
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