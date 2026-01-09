// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:math';

import '../Provider/ThemeProvider.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/ExerciseInfoScreen.dart';
import '../firebase/DB/Models/Banner.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/ScheduledWorkout.dart';
import '../firebase/DB/Models/Toning_Exercises.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Models/User_Fav.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/NotificationAlertRepository.dart';
import '../firebase/DB/Repo/ScheduledWorkoutRepository.dart';
import '../firebase/DB/Repo/Toning_ExercisesRepository.dart';
import '../firebase/DB/Repo/TonningWorkoutsRepository.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/User_FavRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/NotificationAlert.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../local/localization/language_constants.dart';
import 'CategoriesInfoScreen.dart';
import 'MusicProviderScreen.dart';
import 'RunningWorkoutScreen.dart';
import 'WorkoutsCategoriesInfo.dart';
import 'dart:io' show Platform;

class BannerWorkoutsScreen extends StatefulWidget {
  final TonningWorkoutsModel tonningWorkoutsModel;

  const BannerWorkoutsScreen({Key? key, required this.tonningWorkoutsModel})
      : super(key: key);

  static const String route = 'BannerWorkoutsScreen';

  @override
  State<BannerWorkoutsScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<BannerWorkoutsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<ScheduledWorkout> scheduledExercises = [];
  List<int> scheduledDays = [];
  List<int> orgScheduledDays = [];
  List<Exercises> exercises = [];
  List<String> exercisesString = [];

  bool isFavorite = false;
  bool isNotify = false;

  ToningExercisesRepository toningExercisesRepository =
      ToningExercisesRepository();
  UserMasterWorkoutRepository userMasterWorkoutRepository =
      UserMasterWorkoutRepository();
  UserRepository userRepository = UserRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();
  ScheduledWorkoutRepository scheduledWorkoutRepository =
      ScheduledWorkoutRepository();
  User_FavRepository user_favRepository = User_FavRepository();
  NotificationAlertRepository notificationAlertRepository =
      NotificationAlertRepository();

  StorageHandler storageHandler = StorageHandler();

  Future<void> loadToningExercises() async {
    // print(widget.exercise.Es_ID);
    List<ToningExercises> exerciseEquip =
        await toningExercisesRepository.getAllToningExercisesBytWsId(
            tWsId: widget.tonningWorkoutsModel.TWS_ID);
    for (var element in exerciseEquip) {
      Exercises? exercise =
          await exercisesRepository.getExercisesFromId(uid: element.ES_ID);
      if (!exercises.contains(exercise)) {
        exercises.add(exercise);
        exercisesString.add(exercise.es_name);
      }
    }
    setState(() {});
  }

  Future<void> loadFavorite() async {
    await loadUser();
    List<User_Fav> tempFavs = await user_favRepository.getAllFavoriteByRefId(
        spId: widget.tonningWorkoutsModel.TWS_ID, userId: userMaster!.UM_ID);
    if (tempFavs.isNotEmpty) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> loadNotification() async {
    await loadUser();
    int index = 0;
    List<NotificationAlert> tempNotify =
        await notificationAlertRepository.getAllNotificationAlertByRefId(
            refId: widget.tonningWorkoutsModel.TWS_ID,
            userId: userMaster!.UM_ID);
    if (tempNotify.isNotEmpty) {
      setState(() {
        if (scheduledDays.contains(index)) {
          scheduledDays.remove(index);
        } else {
          scheduledDays.add(index);
        }
      });
    }
  }

  Future<void> showNotificationForWorkout(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required String startDate}) async {
    StorageHandler storageHandler = StorageHandler();
    String imageUrl =
        await storageHandler.getImageUrl(widget.tonningWorkoutsModel.tWs_image);
    /*await AwesomeNotifications().createNotification(
        content: NotificationContent(
            // icon: "resource://drawable/1.jpg",
            bigPicture: imageUrl,
            largeIcon: imageUrl,
            id: id,
            channelKey: 'basic_channel',
            title: title,
            body: body,
            notificationLayout: NotificationLayout.BigPicture,
            // bigPicture: widget.workout.ws_image,
            payload: {'uuid': payload},
            category: NotificationCategory.Reminder
            // autoDismissible: false,

            ),
        schedule: NotificationCalendar.fromDate(
            date: DateTime.parse(startDate).add(Duration(hours: 6)),
            allowWhileIdle: true));*/
  }

