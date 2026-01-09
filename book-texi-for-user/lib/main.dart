import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/controller/global_setting_conroller.dart';
import 'package:customer/firebase_options.dart';
import 'package:customer/services/localization_service.dart';
import 'package:customer/themes/Styles.dart';
import 'package:customer/ui/splash_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


import 'utils/Preferences.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // // make navigation bar transparent
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.transparent,
  //   ),
  // );
  // // make flutter draw behind navigation bar
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);


  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Preferences.initPref();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {


  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkTheme;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    //     systemNavigationBarColor: Colors.red.withOpacity(0.0),
    //     statusBarBrightness: Brightness.light,
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //     systemNavigationBarContrastEnforced: true,
    //     systemStatusBarContrastEnforced: false,
    //     systemNavigationBarDividerColor: Colors.transparent,
    //   systemNavigationBarIconBrightness: Brightness.light,
    // );
    // SystemChrome.setSystemUIOverlayStyle(
    //     systemUiOverlayStyle,
    //
    //
    // );
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(builder: (context, value, child) {
        return GetMaterialApp(
            title: 'WayFinder',
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(
                themeChangeProvider.darkTheme == 0
                    ? true
                    : themeChangeProvider.darkTheme == 1
                        ? false
                        : themeChangeProvider.getSystemThem(),
                context),
            localizationsDelegates: const [
              CountryLocalizations.delegate,
            ],
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.locale,
            translations: LocalizationService(),
            builder: EasyLoading.init(),
            home: GetBuilder<GlobalSettingController>(
                init: GlobalSettingController(),
                builder: (context) {
                  return const SplashScreen();
                },
            ),
        );
      },
      ),
    );
  }
}