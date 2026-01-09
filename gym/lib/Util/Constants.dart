import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class Constants {
  static const key = 'fitness-splash';
  static const Color lightBlue = Colors.lightBlue;
  static Color? lightBlueShade50 = Colors.lightBlue[50];

  static Color? submitButtonColor = Colors.lightBlue[900];

  static BoxDecoration submitButtonDecoration = BoxDecoration(
      color: Colors.lightBlue[900],
      border: Border.all(),
      borderRadius: BorderRadius.circular(40.0));

  //Shared Prefs keys

  static const String faUUID = 'fa_uuid';
  static const String faFullName = 'fa_full_name';
  static const String faEmail = 'fa_email';
  static const String faPhone = 'fa_phone';
  static const String faPassword = 'fa_password';
  static const String faEmailVerified = 'fa_email_verified';
  static const String faIdToken = 'fa_id_token';
  static const String faAccessToken = 'fa_access_token';
  static const String faIsGoogleSignedIn = 'fa_is_google_signed_in';

  static const String faStoredNotificationIdKey = 'fa_stored_notification_id';
  static const String faStoredNotificationMapKey = 'fa_stored_notification_map';

  static String storageUrl =
      "https://console.firebase.google.com/project/thatsendfitness/storage/thatsendfitness.appspot.com";

  // static String loaderUrl = "https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc";
  static String loaderUrl = "https://firebasestorage.googleapis.com/v0/b/gymifit-6c753.appspot.com/o/public%2Floader3.gif?alt=media&token=af463632-0fc6-4575-9a6c-b31069451238";

  static String loaderUrl2 = "https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa";

  static String noImg = "https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Fnoimage.png?alt=media&token=f7735c3b-5219-445e-b843-a54b32d2baec";



  static String getCurrentDate() {
    DateTime dateTime = DateTime.now();
    DateFormat format = DateFormat("yyyy-MM-dd");
    String currentDate = format.format(dateTime).toString();
    return currentDate;
  }

  static String getCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat format = DateFormat("hh:mm");
    String currentTime = format.format(dateTime).toString();
    return currentTime;
  }

  static Map<dynamic, dynamic> getCurrentExerciseSpentTime(
      {required String time}) {
    List<String> data = time.split(":");

    if (data.length < 2) {
      return {'m': data[0], 's': '0'};
    }
    return {'m': data[0], 's': data[1]};
  }

  static Widget BodyInfoContainer(
      {required context,
      required dynamic image,
      required String title,
      required String duration,
      required String kal,
      required String level,
      required String description,
      required dynamic decoration,
      required dynamic equipments,
      required dynamic type,
      // required dynamic equipmentCarousel,
      required dynamic onTap,
      bool isSelected = false}) {
    return Container(
      //margin: EdgeInsets.only(top: 50),
      margin: EdgeInsets.only(
          top: (Platform.isIOS)
              ? kToolbarHeight + kTextTabBarHeight - 8
              : kTextTabBarHeight - 8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          //margin: EdgeInsets.only(top:kToolbarHeight-10),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.70,
                //color: Colors.black12,
                child: FutureBuilder(
                  future: image,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                      child: FancyShimmerImage(
                        shimmerBaseColor: Colors.white,
                        shimmerHighlightColor: Colors.grey[300],
                        shimmerBackColor: Colors.black.withBlue(1),
                        imageUrl: snapshot.data != null && snapshot.data != ''
                            ? snapshot.data!
                            : Constants.loaderUrl,
                        errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                        width: double.maxFinite,
                        boxFit: BoxFit.cover,
                      ),
                    );
                  },
                  initialData: Constants.loaderUrl,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 25.0, left: 20, right: 20.0, bottom: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text(
                            description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 75,
                            width: MediaQuery.of(context).size.height * 0.13,
                            padding: EdgeInsets.all(7.0),
                            decoration: decoration,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/watch.png',
                                  width: 35,
                                  height: 35,
                                ),
                                Text(
                                  duration,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 75,
                            width: MediaQuery.of(context).size.height * 0.13,
                            padding: EdgeInsets.all(7.0),
                            decoration: decoration,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/kal.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Text("${kal} kal")
                              ],
                            ),
                          ),
                          Container(
                            height: 75,
                            width: MediaQuery.of(context).size.height * 0.13,
                            padding: EdgeInsets.all(7.0),
                            decoration: decoration,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/levels-removebg-preview.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Text(
                                  level,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 15.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       const Expanded(
                    //         child: Text(
                    //           'Equipment',
                    //           style: TextStyle(
                    //               fontSize: 16.0,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       Text('${equipments.length} item(s)')
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5),
                    //   child: EquipmentCarousel(equipments: equipmentCarousel),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.11),
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0)),
                  padding: EdgeInsets.only(
                      top: 5.0, left: 20, right: 20.0, bottom: 5.0),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        onTap: () {},
                        contentPadding: EdgeInsets.zero,
                        isThreeLine: false,
                        title: Text('Equipments'),
                        trailing: Text(equipments),
                        // tileColor: Colors.white,
                      ),
                      Divider(),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        onTap: () {},
                        contentPadding: EdgeInsets.zero,
                        title: Text('Focus Area'),
                        trailing: Text(type),
                        // tileColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget BottomContainer({
    required context,
    required dynamic onTap,
    required String title,
  }) {
    return Container(
      // margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 30.0,
      height: 45.0,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        // color: Colors.blue.shade900,
        // border: Border.all(),
        // borderRadius: BorderRadius.circular(40.0)
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: kToolbarHeight,
          width: double.infinity,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  static Widget HeaderContainer({
    required context,
    required String title,
    required dynamic backIcon,
    required dynamic favIcon,
    required dynamic favOnPressed,
    required dynamic backOnPressed,
  }) {
    return Container(
      //margin: EdgeInsets.only(top: kTextTabBarHeight),
      //import 'dart:io' show Platform;
      height: (Platform.isIOS)
          ? kToolbarHeight + kTextTabBarHeight + 15
          : kToolbarHeight + 15,
      decoration: BoxDecoration(
          color: Colors.blueAccent[100],
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: backIcon,
            onPressed: backOnPressed,
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.0),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          /*Center(
                    heightFactor: 2,
                    child: Text(
                      widget.exercise.es_name,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),*/
          IconButton(
            icon: favIcon,
            onPressed: favOnPressed,
          )
        ],
      ),
    );
  }
}