  UserMaster? userMaster;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    loadUser();
    loadToningExercises();
    loadNotification();
    loadFavorite();
  }

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user);
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      context.loaderOverlay.hide();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return LoaderOverlay(
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      useDefaultLoading: false,
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: Scaffold(
        // backgroundColor: Colors.white,
        key: scaffoldKey,
        /*appBar: AppBar(
          title: Text(
            widget.tonningWorkoutsModel.tWs_name,
            style: TextStyle(color: Colors.white),
          ),
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          elevation: 0.00,
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red,
                size: 30.0,
              ),
              onPressed: () async {
                context.loaderOverlay.show();

                if (isFavorite) {
                  List<User_Fav> userFav =
                      await user_favRepository.getAllFavoriteByRefId(
                          spId: widget.tonningWorkoutsModel.TWS_ID,
                          userId: userMaster!.UM_ID);
                  final result = await user_favRepository.delete(
                      favId: userFav.first.FAV_ID);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result ? 'Fav Removed' : 'Error')));
                } else {
                  User? user = FirebaseAuth.instance.currentUser;
                  User_Fav userFav = User_Fav(
                      FAV_ID: '',
                      UM_ID: user!.uid,
                      REF_ID: widget.tonningWorkoutsModel.TWS_ID,
                      REF_Type: 'banner');
                  await user_favRepository.save(user_Fav: userFav);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green.shade500,
                      content: Text('Success')));
                }
                setState(() {
                  isFavorite = !isFavorite;
                });
                if (context.loaderOverlay.visible) {
                  context.loaderOverlay.hide();
                }
              },
            )
          ],
          //backgroundColor: Colors.greenAccent[400],
          backgroundColor: Colors.blueAccent[100],
        ),*/ //AppBar
        bottomNavigationBar: Constants.BottomContainer(
            onTap: () async {
              UserMasterWorkout? userMasterWorkout =
                  await userMasterWorkoutRepository
                      .getUserMasterWorkoutExistForDateIfExistForBanner(
                          date: Constants.getCurrentDate(),
                          bannerId: widget.tonningWorkoutsModel.TWS_ID,
                          userId: userMaster!.UM_ID);
              if (userMasterWorkout == null) {
                userMasterWorkout = UserMasterWorkout(
                    UM_WS_ID: '',
                    UM_ID: userMaster!.UM_ID,
                    WS_ID: widget.tonningWorkoutsModel.TWS_ID,
                    um_ws_startDate: Constants.getCurrentDate(),
                    um_ws_StartTime: Constants.getCurrentTime(),
                    um_ws_Is_Completed: false,
                    um_ws_activeCategoryId: '',
                    um_ws_activeExerciseId: exercises.first.Es_ID,
                    um_ws_type: 'banner',
                    um_ws_categoryName: '',
                    um_ws_kalBurned: 00,
                    um_ws_totalSpentTime: "00:00:00",
                    um_ws_currentExerciseResumeTime:
                        '${exercises.first.es_duration}:0',
                    TS_ID: '');
                userMasterWorkout = await userMasterWorkoutRepository.save(
                    userMasterWorkout: userMasterWorkout);
              }
              Exercises activeExercise =
                  await exercisesRepository.getExercisesFromId(
                      uid: userMasterWorkout.um_ws_activeExerciseId);
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RunningWorkoutScreen(
                  exercises: exercises,
                  activeExercise: activeExercise,
                  userMasterWorkout: userMasterWorkout!,
                );
              }));
            },
            title: "${getTranslated(context, 'start_workout')}",
            context: context),

        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Constants.BodyInfoContainer(
                      context: context,
                      image: storageHandler
                          .getImageUrl(widget.tonningWorkoutsModel.tWs_image),
                      title: widget.tonningWorkoutsModel.tWs_name,
                      duration:
                          '${widget.tonningWorkoutsModel.tWs_duration} ${widget.tonningWorkoutsModel.tWs_durationin}',
                      kal: widget.tonningWorkoutsModel.tWs_kal,
                      level: widget.tonningWorkoutsModel.tWs_level,
                      description: widget.tonningWorkoutsModel.tWs_description,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        // color: Colors.white,
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.11),
                      ),
                      equipments: '',
                      type: '',
                      onTap: () {}),
                  ExerciseList(context: context),
                ],
              ),
            ),
            Constants.HeaderContainer(
              context: context,
              title: widget.tonningWorkoutsModel.tWs_name,
              backIcon: Icon(Icons.arrow_back_ios),
              favIcon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red,
                size: 30.0,
              ),
              favOnPressed: () async {
                context.loaderOverlay.show();

                if (isFavorite) {
                  List<User_Fav> userFav =
                      await user_favRepository.getAllFavoriteByRefId(
                          spId: widget.tonningWorkoutsModel.TWS_ID,
                          userId: userMaster!.UM_ID);
                  final result = await user_favRepository.delete(
                      favId: userFav.first.FAV_ID);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result
                          ? "${getTranslated(context, 'fav_rem')}"
                          : "${getTranslated(context, 'error')}")));
                } else {
                  User? user = FirebaseAuth.instance.currentUser;
                  User_Fav userFav = User_Fav(
                      FAV_ID: '',
                      UM_ID: user!.uid,
                      REF_ID: widget.tonningWorkoutsModel.TWS_ID,
                      REF_Type: 'banner');
                  await user_favRepository.save(user_Fav: userFav);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green.shade500,
                      content: Text("${getTranslated(context, 'success')}")));
                }
                setState(() {
                  isFavorite = !isFavorite;
                });
                if (context.loaderOverlay.visible) {
                  context.loaderOverlay.hide();
                }
              },
              backOnPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget ExerciseList({
    required context,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "${getTranslated(context, 'exercises')}",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 10, right: 7, left: 7),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.11),
                borderRadius: BorderRadius.circular(25.0)),
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              // physics: BouncingScrollPhysics(),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Exercises exe = exercises.elementAt(index);
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Theme.of(context).disabledColor.withOpacity(0.11),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseInfoScreen(
                                  exercise: exe,
                                )));
                    // Navigator.pushNamed(context, CategoriesInfoScreen.route);
                  },
                  // minVerticalPadding: 25.0,
                  // tileColor: Colors.white,
                  leading: FutureBuilder(
                    future: storageHandler.getImageUrl(exe.es_image),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return FancyShimmerImage(
                        shimmerBaseColor: Colors.blue.shade200,
                        shimmerHighlightColor: Colors.grey[300],
                        shimmerBackColor: Colors.black.withBlue(1),
                        imageUrl: snapshot.data != null && snapshot.data != ''
                            ? snapshot.data!
                            : Constants.loaderUrl,
                        boxFit: BoxFit.cover,
                        errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                        width: 40,
                        height: 40,
                      );
                    },
                    initialData: Constants.loaderUrl,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15.0,
                  ),
                  title: Text(exe.es_name),
                  subtitle: Text('${exe.es_duration} ${exe.es_durationin}'),
                  // subtitle: Text('2 workouts'),

                  /*Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entity.text),
                              Text(entity.duration)
                            ],
                          ),*/
                );
              },
              itemCount: exercises.length,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  // Future<void> scheduleBannerWorkout(BuildContext context) async {
  //   scaffoldKey.currentState!.showBottomSheet(
  //       elevation: 0,
  //       backgroundColor: Colors.blue.shade50,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(25.0),
  //           topRight: Radius.circular(25.0),
  //         ),
  //       ), (context) {
  //     DateTime startDate = DateTime.now();
  //     startDate = startDate.add(const Duration(days: 1));
  //     DateFormat format = DateFormat('EEEE');
  //     /*int weekDay = startDate.weekday ;
  //       startDate = startDate.subtract(Duration(days: weekDay));*/
  //     return StatefulBuilder(builder: (context, setState) {
  //       return SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.6,
  //           width: MediaQuery.of(context).size.width,
  //           child: Stack(children: [
  //             Wrap(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     IconButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       icon: Icon(Icons.cancel_outlined),
  //                     ),
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                           child: Text(
  //                             "${getTranslated(context, 'schedule_workout')}",
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 fontSize: 20.0, fontWeight: FontWeight.bold),
  //                           ))
  //                     ],
  //                   ),
  //                 ),
  //                 Wrap(
  //                   children: [
  //                     SizedBox(
  //                       height: 80.0,
  //                       width: MediaQuery.of(context).size.width,
  //                       child: ListView(
  //                         physics: const BouncingScrollPhysics(),
  //                         scrollDirection: Axis.horizontal,
  //                         children: [
  //                           getDayContainer(
  //                               setState: setState,
  //                               containerIndex: 1,
  //                               header: format
  //                                   .format(startDate)
  //                                   .toString()
  //                                   .substring(0, 1),
  //                               isCompleted:
  //                               scheduledDays.contains(startDate.day),
  //                               footer: startDate.day.toString()),
  //                           getDayContainer(
  //                               setState: setState,
  //                               containerIndex: 2,
  //                               header: format
  //                                   .format(
  //                                   startDate.add(const Duration(days: 1)))
  //                                   .toString()
  //                                   .substring(0, 1),
  //                               isCompleted: scheduledDays.contains(
  //                                   startDate.add(const Duration(days: 1)).day),
  //                               footer: startDate
  //                                   .add(const Duration(days: 1))
  //                                   .day
  //                                   .toString()),
  //                           getDayContainer(
  //                               setState: setState,
  //                               containerIndex: 3,
  //                               header: format
  //                                   .format(
  //                                   startDate.add(const Duration(days: 2)))
  //                                   .toString()
  //                                   .substring(0, 1),
  //                               isCompleted: scheduledDays.contains(
  //                                   startDate.add(const Duration(days: 2)).day),
  //                               footer: startDate
  //                                   .add(const Duration(days: 2))
  //                                   .day
  //                                   .toString()),
  //                           getDayContainer(
  //                               setState: setState,
  //                               containerIndex: 4,
  //                               header: format
  //                                   .format(
  //                                   startDate.add(const Duration(days: 3)))
  //                                   .toString()
  //                                   .substring(0, 1),
  //                               isCompleted: scheduledDays.contains(
  //                                   startDate.add(const Duration(days: 3)).day),
  //                               footer: startDate
  //                                   .add(const Duration(days: 3))
  //                                   .day
  //                                   .toString()),
  //                           getDayContainer(
  //                               setState: setState,
  //                               containerIndex: 5,
  //                               header: format
  //                                   .format(
  //                                   startDate.add(const Duration(days: 4)))
  //                                   .toString()
  //                                   .substring(0, 1),
  //                               isCompleted: scheduledDays.contains(
  //                                   startDate.add(const Duration(days: 4)).day),
  //                               footer: startDate
  //                                   .add(const Duration(days: 4))
  //                                   .day
  //                                   .toString()),
  //                           getDayContainer(
  //                               setState: setState,
  //                               containerIndex: 6,
  //                               header: format
  //                                   .format(
  //                                   startDate.add(const Duration(days: 5)))
  //                                   .toString()
  //                                   .substring(0, 1),
  //                               isCompleted: scheduledDays.contains(
  //                                   startDate.add(const Duration(days: 5)).day),
  //                               footer: startDate
  //                                   .add(const Duration(days: 5))
  //                                   .day
  //                                   .toString()),
  //                           getDayContainer(
  //                               setState: setState,
  //                               containerIndex: 7,
  //                               header: format
  //                                   .format(
  //                                   startDate.add(const Duration(days: 6)))
  //                                   .toString()
  //                                   .substring(0, 1),
  //                               isCompleted: scheduledDays.contains(
  //                                   startDate.add(const Duration(days: 6)).day),
  //                               footer: startDate
  //                                   .add(const Duration(days: 6))
  //                                   .day
  //                                   .toString()),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Positioned(
  //               bottom: 25.0,
  //               child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 25.0, left: 15.0, right: 15.0),
  //                   child: InkWell(
  //                     onTap: () async {
  //                       this.context.loaderOverlay.show();
  //                       DateTime date = DateTime.now();
  //                       DateFormat format = DateFormat('yyyy-MM');
  //
  //                       for (int i = 0; i < orgScheduledDays.length; i++) {
  //                         int element = orgScheduledDays.elementAt(i);
  //
  //                         String stringDate = format.format(date);
  //                         if (element < 10) {
  //                           stringDate = '$stringDate-0$element';
  //                         } else {
  //                           stringDate = '$stringDate-$element';
  //                         }
  //
  //                         if (!scheduledDays.contains(element)) {
  //                           ScheduledWorkout? scheduleWorkout =
  //                           await scheduledWorkoutRepository
  //                               .getScheduledWorkoutFromUserIdByStartDate(
  //                               uid: userMaster!.UM_ID,
  //                               refId:
  //                               widget.tonningWorkoutsModel.TWS_ID,
  //                               date: stringDate);
  //                           if (scheduleWorkout != null) {
  //                             await scheduledWorkoutRepository.delete(
  //                                 sw_ID: scheduleWorkout.SW_ID);
  //
  //                             SharedPreferences sharedPref =
  //                             await SharedPreferences.getInstance();
  //                             List<String> storedIds = sharedPref.getStringList(
  //                                 Constants.faStoredNotificationIdKey) ??
  //                                 [];
  //
  //                             Map<String, dynamic> notificationData =
  //                             Map.fromEntries(
  //                                 [MapEntry(scheduleWorkout.SW_ID, 0)]);
  //                             List<String> existingMap =
  //                                 sharedPref.getStringList(Constants
  //                                     .faStoredNotificationMapKey) ??
  //                                     [];
  //
  //                             for (var element in existingMap) {
  //                               Map<String, dynamic> decodedString =
  //                               json.decode(element);
  //
  //                               if (decodedString.keys.first ==
  //                                   notificationData.keys.first) {
  //                                 existingMap.remove(element);
  //                                 storedIds.remove(
  //                                     decodedString.values.first.toString());
  //                                 AwesomeNotifications()
  //                                     .cancel(decodedString.values.first);
  //                                 sharedPref.setStringList(
  //                                     Constants.faStoredNotificationMapKey,
  //                                     existingMap);
  //                                 sharedPref.setStringList(
  //                                     Constants.faStoredNotificationIdKey,
  //                                     storedIds);
  //                                 break;
  //                               }
  //                             }
  //                           }
  //
  //                           ///Notification Remove in firebase
  //                           int index = 0;
  //                           List<NotificationAlert> userNotify =
  //                           await notificationAlertRepository
  //                               .getAllNotificationAlertByRefId(
  //                               refId:
  //                               widget.tonningWorkoutsModel.TWS_ID,
  //                               userId: userMaster!.UM_ID);
  //                           final result1 =
  //                           await notificationAlertRepository.delete(
  //                               na_id: userNotify.elementAt(index).NA_ID);
  //                           if (!mounted) return;
  //                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                               content:
  //                               Text(result1 ? "${getTranslated(context, 'fav_rem')}" : "${getTranslated(context, 'error')}")));
  //                         }
  //                       }
  //                       for (int i = 0; i < scheduledDays.length; i++) {
  //                         int element = scheduledDays[i];
  //                         String dateString = format.format(date);
  //                         String tempDay = "";
  //                         if (element < 10) {
  //                           tempDay = '0$element';
  //                         } else {
  //                           tempDay = '$element';
  //                         }
  //                         dateString = '$dateString-$tempDay';
  //                         final result =
  //                         await scheduledWorkoutRepository.isExist(
  //                             uid: userMaster!.UM_ID,
  //                             refId: widget.tonningWorkoutsModel.TWS_ID,
  //                             date: dateString);
  //                         if (!result) {
  //                           ScheduledWorkout scheduledWorkout =
  //                           ScheduledWorkout(
  //                               SW_ID: '',
  //                               UM_ID: userMaster!.UM_ID,
  //                               REF_ID: widget.tonningWorkoutsModel.TWS_ID,
  //                               REF_TYPE: 'banner',
  //                               sw_scheduledDate:
  //                               Constants.getCurrentDate(),
  //                               sw_scheduledForDate: dateString,
  //                               sw_scheduledTime:
  //                               Constants.getCurrentTime(),
  //                               sw_isActive: true);
  //                           scheduledWorkout = await scheduledWorkoutRepository
  //                               .save(scheduledWorkout: scheduledWorkout);
  //
  //                           SharedPreferences sharedPref =
  //                           await SharedPreferences.getInstance();
  //                           List<String> storedIds = sharedPref.getStringList(
  //                               Constants.faStoredNotificationIdKey) ??
  //                               [];
  //
  //                           int id = Random().nextInt(99999999);
  //                           while (storedIds.contains(id.toString())) {
  //                             id = Random().nextInt(99999999);
  //                           }
  //                           // print(id);
  //                           Map<String, int> notificationData = Map.fromEntries(
  //                               [MapEntry(scheduledWorkout.SW_ID, id)]);
  //                           List<String> existingMap = sharedPref.getStringList(
  //                               Constants.faStoredNotificationMapKey) ??
  //                               [];
  //
  //                           // print(existingMap);
  //                           final isNotExist = existingMap.every((element) {
  //                             Map<String, dynamic> decodedString =
  //                             json.decode(element);
  //                             if (decodedString.keys.first ==
  //                                 notificationData.keys.first) {
  //                               return false;
  //                             }
  //                             return true;
  //                           });
  //                           if (isNotExist) {
  //                             existingMap.add(json.encode(notificationData));
  //                             storedIds.add(id.toString());
  //                             sharedPref.setStringList(
  //                                 Constants.faStoredNotificationMapKey,
  //                                 existingMap);
  //                             sharedPref.setStringList(
  //                                 Constants.faStoredNotificationIdKey,
  //                                 storedIds);
  //                           }
  //
  //                           ///Notification Add in firebase
  //                           NotificationAlert userNotification =
  //                           NotificationAlert(
  //                               NA_ID: "",
  //                               UM_ID: userMaster!.UM_ID,
  //                               na_refType:
  //                               widget.tonningWorkoutsModel.tWs_name,
  //                               na_refId:
  //                               widget.tonningWorkoutsModel.TWS_ID,
  //                               na_refImage:
  //                               widget.tonningWorkoutsModel.tWs_image,
  //                               na_adt: dateString);
  //                           await notificationAlertRepository.save(
  //                               notificationAlert: userNotification);
  //
  //                           await showNotificationForWorkout(
  //                               id: id,
  //                               title: widget.tonningWorkoutsModel.tWs_name,
  //                               body: scheduledWorkout.sw_scheduledForDate,
  //                               payload: scheduledWorkout.SW_ID,
  //                               startDate:
  //                               scheduledWorkout.sw_scheduledForDate);
  //
  //                           if (!orgScheduledDays.contains(element)) {
  //                             orgScheduledDays.add(element);
  //                           }
  //                         }
  //                       }
  //                       this.context.loaderOverlay.hide();
  //                       if (!mounted) return;
  //                       Navigator.pop(context);
  //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                           backgroundColor: Colors.green.shade500,
  //                           content: Text("${getTranslated(context, 'scheduled')}")));
  //
  //                       // await loadScheduledExercises();
  //                     },
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       width: MediaQuery.of(context).size.width - 30.0,
  //                       height: 50.0,
  //                       decoration: BoxDecoration(
  //                           color: Colors.blue.shade900,
  //                           border: Border.all(),
  //                           borderRadius: BorderRadius.circular(40.0)),
  //                       child: Text(
  //                         "${getTranslated(context, 'schedule_exercise')}",
  //                         style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 20.0,
  //                             letterSpacing: 1.0,
  //                             fontWeight: FontWeight.bold),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     ),
  //                   )),
  //             )
  //           ]));
  //     });
  //   });
  // }

  Widget getDayContainer(
      {required String header,
      required bool isCompleted,
      required String footer,
      required int containerIndex,
      required dynamic setState}) {
    return InkWell(
      onTap: () {
        if (scheduledDays.contains(int.parse(footer))) {
          scheduledDays.remove(int.parse(footer));
        } else {
          scheduledDays.add(int.parse(footer));
        }
        setState(() {});
      },
      child: SizedBox(
        width: (MediaQuery.of(context).size.width) / 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            header.trim().isEmpty ? Container() : Text(header),
            Container(
              height: 25.0,
              width: 25.0,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(50.0),
                  color: isCompleted ? Colors.blue.shade900 : Colors.white),
              child: scheduledDays.contains(int.parse(footer))
                  ? Icon(
                      Icons.check,
                      size: 17.0,
                      color: Colors.white,
                    )
                  : Container(),
            ),
            Text(footer)
          ],
        ),
      ),
    );
  }

  Widget getTileContainer(
      {required String imagePath,
      required String text,
      required String subText,
      required IconData iconData,
      required dynamic onTap,
      topPadding = 0.0,
      bottomPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.only(
          top: topPadding, bottom: bottomPadding, left: 7.0, right: 7.0),
      child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 7.0, right: 7.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(imagePath,
                        height: 50.0, width: 80.0, fit: BoxFit.fill)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(text), Text(subText)],
                  ),
                ),
              ),
              Icon(iconData)
            ],
          )),
    );
  }

  String getCamelCaseWord(String input) {
    String output = '';
    output = input.characters.first.toString().toUpperCase();
    output = output + input.substring(1);
    return output;
  }
}
