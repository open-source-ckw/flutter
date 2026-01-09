// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import '../Provider/ThemeProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/ContactUs.dart';
import '../Screens/ScheduledWorkoutScreen.dart';
import '../Screens/SignInScreen.dart';
import '../firebase/Aurthentication/authentication.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/Storage/StorageHandler.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/Utils.dart';
import '../local/localization/language_constants.dart';
import '../main.dart';
import 'AccountInfoScreen.dart';
import 'MyWorkoutsScreen.dart';
import 'ProgessScreen.dart';
import 'WorkOutReminderScreen.dart';
import 'dart:io' show Platform;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StorageHandler storageHandler = StorageHandler();

  bool isPinLock = true;
  bool isAppleHealth = true;

  // late DarkThemeProvider themeProvider;
  // bool isDarkMode = false;
  int? _value = 1;

  bool english = true;
  var currentLanguage;

  void _changeLanguage(String lan) async {
    Locale _locale = await setLocale(lan);
    MyApp.setLocale(context, _locale);
  }

  Future<void> getLan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences=await SharedPreferences.getInstance();
    currentLanguage = preferences.getString('lan');

    // if(currentLanguage=='ko'){
    //   UtilsUrl.currentLanguage="kr";
    // }else{
    //   UtilsUrl.currentLanguage="en";
    // }

    if (currentLanguage == 'en') {
      UtilsUrl.currentLanguage = "en";
    } else {
      UtilsUrl.currentLanguage = "fr";
    }

    if (currentLanguage == "fr") {
      setState(() {
        english = false;
      });
    }
  }

  UserMaster? userMaster;
  UserRepository userRepository = UserRepository();

  // AuthenticationRepository authenticationRepository =
  //     AuthenticationRepository();

  int age = 0;

  Future<void> loadUser() async {
    context.loaderOverlay.show();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);

      if (userMaster!.um_dob != null && userMaster!.um_dob != "") {
        DateTime dob = DateTime.parse(userMaster!.um_dob);
        age = (DateTime.now().difference(dob).inDays ~/ 365).round();
      }

      // String dob =userMaster!.um_dob;
      // DateTime userDob = DateTime.parse(dob);
      // DateFormat format = DateFormat("d");
      // String age1 = format.format(userDob);

      // age = DateTime.now().difference(DateTime.parse(userDob)).inDays ~/ 365;
      // format.format(DateTime.parse(age));
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
      setState(() {});
    }
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    reference.onDisconnect();

    await FirebaseAuth.instance.signOut().then((value) async {
      await Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.route, (route) => false);
    });

    //setState(() {});
  }

  dynamic _rewardedAd;

  var adId = Platform.isIOS
      ? "ca-app-pub-7593009526670874/5398128307"
      : "ca-app-pub-7593009526670874/6823946539";

  /*void loadAds(){
    RewardedAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {

            // Keep a reference to the ad so you can show it later.
            setState((){
              _rewardedAd = ad;
            });

            _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) {},
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                ad.dispose();
              },
              onAdImpression: (RewardedAd ad) {},
            );


          },
          onAdFailedToLoad: (LoadAdError error) {
          },
        )


    );
  }*/

  @override
  void initState() {
    super.initState();

    loadUser();
    //loadAds();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (mounted) {
    //     context.loaderOverlay.show();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    /*if(_rewardedAd!=null){
      _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      });
    }*/

    // final themeProvider = Provider.of<DarkThemeProvider>(context);

    final themeProvider = Provider.of<ThemeProvider>(context);
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
            automaticallyImplyLeading: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            // backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
            title: Text(
              '${getTranslated(context, 'profile')}',
              textAlign: TextAlign.left,
              style: TextStyle(
                  // fontSize: 36,
                  color: Theme.of(context).textTheme.headline5!.color),
            ),
          ),
          body: userMaster == null
              ? Container()
              : SizedBox(
                  height: MediaQuery.of(context).size.height + kToolbarHeight,

                  // height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  userMaster!.um_image != ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: CachedNetworkImage(
                                            imageUrl: userMaster!.um_image,
                                            fit: BoxFit.cover,
                                            width: 95,
                                            height: 95,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.blue.shade900,
                                          minRadius: 40.0,
                                          child: Text(
                                            userMaster!.um_name.characters.first
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 50.0,
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.white
                                            ),
                                          ),
                                        )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 75.0,
                                width: 100.0,
                                padding: EdgeInsets.all(7.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.11),

                                  shape: BoxShape.rectangle,
                                  // border:
                                  //     Border.all(color: Colors.white)
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/images/weigth.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                    userMaster != null
                                        ? Text(
                                            '${userMaster!.um_weight} ${userMaster!.um_weightin}')
                                        : Text('0 Kg')
                                  ],
                                ),
                              ),
                              Container(
                                height: 75,
                                width: 100.0,
                                padding: EdgeInsets.all(7.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.11),

                                  shape: BoxShape.rectangle,
                                  // border:
                                  //     Border.all(color: Colors.white)
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/images/height.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                    userMaster != null
                                        ? Text(
                                            '${userMaster!.um_height} ${userMaster!.um_heightin}')
                                        : Text('0 cm'),
                                  ],
                                ),
                              ),
                              Container(
                                height: 75,
                                width: 100.0,
                                padding: EdgeInsets.all(7.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.11),
                                  shape: BoxShape.rectangle,
                                  // border:
                                  //     Border.all(color: Colors.white)
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/images/years.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                    age != null
                                        ? Text(
                                            '${age.round()} ${getTranslated(context, 'years')}')
                                        : Text('0 years'),
                                  ],
                                ),
                              )
                            ],
                          ),

                          /*Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 10.0, right: 10.0),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue[900],
                                border: Border.all(
                                    color: Colors.blue.shade500,
                                    width: 2),
                                borderRadius:
                                BorderRadius.circular(40.0)),
                            child: Text(
                              '${getTranslated(context, 'go_premium')}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),*/

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 10.0, right: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.11)),
                              child: Column(
                                children: [
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    )),
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AccountInfoScreen.route);
                                    },
                                    title: Text(
                                        '${getTranslated(context, 'account')}'),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      _showActionSheet(context);
                                    },
                                    title: Text(
                                      "${getTranslated(context, "language")}",
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MyWorkoutsScreen.route);
                                    },
                                    title: Text(
                                        '${getTranslated(context, 'my_workouts')}'),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          ScheduledWorkoutScreen.route);
                                    },
                                    title: Text(
                                        '${getTranslated(context, 'scheduled_workouts')}'),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, WorkOutReminderScreen.route);
                                    },
                                    title: Text(
                                        '${getTranslated(context, 'workout_reminders')}'),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ProgressScreen.route);
                                    },
                                    title: Text(
                                        '${getTranslated(context, 'summary')}'),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    )),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                content: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 150,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${getTranslated(context, 'are_sure_logout')}'),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              context
                                                                  .loaderOverlay
                                                                  .show();
                                                              logout();
                                                              if (context
                                                                  .loaderOverlay
                                                                  .visible) {
                                                                context
                                                                    .loaderOverlay
                                                                    .hide();
                                                              }

                                                              // await authenticationRepository.signOutWithGmailId(context);
                                                            },
                                                            // onPressed: () {
                                                            //   User? auth =
                                                            //       FirebaseAuth
                                                            //           .instance
                                                            //           .currentUser;
                                                            //
                                                            //   if (auth!
                                                            //       .providerData
                                                            //       .isEmpty) {
                                                            //     print(auth
                                                            //         .displayName);
                                                            //     logout();
                                                            //   } else {
                                                            //     print(auth
                                                            //         .email);
                                                            //
                                                            //     authenticationRepository
                                                            //         .signOutWithGmailId()
                                                            //         .then(
                                                            //             (value) {
                                                            //       Navigator.pushNamedAndRemoveUntil(
                                                            //           context,
                                                            //           SignInScreen
                                                            //               .route,
                                                            //           (route) =>
                                                            //               false);
                                                            //     });
                                                            //   }
                                                            // },
                                                            child: Text(
                                                                '${getTranslated(context, 'yes')}'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                                '${getTranslated(context, 'no')}'),
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
                                    title: Text(
                                        '${getTranslated(context, 'log_out')}'),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 15.0, right: 15.0),
                            child: Row(
                              children: [
                                Text(
                                  '${getTranslated(context, 'settings')}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 10.0, right: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // color: themeProvider.isDarkMode ? ThemeProvider.darkBoxColor : Colors.grey.shade200,
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.11)),
                              child: Column(
                                children: [
                                  // ListTile(
                                  //   onTap: () {},
                                  //   title: Text('Notification'),
                                  //   trailing: CupertinoSwitch(
                                  //       onChanged: (bool value) {
                                  //         setState(() {
                                  //           isPinLock = value;
                                  //         });
                                  //       },
                                  //       value: isPinLock,
                                  //       activeColor: Colors.blue.shade900),
                                  //   tileColor: Colors.white,
                                  // ),
                                  // ListTile(
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.only(
                                  //         topRight: Radius.circular(10),
                                  //         topLeft: Radius.circular(10),
                                  //       )
                                  //   ),
                                  //   onTap: () {},
                                  //   title: Text(
                                  //       '${getTranslated(context, 'preferences')}'),
                                  //   trailing: Icon(
                                  //     Icons.arrow_forward_ios,
                                  //     size: 15.0,
                                  //   ),
                                  //   // tileColor: Colors.white,
                                  // ),
                                  // ListTile(
                                  //   onTap: () {},
                                  //   title: Text(
                                  //       '${getTranslated(context, 'plan_settings')}'),
                                  //   trailing: Icon(
                                  //     Icons.arrow_forward_ios,
                                  //     size: 15.0,
                                  //   ),
                                  //   // tileColor: Colors.white,
                                  // ),
                                  // ListTile(
                                  //   onTap: (){},
                                  //   title: Text('Apple Health'),
                                  //   trailing: CupertinoSwitch(onChanged: (bool value) {
                                  //     setState((){
                                  //       isAppleHealth=value;
                                  //     });
                                  //   }, value: isAppleHealth,activeColor: Colors.blue.shade900,),
                                  //   tileColor: Colors.white,
                                  //
                                  // ),
                                  ListTile(
                                    onTap: () {},
                                    title: Text('Dark Mode'),
                                    trailing: CupertinoSwitch(
                                        value: themeProvider.isDarkMode,
                                        onChanged: (value) {
                                          final provider =
                                              Provider.of<ThemeProvider>(
                                                  context,
                                                  listen: false);
                                          provider.toggleTheme(value);
                                        },
                                        activeColor: Colors.blue.shade900),
                                    // tileColor: Colors.white,
                                  ),
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    )),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactUsScreen()));
                                    },
                                    title: Text(
                                        '${getTranslated(context, 'contact_support')}'),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                    ),
                                    // tileColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Language'),
        message: const Text('Select Your Favorite Language'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () async {
              var value;
              SharedPreferences pre = await SharedPreferences.getInstance();

              setState(() {
                _value = value as int?;
                english = true;
                pre.setString('lan', 'en');
                _changeLanguage('en');
                getLan();
                Navigator.pop(context);
              });
            },
            child: const Text('English'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              var value;
              SharedPreferences pre = await SharedPreferences.getInstance();

              setState(() {
                _value = value as int?;
                english = true;
                pre.setString('lan', 'fr');
                _changeLanguage('fr');
                getLan();
                Navigator.pop(context);
              });
            },
            child: const Text('français'),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
