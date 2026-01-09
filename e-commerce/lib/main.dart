import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'presentation/internet_connectivity_module/binding/internet_connectivity_binding.dart';
import 'utils/app_route.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeData,
            //Initiate Bindings we have created with GETX
            initialBinding: InternetConnectivityBinding(),
            initialRoute: '/',
            routes: routes,
          );
  }
}
