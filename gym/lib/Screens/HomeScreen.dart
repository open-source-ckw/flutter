// ignore_for_file: prefer_const_constructors

//import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Colors.dart';

import '../Provider/BannerWorkoutsProvider.dart';
import '../Provider/CategoriesProvider.dart';
import '../Provider/ExerciseProvider.dart';
import '../Provider/ThemeProvider.dart';
import '../Provider/TrainingProvider.dart';
import '../Provider/WorkoutsProvider.dart';
import '../local/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../Screens/_SearchScreen.dart';
import '../Screens/all_workouts.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/Notification/NotificationController.dart';
import '../firebase/Storage/StorageHandler.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../Components/CategoryCarousal.dart';
import '../Components/ExerciseList.dart';
import '../Components/PopularWorkouts.dart';
import '../Components/TopCarousalControl.dart';
import '../Provider/AnalyticsUtils.dart';
import '../firebase/DB/Models/UserMaster.dart';
import 'ActivityScreen.dart';
import 'AllCategories.dart';
import 'AllExercises.dart';
import 'NotificationScreen.dart';
import 'ProfileScreen.dart';
import 'SearchScreen.dart';
import 'TrainingScreen.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // static const route = '/';
  static const route = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentBottomBarIndex = 0;

  TabController? tabController;

  List tabs = [];

  UserMaster? user;
  UserRepository userRepository = UserRepository();

  // NotificationController notificationController = NotificationController();
  late ExercisesProvider exercisesProvider;
  late WorkoutsProvider workoutsProvider;
  late BannerWorkoutsProvider bannerWorkoutsProvider;
  late CategoriesProvider categoriesProvider;
  late TrainingProvider trainingProvider;
  late ThemeProvider themeProvider;

  dynamic category;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    loadUser();
    trainingProvider = Provider.of<TrainingProvider>(context, listen: false);
    loadTrainings();
    categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    loadCategories();
    exercisesProvider = Provider.of<ExercisesProvider>(context, listen: false);
    loadExercises();
    workoutsProvider = Provider.of<WorkoutsProvider>(context, listen: false);
    loadWorkouts();
    bannerWorkoutsProvider =
        Provider.of<BannerWorkoutsProvider>(context, listen: false);
    loadTonningWorkouts();
    // exerc();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.loaderOverlay.show();
      }
    });
    //loadAds();
  }

  Future<void> loadUser() async {
    // context.loaderOverlay.show();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      UserMaster userMaster = await userRepository.getUserFromId(uid: user.uid);
      print('userMaster');
      print(userMaster);
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
      setState(() {
        this.user = userMaster;
      });
    }
  }

  Future<void> loadTrainings() async {
    await trainingProvider.allTrainingsProvider();
  }

  Future<void> loadTonningWorkouts() async {
    await bannerWorkoutsProvider.allToningWorkoutsProvider();
  }

  Future<void> loadCategories() async {
    await categoriesProvider.allCategoriesProvider();
  }

  Future<void> loadExercises() async {
    await exercisesProvider.resentExercisesProvider();
    // setState(() {});
  }

  Future<void> loadWorkouts() async {
    await workoutsProvider.allWorkoutsProvider();
  }

  dynamic _rewardedAd;

  //
  var adId = Platform.isIOS
      ? "ca-app-pub-7593009526670874/9065910572"
      : "ca-app-pub-7593009526670874/7783457377";

  /*void loadAds(){
    RewardedInterstitialAd.load(

        adUnitId: adId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {

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

  StorageHandler storageHandler = StorageHandler();

  @override
  Widget build(BuildContext context) {

    /*if(_rewardedAd!=null){
      _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      });
    }*/

    //context.read<AnalyticsUtils>().setTrackingScreen("home");
    exercisesProvider = Provider.of<ExercisesProvider>(context, listen: false);
    workoutsProvider = Provider.of<WorkoutsProvider>(context, listen: false);
    bannerWorkoutsProvider =
        Provider.of<BannerWorkoutsProvider>(context, listen: false);
    categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    trainingProvider = Provider.of<TrainingProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    tabs = [
      Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            '${getTranslated(context, 'hi')}, ${user != null ? user!.um_name.toString() : ''}',
            style: TextStyle(
                color: Theme.of(context).textTheme.headline5!.color),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(7.0)),
              child: IconButton(onPressed: (){
                Navigator.pushNamed(context, SearchScreen.route);
                }, icon: Icon(Icons.search,
                  // color: Colors.blue.shade900,
                  color: Theme.of(context).disabledColor),
              ),
            ),
            SizedBox(width: 10,),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(7.0)),
              child: IconButton(
                onPressed: (){
                Navigator.pushNamed(context, NotificationScreen.route);
                }, icon: Icon(Icons.notifications_none_outlined,
                  // color: Colors.blue.shade900,
                  color: Theme.of(context).disabledColor),
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Consumer<BannerWorkoutsProvider>(
                  builder: (context, provider, child) {
                      return TopCarousalControl(
                      toningWorkout: provider.toningWorkouts);
                }),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 10.0, left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${getTranslated(context, 'categories')}',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AllCategories.route,
                                arguments: categoriesProvider.categories);
                          },
                          child: Text('${getTranslated(context, 'view_all')}',
                              style:
                                  TextStyle(fontSize: 12, letterSpacing: 1.2)))
                    ],
                  ),
                ),
                Consumer<CategoriesProvider>(
                    builder: (context, provider, child) {
                      return CategoryCarosal(data: categoriesProvider.categories);
                }),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 10.0, left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${getTranslated(context, 'workouts')}',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AllWorkout.route,
                            );
                          },
                          child: Text('${getTranslated(context, 'view_all')}',
                              style:
                                  TextStyle(fontSize: 12, letterSpacing: 1.2)))
                    ],
                  ),
                ),
                Consumer<WorkoutsProvider>(
                    builder: (context, provider, child) {
                      return PopularWorkouts(workouts: workoutsProvider.workouts);
                }),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 10.0, left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${getTranslated(context, 'exercises')}',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AllExercises.route);
                          },
                          child: Text('${getTranslated(context, 'view_all')}',
                              style:
                                  TextStyle(fontSize: 12, letterSpacing: 1.2),
                          ),
                      )
                    ],
                  ),
                ),
                Consumer<ExercisesProvider>(
                    builder: (context, provider, child) {
                      return ExerciseList(exercises: exercisesProvider.exercises);
                }),
              ],
            ),
          ),
        ),
      ),
      TrainingScreen(
        trainings: trainingProvider.trainings,
      ),
      ActivityScreen(trainings: trainingProvider.trainings),
      ProfileScreen()
    ];
    // tabController = TabController(length: 4, vsync: this);
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: Scaffold(
        // backgroundColor: Theme.of(context).backgroundColor,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   title: Padding(
        //     padding: const EdgeInsets.only(left: 10, right: 10),
        //     child: Column(
        //       children: [
        //         Row(
        //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Expanded(
        //               child: Text(
        //                 'Hi, ${user != null ? user!.um_name.toString() : ''}',
        //                 style: TextStyle(
        //                     fontSize: 20.0,
        //                     letterSpacing: 1.5,
        //                     fontWeight: FontWeight.bold),
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 Navigator.pushNamed(context, SearchScreen.route);
        //               },
        //               child: Container(
        //                 padding: EdgeInsets.all(2.0),
        //                 margin: EdgeInsets.only(right: 10),
        //                 decoration: BoxDecoration(
        //                     border: Border.all(color: Colors.grey),
        //                     borderRadius: BorderRadius.circular(7.0)),
        //                 child: Icon(
        //                   Icons.search,
        //                   color: Colors.blue.shade900,
        //                 ),
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 Navigator.pushNamed(context, NotificationScreen.route);
        //               },
        //               child: Container(
        //                 padding: EdgeInsets.all(2.0),
        //                 decoration: BoxDecoration(
        //                     border: Border.all(color: Colors.grey),
        //                     borderRadius: BorderRadius.circular(7.0)),
        //                 child: Icon(
        //                   Icons.notifications_none_outlined,
        //                   color: Colors.blue.shade900,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //
        //       ],
        //     ),
        //   ),
        // ),
        body: tabs[currentBottomBarIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentBottomBarIndex,
          elevation: 10.0,
          selectedItemColor: Theme.of(context).disabledColor.withOpacity(0.7),
          unselectedItemColor: Theme.of(context).disabledColor,
          type: BottomNavigationBarType.shifting,
          backgroundColor: Theme.of(context).disabledColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '${getTranslated(context, 'home')}',
              backgroundColor:
                  themeProvider.isDarkMode ? Colors.black : Colors.white,
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.dumbbell),
              label: '${getTranslated(context, 'training')}',
              // backgroundColor: Colors.blue.shade900
              backgroundColor:
                  themeProvider.isDarkMode ? Colors.black : Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.blur_circular_rounded),
              label: '${getTranslated(context, 'activity')}',
              // backgroundColor: Colors.blue.shade900
              backgroundColor:
                  themeProvider.isDarkMode ? Colors.black : Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_sharp),
              label: '${getTranslated(context, 'profile')}',
              backgroundColor:
                  themeProvider.isDarkMode ? Colors.black : Colors.white,

              // backgroundColor: Colors.blue.shade900
            ),
          ],
          onTap: (index) {
            if (index != currentBottomBarIndex) {
              setState(() {
                currentBottomBarIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

  String getToStringForUser(Categories userCa) {
    String output = '';
    output = '$output ${userCa.cs_name}';
    return output.toLowerCase();
  }
}
