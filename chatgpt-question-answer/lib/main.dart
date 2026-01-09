import 'package:chat_gtp/firebasse_options.dart';
import 'package:chat_gtp/providers/ThemeProvider.dart';
import 'package:chat_gtp/providers/list_chats_provider.dart';

import 'package:chat_gtp/providers/models_provider.dart';
import 'package:chat_gtp/providers/save_chat_provider.dart';

import 'package:chat_gtp/screens/Splash_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Chats/chats.dart';
import 'constants/apple_services.dart';
import 'constants/apple_signin_available.dart';
import 'constants/constants.dart';
import 'providers/chats_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SharedPreferences pre = await SharedPreferences.getInstance();
  // String create = "";
  // pre.setString("createDB", create);

  // String? getData = pre.getString("create");

  // if (getData != "") {
  //   MyDb db = MyDb();
  //
  //   var d = db.open();
  //   pre.setString("getDB", d.toString());
  // }
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (_) => ModelsProvider(),
  //       ),
  //       ChangeNotifierProvider(
  //         create: (_) => ChatProvider(),
  //       ),
  //       ChangeNotifierProvider(
  //         create: (_) => AllChatProvider(),
  //       ),
  //       ChangeNotifierProvider(
  //         create: (_) => SaveChatProvider(),
  //       ),
  //       Provider<AuthService>(create: (_) => AuthService(),
  //       )
  //     ],
  //     child: MaterialApp(
  //       title: 'Talk AI',
  //       debugShowCheckedModeBanner: false,
  //       theme: ThemeData(
  //           scaffoldBackgroundColor: scaffoldBackgroundColor,
  //           primaryColor: appPrimaryColor,
  //           appBarTheme: AppBarTheme(
  //             color: appPrimaryColor,
  //           )),
  //       home: const SplashScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ModelsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ChatProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => AllChatProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => SaveChatProvider(),
            ),
            Provider<AuthService>(
              create: (_) => AuthService(),
            )
          ],
          child: MaterialApp(
            title: 'Talk AI',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: scaffoldBackgroundColor,
                primaryColor: appPrimaryColor,
                appBarTheme: AppBarTheme(
                  color: appPrimaryColor,
                )),
            home: const SplashScreen(),
          ),
        );
      }
      // },
      );
}
