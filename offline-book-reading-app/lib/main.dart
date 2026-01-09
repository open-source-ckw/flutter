import 'package:book_reader_app/core/colors.dart';
import 'package:book_reader_app/presentation/splash_screen.dart';
import 'package:book_reader_app/provider/bottombar_provider.dart';
import 'package:book_reader_app/provider/font_size_provider.dart';
import 'package:book_reader_app/provider/image_slider_provider.dart';
import 'package:book_reader_app/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/new_database_helper.dart';
import 'models/new_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([ImageModelSchema, SectionSchema, TopicSchema, ContentSchema], directory: dir.path);

  // Insert topics if not already inserted
  await insertSectionsAndTopics(isar);

  // Insert Images for slider
  await insertImages(isar);

  runApp(MyApp(isar: isar,));
}

class MyApp extends StatelessWidget {
  final Isar isar;

  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()..initializeApp()),
        ChangeNotifierProvider(create: (_) => BottomBarProvider(),),
        ChangeNotifierProvider(create: (_) => FontSizeProvider(),),
        ChangeNotifierProvider(create: (_) => ImageProviderData(isar),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'देवपूजा',
        theme: ThemeData(
          scaffoldBackgroundColor: secondaryColor,
          appBarTheme: AppBarTheme(
            foregroundColor: appWhite,
            backgroundColor: primaryColor,),
          textTheme: TextTheme(
            bodyMedium: TextStyle(
              color: appWhite
            )
          ),
          useMaterial3: true,
        ),
        home: SplashScreen(isar: isar,),
      ),
    );
  }
}
