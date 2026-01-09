import '../local/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/HomeScreen.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/UserMaster.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/AnalyticsUtils.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'SignInScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const route = 'splash';

  // static const route = '/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController pageController = PageController();

  int currentPage = 0;

  bool flag = false;
  UserMaster? userMaster;
  UserRepository userRepository = UserRepository();

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var singleUser = await userRepository.getUserFromId(uid: user.uid);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // context.loaderOverlay.hide();
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
      if (singleUser != false) {
        setState(() {
          userMaster = singleUser;
        });
      }
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
    Future.delayed(Duration(microseconds: 3000), () async {
      if (userMaster != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.route, (route) => false);
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        // String homeRoute = SplashScreen.route;
        if (sharedPreferences.containsKey(Constants.key)) {
          Navigator.pushNamedAndRemoveUntil(
              context, SignInScreen.route, (route) => false);
        }
        setState(() {
          isLoading = false;
        });
      }
    },);
   /* loadUser().then((value) async {
      if (userMaster != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.route, (route) => false);
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        // String homeRoute = SplashScreen.route;
        if (sharedPreferences.containsKey(Constants.key)) {
          Navigator.pushNamedAndRemoveUntil(
              context, SignInScreen.route, (route) => false);
        }
        setState(() {
          isLoading = false;
        });
      }
      // if (context.loaderOverlay.visible) {
      //   context.loaderOverlay.hide();
      // }
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.read<AnalyticsUtils>().setTrackingScreen("splash");

    return isLoading
        ? Scaffold(
            // backgroundColor: Colors.white,
            body: LoaderOverlay(
              disableBackButton: true,
              overlayWholeScreen: true,
              useDefaultLoading: false,
              overlayColor: Colors.blue[50],
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(Constants.loaderUrl),
                ),
              ),
            ),
          )
        : LoaderOverlay(
            disableBackButton: true,
            overlayWholeScreen: true,
            useDefaultLoading: false,
            overlayColor: Colors.red[50],
            overlayWidget: Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(Constants.loaderUrl))),
            child: Scaffold(
                // backgroundColor: Colors.purple[300],
                body: PageView(
              onPageChanged: (pageIndex) {
                setState(() {
                  currentPage = pageIndex;
                });
              },
              controller: pageController,
              children: [
                getPage1(
                    image: isLoading
                        ? "assets/images/loader3-unscreen.gif"
                        : 'assets/images/ic_launcher.png',
                    buttonText: "${getTranslated(context, "get_started")}",
                    heading: '${getTranslated(context, 'welcome_to_gymiFit')}',
                    text:
                        '${getTranslated(context, 'gymiFit_workouts_demand_find_based_how_much_time_you_have')}',
                    indicatorNo: 0),
                getPage1(
                    image: isLoading
                        ? "assets/images/loader3-unscreen.gif"
                        : 'assets/images/intopage1.jpg',
                    buttonText: '${getTranslated(context, 'next')}',
                    heading:
                        '${getTranslated(context, 'workouts')} ${getTranslated(context, 'categories')}',
                    text:
                        '${getTranslated(context, 'workout_categories_help_you_gain_strength_get_better_shape_lifestyle')}',
                    indicatorNo: 1),
                getPage1(
                    image: isLoading
                        ? "assets/images/loader3-unscreen.gif"
                        : 'assets/images/intropage3.jpg',
                    buttonText: 'Done',
                    heading:
                        '${getTranslated(context, 'custom')} ${getTranslated(context, 'workouts')}',
                    text:
                        "${getTranslated(context, 'create_save_custom_workouts')}",
                    indicatorNo: 2),
              ],
            )),
          );
  }

  Widget getPage(
      {required String heading,
      required String image,
      required String text,
      required int indicatorNo,
      required String buttonText}) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Positioned(
          top: -10,
          right: 0,
          left: 0,
          child: SizedBox(
              // alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 1.8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, style: BorderStyle.solid, width: 1.0),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                            child: Text(
                          heading,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                          ),
                          maxLines: 2,
                        )),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 55.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 55.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getPageIndicatorContainer(isActive: (currentPage == 0)),
                        getPageIndicatorContainer(isActive: (currentPage == 1)),
                        getPageIndicatorContainer(isActive: (currentPage == 2)),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: InkWell(
                        onTap: () async {
                          if (indicatorNo == 2) {
                            SharedPreferences share =
                                await SharedPreferences.getInstance();
                            share.setString(Constants.key, 'fitness-splash');
                            Navigator.pushNamed(context, SignInScreen.route);
                            // Navigator.pushNamed(context, ProfileSetup.route);
                          } else {
                            pageController.animateToPage((indicatorNo + 1),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.fastLinearToSlowEaseIn);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[900],
                              border: Border.all(color: Colors.blue.shade50),
                              borderRadius: BorderRadius.circular(40.0)),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget getPage1(
      {required String heading,
      required String image,
      required String text,
      required int indicatorNo,
      required String buttonText}) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ElevatedButton(
              child: Text(
                  buttonText.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[900],
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.all(15) //content padding inside button
              ),
              onPressed: () async {
                if (indicatorNo == 2) {
                  SharedPreferences share = await SharedPreferences.getInstance();
                  share.setString(Constants.key, 'fitness-splash');
                  Navigator.pushNamed(context, SignInScreen.route);
                  // Navigator.pushNamed(context, ProfileSetup.route);
                } else {
                  pageController.animateToPage((indicatorNo + 1),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.fastLinearToSlowEaseIn);
                }
              }
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(image)),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                          child: Text(
                        heading,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                        ),
                        maxLines: 2,
                      )),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                          child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      )),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getPageIndicatorContainer(isActive: (currentPage == 0)),
                      getPageIndicatorContainer(isActive: (currentPage == 1)),
                      getPageIndicatorContainer(isActive: (currentPage == 2)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getPageIndicatorContainer({bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
            color: isActive ? Colors.orange : Colors.grey[350],
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
                color: isActive ? Colors.orange : Colors.grey, width: 1.0)),
        height: 12.0,
        width: 12.0,
      ),
    );
  }
}

/*
Widget getPage1() {
  return Stack(
    children: [
      Container(
        color: Colors.lightBlueAccent,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: Center(
                          child: Text(
                            'Welcome to FitZone',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                            maxLines: 2,
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 55.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Center(
                            child: Text(
                              'FitooZone has workouts on demand that you can find based on how much time you have',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 55.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getPageIndicatorContainer(isActive: true),
                      getPageIndicatorContainer(),
                      getPageIndicatorContainer(),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: InkWell(
                      onTap: () {
                        pageController.animateToPage(1,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastLinearToSlowEaseIn);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Already have account?',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                            letterSpacing: 0.5),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        ' Sign In',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            letterSpacing: 0.5),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ],
  );
}

Widget getPage2() {
  return Stack(
    children: [
      Container(
        color: Colors.lightBlueAccent,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: Center(
                          child: Text(
                            'Workout Categories',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                            maxLines: 2,
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 55.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Center(
                            child: Text(
                              'Workout categories will help you to gain strength, get in better shape and embrace a healthy lifestyle',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 55.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getPageIndicatorContainer(),
                      getPageIndicatorContainer(isActive: true),
                      getPageIndicatorContainer(),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: InkWell(
                      onTap: () {
                        pageController.animateToPage(0,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastLinearToSlowEaseIn);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: const Text(
                          'Start Training',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      )
    ],
  );
}*/
