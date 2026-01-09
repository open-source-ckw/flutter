import 'package:flutter/material.dart';
import '../../core/db_helper.dart';
import '../../core/model_config.dart';
import '../../loader.dart';
import '../../core/global.dart' as global;

class SplashScreen extends StatefulWidget {
  const SplashScreen({key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Map<String, String>> lmSpData = [];
  int _curr = 0;
  PageController controller = PageController();
  bool _isLoading = true;
  DbHelper objDBH = DbHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    lmSpData = [
      {
        'image': global.mapConfige['img_splash_screen_1'],
        'text': global.mapConfige['img_splash_title_1'],
        'text1': global.mapConfige['img_splash_disc_1'],
        'txt': 'Get Started'
      },
      {
        'image': global.mapConfige['img_splash_screen_2'],
        'text': global.mapConfige['img_splash_title_2'],
        'text1': global.mapConfige['img_splash_disc_2'],
        'txt': 'Next'
      },
      {
        'image': global.mapConfige['img_splash_screen_3'],
        'text': global.mapConfige['img_splash_title_3'],
        'text1': global.mapConfige['img_splash_disc_3'],
        'txt': 'Done'
      },
    ];
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Loader()
            : Container(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: childWSP(lmSpData, _curr),
                  controller: controller,
                  onPageChanged: (num) {
                    setState(() {
                      _curr = num;
                    });
                  },
                ),
              ));
  }

  childWSP(data, active) {
    List<Widget> listWIntroS = <Widget>[];
    data.forEach((objSS) {
      listWIntroS.add(Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(objSS['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.black,
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
          ),
          _curr == data.length - 1
              ? Text('')
              : Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        child: Text(
                          'SKIP',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          navigateHomePage();
                        },
                      )),
                ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      objSS['text'] ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      objSS['text1'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed: () {
                        if (_curr == data.length - 1) {
                          navigateHomePage();
                        } else {
                          gotoNextPage();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(objSS['txt'],
                                style: TextStyle(
                                  color: Color(0xFF2a5537),
                                )),
                            Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: builtDot(data.length, active),
            ),
          )
        ],
      ));
    });

    return listWIntroS;
  }

  gotoNextPage() {
    controller.nextPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  navigateHomePage() {
    unableSpScreen();
    Navigator.pushReplacementNamed(context, '/');
  }

  unableSpScreen() {
    objDBH.insertConfig(Config('enable_splash', 2));
  }

  builtDot(int totalRec, int _curr) {
    List<Widget> listIndicator = <Widget>[];

    for (int i = 0; i < totalRec; i++) {
      listIndicator.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          height: 6,
          width: 28,
          decoration: BoxDecoration(
            color: _curr == i ? Color(0xFF3ee7b7) : Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );
    }

    return listIndicator;
  }
}
