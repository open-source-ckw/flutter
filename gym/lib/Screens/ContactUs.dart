import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase/DB/Models/UserMaster.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../firebase/DB/Repo/UserRepository.dart';
import '../local/localization/language_constants.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  static const route = "feedback";

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final textNameController = TextEditingController();
  final textEmailController = TextEditingController();
  final textMessageController = TextEditingController();

  dynamic user;
  UserRepository userRepository = UserRepository();
  UserMaster? userMaster;

  // FeedbackRepository feedbackRepository = FeedbackRepository();

  @override
  void initState() {
    super.initState();
    loadUser();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.loaderOverlay.show();
      }
    });
  }

  // Future<void> loadUser() async {
  //   User? userI = FirebaseAuth.instance.currentUser;
  //   user = await userRepository.getUserFromId(uid: userI!.uid);
  //   textNameController.text = '${userI.displayName}';
  //   textEmailController.text = '${userI.email}';
  //   setState(() {
  //     user = user;
  //   });
  // }

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      textNameController.text = '${userMaster!.um_name}';
      textEmailController.text = '${userMaster!.um_email}';
      context.loaderOverlay.hide();
      setState(() {
        // user = user;
      });
    }
  }

  bool isSubmitted = false;
  String errorText = '';

  @override
  void didChangeDependencies() {
    /*data = ModalRoute.of(context)!.settings.arguments;
    user = data['user'];*/
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          // backgroundColor: Colors.transparent,
          title: Text(
            "${getTranslated(context, 'con_us')}",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5!.color),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/ic_launcher.png',
                  width: 170,
                  height: 170,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  expands: false,
                  // cursorColor: Constants.colorsMap['bluegrey'],
                  cursorHeight: 30.0,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25.0)),
                      hintText: 'Name',
                      // fillColor: Colors.blue.shade100.withOpacity(0.6),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue.shade200),
                          borderRadius: BorderRadius.circular(25.0))),
                  controller: textNameController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    expands: false,
                    // cursorColor: Constants.colorsMap['bluegrey'],
                    cursorHeight: 30.0,

                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25.0)),
                        hintText: 'Email',
                        // fillColor: Colors.blue.shade100.withOpacity(0.6),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlue.shade200),
                            borderRadius: BorderRadius.circular(25.0))),
                    controller: textEmailController,
                  ),
                ),
                TextFormField(
                  expands: false,
                  // cursorColor: Constants.colorsMap['bluegrey'],
                  cursorHeight: 30.0,
                  maxLines: 4,
                  textAlignVertical: TextAlignVertical.top,
                  maxLength: 255,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "${getTranslated(context, 'enter_some_text')}";
                    }
                    return null;
                  },
                  // onChanged: (value) {
                  //
                  //   if (value.trim() != '') {
                  //     setState(() {
                  //       isSubmitted = false;
                  //     });
                  //   } else {
                  //     setState(() {
                  //       isSubmitted = true;
                  //     });
                  //   }
                  // },
                  decoration: InputDecoration(
                      // errorStyle: TextStyle(fontSize: 0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25.0)),
                      hintText: "${getTranslated(context, 'mgs')}",
                      // fillColor: Colors.blue.shade100.withOpacity(0.6),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue.shade200),
                          borderRadius: BorderRadius.circular(25.0))),
                  controller: textMessageController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 50.0,
                        width: 100.0,
                        // height: MediaQuery.of(context).size.height * 0.065,
                        // width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              context.loaderOverlay.show();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.green.shade600,
                                  content: Text(
                                      "${getTranslated(context, 'thk_cont_us')}")));
                            }
                            context.loaderOverlay.hide();

                            /* await onSubmit().then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Feedback sent.',
                                      // style: Constants.textStyle
                                  ),
                                  // backgroundColor: Constants.infoColor,
                                  duration:
                                  const Duration(milliseconds: 400),
                                ));
                                // Future.delayed(
                                //     const Duration(milliseconds: 1000))
                                //     .then((value) {
                                //   Navigator.pushNamedAndRemoveUntil(
                                //       context, HomeScreen.route,(route)=>false);
                                // });
                              } else {
                                if (getErrorText(textMessageController) ==
                                    null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'Failed !! Try Again',
                                      // style: Constants.textStyle,
                                    ),
                                    // backgroundColor: Constants.errorColor,
                                  ));
                                }
                              }
                            });*/
                          },
                          child: Text(
                            "${getTranslated(context, 'submit')}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// String? getErrorText(controller) {
//   if (controller == textMessageController) {
//     if (textMessageController.text.trim() == '') {
//       return 'Please enter message';
//     }
//     return null;
//   }
// }

// Future<bool> onSubmit() async {
//   setState(() {
//     isSubmitted = true;
//   });
//   if (getErrorText(textMessageController) == null) {
//     ContactUs contactUs = ContactUs(
//         usermasterID: user.id,
//         cu_email: textEmailController.text,
//         cu_name: textNameController.text,
//         cu_message: textMessageController.text);
//     final result = await feedbackRepository.saveFeedback(contactUs);
//     return result;
//   } else {
//     return false;
//   }
// }
}
