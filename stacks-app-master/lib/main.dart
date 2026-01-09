import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stacks/routes/app_pages.dart';
import 'package:stacks/theme/app_theme.dart';
import 'package:stacks/view/auth/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initHiveForFlutter();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: 'Stacks',
      themeMode: ThemeMode.light,
      theme: themeData,
      initialRoute: Routes.INITIAL,
      home: Splash(),
      defaultTransition: Transition.cupertino,
      getPages: AppPages.pages,
      onReady: () async {},
    );
  }
}
