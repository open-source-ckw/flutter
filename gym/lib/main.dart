//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:screen_protector/screen_protector.dart';

import '../Provider/BannerWorkoutsProvider.dart';
import '../Provider/CategoriesProvider.dart';
import '../Provider/ExerciseProvider.dart';
import '../Provider/ReminderWorkoutProvider.dart';
import '../Provider/TrainingProvider.dart';
import '../Provider/WorkoutsProvider.dart';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Screens/AccountInfoScreen.dart';
import '../Screens/AllCategories.dart';
import '../Screens/AllExercises.dart';
import '../Screens/CreateWorkoutReminder.dart';
import '../Screens/HomeScreen.dart';
import '../Screens/MyWorkoutsScreen.dart';
import '../Screens/NotificationScreen.dart';
import '../Screens/PlanScreen.dart';
import '../Screens/ProfileSetup.dart';
import '../Screens/ProgessScreen.dart';
import '../Screens/ScheduledWorkoutScreen.dart';

import '../Screens/SignInScreen.dart';
import '../Screens/SignUpScreen.dart';
import '../Screens/SummaryScreen.dart';
import '../Screens/WorkOutReminderScreen.dart';

import '../Screens/all_workouts.dart';
import '../Screens/ForgotPassword.dart';

// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'Colors.dart';
import 'Provider/AnalyticsUtils.dart';
import 'Provider/ThemeProvider.dart';
import 'Screens/SearchScreen.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/SplashScreen1.dart';
import 'firebase/Aurthentication/AppleServices.dart';
import 'firebase/Aurthentication/AppleSigninAvailable.dart';
import 'firebase/Notification/NotificationController.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'local/localization/demo_localization.dart';
import 'local/localization/language_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
    Permission.storage,
    Permission.camera,
    // Permission.location,
    Permission.activityRecognition,
    // Permission.microphone
  ].request();*/

  //MobileAds.instance.initialize();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
          name: "GymiFit"
  );

  // await FlutterWindowManager.addFlags(
  //     FlutterWindowManager.FLAG_SECURE);
  // await ScreenProtector.preventScreenshotOn();

  // NotificationController.requestPermission();
  // NotificationController.initialize();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyApp(),
  ));
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // static GlobalKey mtAppKey = GlobalKey();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // DarkThemeProvider themeChangeProvider =  DarkThemeProvider();

  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    /// FOR IOS: It will used for when user login the app and user will un-installed the app after installed the fresh app.
    firstTimeInstalledRun();
    super.initState();
  }

  firstTimeInstalledRun() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      await FirebaseAuth.instance.signOut();
      prefs.setBool('first_run', false);
    }
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  /*static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);*/

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top]);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

          if (this._locale == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            );
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (context) => ExercisesProvider()),
                ChangeNotifierProvider(create: (context) => WorkoutsProvider()),
                ChangeNotifierProvider(
                    create: (context) => BannerWorkoutsProvider()),
                ChangeNotifierProvider(
                    create: (context) => CategoriesProvider()),
                ChangeNotifierProvider(create: (context) => TrainingProvider()),
                ChangeNotifierProvider(
                    create: (context) => ReminderWorkoutProvider()),
                // ChangeNotifierProvider(create: (context) => DarkThemeProvider()),

                /*Provider<AnalyticsUtils>(
                    create: (_) => AnalyticsUtils(analytics)),*/
                Provider<AuthService>(create: (_) => AuthService()),
              ],
              child: MaterialApp(
                /*navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],*/
                debugShowCheckedModeBanner: false,
                title: 'GymiFit',
                // theme: themeChangeProvider.darkTheme ? AppColors.themeDataDark(themeChangeProvider.darkTheme, context) : AppColors.themeDataWhite(context),
                theme: themeProvider.isDarkMode
                    ? MyThemes.darkTheme
                    : MyThemes.lightTheme,
                // darkTheme: MyThemes.darkTheme,
                themeMode: themeProvider.themeMode,
                initialRoute: SplashScreen1.route,
                routes: {
                  SplashScreen1.route: (context) => SplashScreen1(),
                  SplashScreen.route: (context) => const SplashScreen(),
                  SignInScreen.route: (context) => const SignInScreen(),
                  ForgetPassword.route: (context) => const ForgetPassword(),
                  SignUpScreen.route: (context) => const SignUpScreen(),
                  // PlanScreen.route: (context) => const PlanScreen(),
                  // PhoneVerification.route: (context) => const PhoneVerification(),
                  ProfileSetup.route: (context) => const ProfileSetup(),
                  HomeScreen.route: (context) => const HomeScreen(),
                  AllExercises.route: (context) => const AllExercises(),
                  AllCategories.route: (context) => const AllCategories(),
                  // PersonalTraining.route: (context) => PersonalTraining(),
                  // WarmUpScreen.route: (context) => const WarmUpScreen(),
                  AccountInfoScreen.route: (context) =>
                      const AccountInfoScreen(),
                  WorkOutReminderScreen.route: (context) =>
                      const WorkOutReminderScreen(),
                  // WeightTrackingScreen.route: (context) => const WeightTrackingScreen(),
                  // MusicProviderScreen.route: (context) => const MusicProviderScreen(),
                  NotificationScreen.route: (context) =>
                      const NotificationScreen(),
                  // FullBodyWorkoutScreen.route: (context) => const FullBodyWorkoutScreen(),
                  ProgressScreen.route: (context) => const ProgressScreen(),
                  SummaryScreen.route: (context) => const SummaryScreen(),
                  MyWorkoutsScreen.route: (context) => const MyWorkoutsScreen(),
                  // ExerciseInfoScreen.route:(context)=>const ExerciseInfoScreen(),
                  // WorkoutScreen.route:(context)=>const WorkoutScreen(),
                  AllWorkout.route: (context) => const AllWorkout(),
                  // CategoriesInfoScreen.route:(context)=> const CategoriesInfoScreen(),
                  ScheduledWorkoutScreen.route: (context) =>
                      const ScheduledWorkoutScreen(),
                  SearchScreen.route: (context) => const SearchScreen(),
                  CreateWorkOutReminder.route: (context) =>
                      const CreateWorkOutReminder(),
                },
                locale: _locale,
                supportedLocales: [
                  Locale("en", "US"),
                  Locale("gu", "IN"),
                  Locale("fr", "FR"),
                ],
                localizationsDelegates: [
                  DemoLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale!.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
              ),
            );
          }
        },
      );
}
