import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'app/core/api_master.dart';
import 'app/core/db_helper.dart';
import 'app/loader.dart';
import 'app/no_connection.dart';
import 'app/search.dart';
import 'app/layout.dart';
import 'app/layout/spscreen/spscreen.dart';
import 'app/layout/listing/filter.dart';
import 'app/core/global.dart' as global;
import 'app/core/themedata.dart';
import 'app/core/constant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<MyHomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isLoading = false;
  CThemeData objCTD = CThemeData();
  DbHelper objDBH = DbHelper();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Could\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      // Set realtime connection status in global to check everywhere regarding network connectivity.
      global.connectionStatus = result;
    });
  }

  Future<void> getConfig() async {
    if (global.connectionStatus != ConnectivityResult.none) {
      print(cnfAPI_URL);
      // Set config in global so we can access it in whole app.
      global.mapConfige = await APIMaster().makeGetRqst(cnfAPI_URL);

      //global.mapConfige['url_api_domain'] = 'https://www.realstoria.thatsend.net';
      print('CONFIG+++++++');
      print(global.mapConfige);
      print(global.mapConfige['url_api_domain']);
    }

    // If config are not blank then do further process other wise show loader.
    if (global.mapConfige.length > 0) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  getLocalConfig() async {
    var data = await objDBH.getLocalStorageData();
    global.localCnf = data;
  }

  @override
  Widget build(BuildContext context) {
    // Get local config
    if (global.localCnf.length == 0) {
      getLocalConfig();
    }

    // Retry config till not getting
    if (global.mapConfige.length == 0) {
      getConfig();
    }
    // Setup theme data
    objCTD.getTheme(global.mapConfige);

    return (_isLoading)
        ? IconImage()
        : MaterialApp(
            theme: objCTD.appThemeData,
            debugShowCheckedModeBanner: false,
            initialRoute: (global.connectionStatus != ConnectivityResult.none)
                ? (global.localCnf.containsKey('enable_splash') == true &&
                        global.localCnf['enable_splash'] == '2')
                    ? '/'
                    : '/splash'
                : '/no-connection',
            routes: {
              // When navigating to the "/" route, build the FirstScreen widget.
              '/': (context) => LayoutScreen(),
              '/splash': (context) => SplashScreen(),
              '/filter': (context) => FilterScreen(),
              '/search': (context) => Searching(),
              '/no-connection': (context) => NoInternetConnection(),
            },
          );
  }
}
