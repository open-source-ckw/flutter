// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local/localization/language_constants.dart';
import 'SignInScreen.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);
  static const String route = 'AccountInfo';

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  StorageHandler storageHandler = StorageHandler();

  TextEditingController selectDate = TextEditingController();
  TextEditingController selectName = TextEditingController();
  TextEditingController selectWeight = TextEditingController();

  File? imageFile;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.imageFile = imageTemp);
    } on PlatformException catch (e) {
      // print('Failed to pick image: $e');
    }
  }

  Future clickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.imageFile = imageTemp);
    } on PlatformException catch (e) {
      // print('Failed to pick image: $e');
    }
  }

  UserMaster? userMaster;
  UserRepository userRepository = UserRepository();

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user);
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      selectName.text = userMaster!.um_name;
      selectWeight.text = userMaster!.um_weight.toString();
      selectDate.text = userMaster!.um_dob;
      // imageFile = File(userMaster!.um_image);
      context.loaderOverlay.hide();
      setState(() {
        userMaster = userMaster;
      });
    }
  }

  Future<void> deleteAccount(UserMaster userMaster) async {
    User? user = FirebaseAuth.instance.currentUser;

    await user!.delete().then((value) async {
      DatabaseReference reference = FirebaseDatabase.instance.ref("UserMaster");
      reference.onDisconnect();
      reference.child(userMaster.UM_ID).remove();
      // reference.remove();

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear().then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, SignInScreen.route, (route) => false);
        // Navigator.pushNamed(context, SignInScreen.route);
      });
    });
  }

  dynamic user;
  dynamic data;

  @override
  void initState() {
    super.initState();
    loadUser();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (mounted) {
    //     context.loaderOverlay.show();
    //   }
    // });
  }

  @override
  void dispose() {
    // print('IN DISPOSE');
    imageFile = null;
    super.dispose();
  }

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
      child: userMaster == null
          ? Container()
          : Scaffold(
              // backgroundColor: Colors.blue.shade50,
              appBar: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                centerTitle: true,
                elevation: 0.0,
                // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                iconTheme:
                    IconThemeData(color: Theme.of(context).iconTheme.color),
                title: Text(
                  "${getTranslated(context, 'account_info')}",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline5!.color),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        context.loaderOverlay.show();

                        userMaster!.um_name = selectName.text;
                        userMaster!.um_weight = double.parse(selectWeight.text);
                        userMaster!.um_dob = selectDate.text;

                        if (imageFile != null || userMaster!.um_image != "") {
                          await userRepository
                              .updateUser(imageFile, userMaster!)
                              .then((value) async {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "${getTranslated(context, 'profile_update')}",
                                // style: Constants.textStyle,
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(milliseconds: 600),
                            ));
                            if (context.loaderOverlay.visible) {
                              context.loaderOverlay.hide();
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              userMaster = userMaster;
                            });
                            /* Future.delayed(const Duration(milliseconds: 1000)).then((val){

                    Navigator.pop(context, value);
                    });*/
                          });
                        }
                      },
                      child: Text(
                        "${getTranslated(context, 'save')}",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline5!.color),
                      ))
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )),
                                  // backgroundColor: Colors.white,
                                  barrierColor: Colors.blue.withOpacity(0.1),
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    requestPhotosPermission()
                                                        .then((value) {
                                                      pickImage().then((value) {
                                                        Navigator.pop(context);
                                                      });
                                                    });
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .add_a_photo_outlined,
                                                        size: 90,
                                                      ),
                                                      Text(
                                                        "${getTranslated(context, 'add_pic')}",
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    requestCameraPermission()
                                                        .then((value) {
                                                      clickImage()
                                                          .then((value) {
                                                        Navigator.pop(context);
                                                      });
                                                    });
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.camera_outlined,
                                                        size: 90,
                                                      ),
                                                      Text(
                                                          "${getTranslated(context, 'camera')}"),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: imageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ))
                                : userMaster!.um_image != ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: CachedNetworkImage(
                                          imageUrl: userMaster!.um_image,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.blue.shade900,
                                        minRadius: 60.0,
                                        child: Text(
                                          userMaster!.um_name.characters.first,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                        tileColor:
                            Theme.of(context).disabledColor.withOpacity(0.11),
                        onTap: () {},
                        title: Text("${getTranslated(context, 'name')}"),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextFormField(
                                  controller: selectName,
                                  decoration: InputDecoration(
                                      hintTextDirection: TextDirection.ltr,
                                      border: InputBorder.none,
                                      hintText: userMaster!.um_name),
                                )),
                            // Icon(
                            //   Icons.arrow_forward_ios,
                            //   size: 15.0,
                            // ),
                          ],
                        ),
                        // tileColor: Colors.white,
                      ),
                      ListTile(
                        onTap: () {},
                        title: Text("${getTranslated(context, 'weight')}"),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextFormField(
                                  controller: selectWeight,
                                  decoration: InputDecoration(
                                      hintTextDirection: TextDirection.ltr,
                                      border: InputBorder.none,
                                      hintText:
                                          '${userMaster!.um_weight} ${userMaster!.um_weightin}'),
                                )),

                            /* Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15.0,
                                  ),*/
                          ],
                        ),
                        tileColor:
                            Theme.of(context).disabledColor.withOpacity(0.11),
                      ),
                      ListTile(
                        onTap: () {},
                        title: Text("${getTranslated(context, 'dob')}"),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: DateTimePicker(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintTextDirection: TextDirection.rtl,
                                ),
                                controller: selectDate,
                                dateMask: 'd MMM, yyyy',
                                dateHintText: userMaster!.um_dob,
                                initialValue: null,
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2100),
                                dateLabelText: 'DOB',
                                // style: const TextStyle(fontSize: 22),

                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.blue.shade900,
                                  size: 20,
                                ),
                                onChanged: (val) => print(val),
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ),
                            ),
                            /* Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15.0,
                                  ),*/
                          ],
                        ),
                        tileColor:
                            Theme.of(context).disabledColor.withOpacity(0.11),
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                        onTap: () {},
                        title: Text("${getTranslated(context, 'email')}"),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: userMaster!.um_email),
                                )),
                            /*Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15.0,
                                  ),*/
                          ],
                        ),
                        tileColor:
                            Theme.of(context).disabledColor.withOpacity(0.11),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      content: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${getTranslated(context, 'are_deactivate_account')}"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  // onPressed:
                                                  //     () async {
                                                  //   User? user = FirebaseAuth.instance.currentUser;
                                                  //   user!.delete();
                                                  //   // scheduleWorkout(context);
                                                  // },

                                                  onPressed: () async {
                                                    // Navigator.pop(context);
                                                    deleteAccount(userMaster!);
                                                  },

                                                  child: Text(
                                                      "${getTranslated(context, 'yes')}"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                      "${getTranslated(context, 'no')}"),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue[900],
                                // border: Border.all(color: Colors.blue.shade50),
                                borderRadius: BorderRadius.circular(40.0)),
                            child: Text(
                              "${getTranslated(context, 'deactivate_account')}",
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
                ),
              ),
            ),
    );
  }

  requestPhotosPermission() async {
    final serviceStatus = await Permission.photos.isGranted;

    bool isPhotosOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.photos.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      await Permission.photos.request();
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await _showMyPermissionDialog();
    }
  }

  Future<void> requestCameraPermission() async {
    final serviceStatus = await Permission.camera.isGranted;

    bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      await Permission.camera.request();
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await _showMyPermissionDialog();
    }
  }

  /// Permission setting move dialog......
  _showMyPermissionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Need to permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This feature cannot be used without permission.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              ),
              child: Text('Cancel', style: TextStyle(color: Colors.lightBlue[900]),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              ),
              child: Text('Go to Settings', style: TextStyle(color: Colors.lightBlue[900]),),
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
