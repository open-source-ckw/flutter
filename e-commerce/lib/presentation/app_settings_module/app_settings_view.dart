import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_globals.dart' as global;
import '../login_module/login_view.dart';
import 'controller/app_settings_controller.dart';

class AppSettingsView extends StatefulWidget {
  const AppSettingsView({Key? key}) : super(key: key);
  static const route = '/appSettings_view';

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView> {
  final appSettingsController = Get.put(AppSettingsController());
  final _formKey = GlobalKey<FormState>();
  var userName, userEmail;
  TextEditingController userNameCnt = TextEditingController();
  TextEditingController userEmailCnt = TextEditingController();

  @override
  void initState() {
    userNameCnt.text = global.isUserData['display_name'];
    userEmailCnt.text = global.isUserData['user_email'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              if (_formKey.currentState!
                  .validate()) {
                _formKey.currentState?.save();
                Map<String, dynamic> arrPassData = {
                  'id': global.isUserData['ID'],
                  'name': userNameCnt.text,
                };
                appSettingsController.userProfileUpdate(arrPostData: arrPassData);
              } else {
                //errorData();
              }
            },
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      body: Obx(() => appSettingsController.isLoading.isTrue ? bodyProgress() : bodyWidget(),),
    );
  }

  bodyWidget(){
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Settings',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.w700),),
              const SizedBox(height: 20,),
              const Text('Personal Information',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 20,),
              /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child: (_image != null) ? Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ) : CachedNetworkImage(
                            imageUrl: noUsrImg,
                            *//*imageUrl: (global.isUserData['user_url'].isEmpty)
                                ? noUsrImg
                                : global.isUserData['user_url'],*//*
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                                imageUrl: noImg,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.camera,
                        size: 20.0,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20,),*/
              TextFormField(
                controller: userNameCnt,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: InputBorder.none,
                  hintText: 'Name *',
                  labelText: 'Name',
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
                    return 'Please enter name';
                  }
                  return null;
                },
                onSaved: (String? val) {
                  userName = val!;
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                readOnly : true,
                controller: userEmailCnt,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  focusColor: Colors.white,
                  border: InputBorder.none,
                  hintText: 'Email *',
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
                  if (value!.isNotEmpty) {
                    final RegExp regex = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                    if (!regex.hasMatch(value)) {
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
                  userEmail = value;
                },
              ),
              const SizedBox(height: 20,),
              /*Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notification',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sales',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),),
                        Switch(
                          value:_isSelected ,
                          onChanged: (arg){},
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('New arrivals',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        Switch(
                          value:_isSelected ,
                          onChanged: (arg){},
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Status Changes',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        Switch(
                          value:_isSelected ,
                          onChanged: (arg){},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                  ],
                ),*/
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your account',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
                  const SizedBox(height: 20.0,),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    label: const Text('DELETE ACCOUNT', style: TextStyle(color: Colors.black),),
                    icon: const Icon(Icons.delete_outline_outlined, color: Colors.black,),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete account', style: TextStyle(color: Colors.red),),
                              content: const Text('Are you sure you want to delete your account?'),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Map<String, dynamic> arrPassData = {
                                      'id': global.isUserData['ID'],
                                      'force': 'true',
                                      'reassign': 1.toString()
                                    };
                                    appSettingsController.userAccountDelete(arrPostData: arrPassData);
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0,),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                label: const Text('LOGOUT', style: TextStyle(color: Colors.black),),
                icon: const Icon(Icons.logout, color: Colors.black,),
                onPressed: () {
                  showLogoutSnackBar('Are you sure you want to logout?', 'error');
                },
              )
            ],
          ),
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

  showLogoutSnackBar(String value, String status) {
    Get.showSnackbar(
      GetSnackBar(
        message: value,
        borderRadius: 20,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(15),
        backgroundColor: status == "Success" ? Colors.green : Colors.red,
        icon: const Icon(Icons.logout),
        mainButton: TextButton(
          child: const Text('Ok', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          onPressed: () async {
            appSettingsController.isLoading.value = true;
            await appSettingsController.storeUserDetails();
            Timer(const Duration(seconds: 3), () {
              appSettingsController.isLoading.value = false;
              Get.offAllNamed(LoginView.route);
            });
          },
        ),
      ),
    );
  }
}