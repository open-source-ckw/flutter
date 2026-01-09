// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:math';

// import 'package:auto_orientation/auto_orientation.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Screens/MusicProviderScreen.dart';
import '../Util/Constants.dart';
import '../Util/fullscreenvideo.dart';
import '../Util/videoplayerpage.dart';
import '../firebase/DB/Models/Equipments.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/Exercises_Equipments.dart';
import '../firebase/DB/Models/ScheduledWorkout.dart';
import '../firebase/DB/Models/User_Fav.dart';
import '../firebase/DB/Repo/EquipmentsRepository.dart';
import '../firebase/DB/Repo/Exercises_EquipmentsRepository.dart';
import '../firebase/DB/Repo/NotificationAlertRepository.dart';
import '../firebase/DB/Repo/ScheduledWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/User_FavRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../Components/EquipmentCarousel.dart';
import '../Util/Equipment.dart';
import '../firebase/DB/Models/NotificationAlert.dart';
import '../firebase/DB/Models/UserMaster.dart';
import 'dart:io' show Platform;

import '../local/localization/language_constants.dart';

class ExerciseInfoScreen extends StatefulWidget {
  Exercises exercise;

  ExerciseInfoScreen({Key? key, required this.exercise}) : super(key: key);

  static const String route = 'ExerciseInfoScreen';

  @override
  State<ExerciseInfoScreen> createState() => _ExerciseInfoScreenState();
}

class _ExerciseInfoScreenState extends State<ExerciseInfoScreen> {
  StorageHandler storageHandler = StorageHandler();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  UserRepository userRepository = UserRepository();
  ExercisesEquipmentsRepository exercisesEquipmentsRepository =
      ExercisesEquipmentsRepository();
  EquipmentsRepository equipmentsRepository = EquipmentsRepository();
  User_FavRepository user_favRepository = User_FavRepository();
  ScheduledWorkoutRepository scheduledWorkoutRepository =
      ScheduledWorkoutRepository();
  NotificationAlertRepository notificationAlertRepository =
      NotificationAlertRepository();

  List<Equipments> equipments = [];
  List<String> equipmentsString = [];

  bool isFavorite = false;

  UserMaster? userMaster;

  List<ScheduledWorkout> scheduledExercises = [];
  List<int> scheduledDays = [];
  List<int> orgScheduledDays = [];

  @override
  void initState() {
    super.initState();

    // String videoUrl = '';
    //    videoUrl =
    //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4';
    //    videoPlayerController = VideoPlayerController.network(videoUrl)
    //   ..initialize().then((_) {
    //     videoPlayerController!.setLooping(true);
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });

    // videoPlayerController!.play();

    loadUser();
    loadEquipments();
    loadScheduledExercises();
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

  Future<void> loadEquipments() async {
    // print(widget.exercise.Es_ID);
    List<ExercisesEquipments> exerciseEquip =
        await exercisesEquipmentsRepository.getAllExercisesEquipmentsByESId(
            esId: widget.exercise.Es_ID);
    for (var element in exerciseEquip) {
      Equipments equipment =
          await equipmentsRepository.getEquipmentsFromId(uid: element.EQ_ID);
      if (!equipments.contains(equipment)) {
        equipments.add(equipment);
        equipmentsString.add(getCamelCaseWord(equipment.eq_name));
      }
    }
    setState(() {});
  }

  Future<void> loadScheduledExercises() async {
    await loadUser();
    DateTime startDate = DateTime.now();
    // startDate = startDate.add(const Duration(days: 1));
    DateTime endDate = startDate.add(const Duration(days: 7));
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    List<ScheduledWorkout> tempScheduledWorkouts =
        await scheduledWorkoutRepository
            .getAllScheduledWorkoutFromUserIdByStartDate(
                uid: userMaster!.UM_ID,
                startDate: dateFormat.format(startDate).toString(),
                refId: widget.exercise.Es_ID,
                endDate: dateFormat.format(endDate).toString());

    for (var element in tempScheduledWorkouts) {
      DateFormat format = DateFormat("dd");
      String day = format.format(DateTime.parse(element.sw_scheduledForDate));
      if (!scheduledDays.contains(int.parse(day))) {
        scheduledDays.add(int.parse(day));
        orgScheduledDays.add(int.parse(day));
      }
    }
  }

  Future<void> loadFavorite() async {
    await loadUser();
    List<User_Fav> tempFavs = await user_favRepository.getAllFavoriteByRefId(
        spId: widget.exercise.Es_ID, userId: userMaster!.UM_ID);
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
            refId: widget.exercise.Es_ID, userId: userMaster!.UM_ID);

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

  // VideoPlayerController? videoPlayerController;

  Future<void> showNotificationForWorkout(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required String scheduleForDate}) async {
    StorageHandler storageHandler = StorageHandler();
    String imageUrl =
        await storageHandler.getImageUrl(widget.exercise.es_image);
    // print('SCHEDULED ON :${DateTime.parse(scheduleForDate).add(Duration(hours: 6))}');
   /* await AwesomeNotifications().createNotification(
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
            date: DateTime.parse(scheduleForDate).add(Duration(hours: 6)),
            allowWhileIdle: true));*/
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: true,
      child: Scaffold(
        //backgroundColor: Colors.grey.shade300,
        // backgroundColor: Colors.white,
        /*appBar: AppBar(
          title: Text(
            widget.exercise.es_name,
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
                          spId: widget.exercise.Es_ID,
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
                      REF_ID: widget.exercise.Es_ID,
                      REF_Type: 'exercise');
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
        key: scaffoldKey,
        bottomNavigationBar: Constants.BottomContainer(
            onTap: () async {
              // await scheduleOrStartExercise(context);
              await scheduleExercise(context).then((value) async {
                // await loadScheduledExercises();
              });
            },
            title: "${getTranslated(context, 'schedule_exercise')}",
            context: context),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // videoPlayerController!.value.isInitialized
                  //     ? buildVideoNew()
                  //     : Container(),
                  Constants.BodyInfoContainer(
                    context: context,
                    image: storageHandler.getImageUrl(widget.exercise.es_image),

                    title: widget.exercise.es_name,
                    duration:
                        '${widget.exercise.es_duration} ${widget.exercise.es_durationin}',
                    kal: widget.exercise.es_kal,
                    level: widget.exercise.es_level,
                    description: widget.exercise.es_description,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.11)),
                    equipments: equipmentsString.join(","),
                    type: widget.exercise.es_type,
                    onTap: () {},
                    // equipmentCarousel: EquipmentCarousel(equipments: equipments),
                  ),
                ],
              ),
            ),
            Constants.HeaderContainer(
              context: context,
              title: widget.exercise.es_name,
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
                          spId: widget.exercise.Es_ID,
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
                      REF_ID: widget.exercise.Es_ID,
                      REF_Type: 'exercise');
                  await user_favRepository.save(user_Fav: userFav);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green.shade500,
                      content: Text("${getTranslated(context, 'fav_added')}")));
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

  Future setLandscape() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Wakelock.enable();
  }

  Orientation? target;

  void setOrientation(bool isPortrait) {
    if (isPortrait) {
      Wakelock.disable();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    } else {
      Wakelock.enable();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  /*Widget buildVideoNew() => OrientationBuilder(builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;

        setOrientation(isPortrait);

        return Container(
          color: Colors.black,
          //height: MediaQuery.of(context).size.height / 3.4,
          margin: EdgeInsets.only(top: kToolbarHeight - 5),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.black),
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        color: Colors.black,
                        //width: double.infinity,
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            child: VideoPlayer(videoPlayerController!),
                          ),
                        ),
                      ),
                    ),
                    VideoProgressIndicator(
                      videoPlayerController!,
                      allowScrubbing: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                videoPlayerController!.value.isPlaying
                                    ? videoPlayerController!.pause()
                                    : videoPlayerController!.play();
                              });
                            },
                            child: Icon(
                              videoPlayerController!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdvancedOverlayWidget(
                                              target: target,
                                              isPortrait: isPortrait,
                                              controller:
                                                  videoPlayerController!,
                                              onClickedFullScreen: () {
                                                target = isPortrait
                                                    ? Orientation.landscape
                                                    : Orientation.portrait;

                                                if (isPortrait) {
                                                  AutoOrientation
                                                      .landscapeRightMode();
                                                } else {
                                                  AutoOrientation
                                                      .portraitUpMode();
                                                }
                                              },
                                            )));
                              });
                            },
                            child: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });*/

  Future<void> scheduleExercise(BuildContext context) async {
    scaffoldKey.currentState!.showBottomSheet(
        elevation: 0,
        // backgroundColor: Colors.blue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ), (context) {
      DateTime startDate = DateTime.now();
      startDate = startDate.add(const Duration(days: 1));
      DateFormat format = DateFormat('EEEE');
      /*int weekDay = startDate.weekday ;
        startDate = startDate.subtract(Duration(days: weekDay));*/
      return StatefulBuilder(builder: (context, setState) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Wrap(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       icon: Icon(Icons.cancel_outlined),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 20.0, left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${getTranslated(context, 'schedule_exercise')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel_outlined),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            getDayContainer(
                                setState: setState,
                                containerIndex: 1,
                                header: format
                                    .format(startDate)
                                    .toString()
                                    .substring(0, 1),
                                isCompleted:
                                    scheduledDays.contains(startDate.day),
                                footer: startDate.day.toString()),
                            getDayContainer(
                                setState: setState,
                                containerIndex: 2,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 1)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledDays.contains(
                                    startDate.add(const Duration(days: 1)).day),
                                footer: startDate
                                    .add(const Duration(days: 1))
                                    .day
                                    .toString()),
                            getDayContainer(
                                setState: setState,
                                containerIndex: 3,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 2)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledDays.contains(
                                    startDate.add(const Duration(days: 2)).day),
                                footer: startDate
                                    .add(const Duration(days: 2))
                                    .day
                                    .toString()),
                            getDayContainer(
                                setState: setState,
                                containerIndex: 4,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 3)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledDays.contains(
                                    startDate.add(const Duration(days: 3)).day),
                                footer: startDate
                                    .add(const Duration(days: 3))
                                    .day
                                    .toString()),
                            getDayContainer(
                                setState: setState,
                                containerIndex: 5,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 4)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledDays.contains(
                                    startDate.add(const Duration(days: 4)).day),
                                footer: startDate
                                    .add(const Duration(days: 4))
                                    .day
                                    .toString()),
                            getDayContainer(
                                setState: setState,
                                containerIndex: 6,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 5)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledDays.contains(
                                    startDate.add(const Duration(days: 5)).day),
                                footer: startDate
                                    .add(const Duration(days: 5))
                                    .day
                                    .toString()),
                            getDayContainer(
                                setState: setState,
                                containerIndex: 7,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 6)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledDays.contains(
                                    startDate.add(const Duration(days: 6)).day),
                                footer: startDate
                                    .add(const Duration(days: 6))
                                    .day
                                    .toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 25.0,
                child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: InkWell(
                      onTap: () async {
                        this.context.loaderOverlay.show();
                        DateTime date = DateTime.now();
                        DateFormat format = DateFormat('yyyy-MM');

                        /* print('ORGSCHDATES:');
                        print('$orgScheduledDays');
                        print('SCHDATES:');dd
                        print('$scheduledDays:');*/
                        for (int i = 0; i < orgScheduledDays.length; i++) {
                          int element = orgScheduledDays.elementAt(i);

                          String stringDate = format.format(date);
                          if (element < 10) {
                            stringDate = '$stringDate-0$element';
                          } else {
                            stringDate = '$stringDate-$element';
                          }
                          // print(stringDate);

                          if (!scheduledDays.contains(element)) {
                            ScheduledWorkout? scheduleWorkout =
                                await scheduledWorkoutRepository
                                    .getScheduledWorkoutFromUserIdByStartDate(
                                        uid: userMaster!.UM_ID,
                                        refId: widget.exercise.Es_ID,
                                        date: stringDate);
                            if (scheduleWorkout != null) {
                              await scheduledWorkoutRepository.delete(
                                  sw_ID: scheduleWorkout.SW_ID);

                              SharedPreferences sharedPref =
                                  await SharedPreferences.getInstance();
                              List<String> storedIds = sharedPref.getStringList(
                                      Constants.faStoredNotificationIdKey) ??
                                  [];

                              Map<String, dynamic> notificationData =
                                  Map.fromEntries(
                                      [MapEntry(scheduleWorkout.SW_ID, 0)]);
                              List<String> existingMap =
                                  sharedPref.getStringList(Constants
                                          .faStoredNotificationMapKey) ??
                                      [];

                              for (var element in existingMap) {
                                Map<String, dynamic> decodedString =
                                    json.decode(element);

                                if (decodedString.keys.first ==
                                    notificationData.keys.first) {
                                  existingMap.remove(element);
                                  storedIds.remove(
                                      decodedString.values.first.toString());
                                  // AwesomeNotifications()
                                  //     .cancel(decodedString.values.first);
                                  sharedPref.setStringList(
                                      Constants.faStoredNotificationMapKey,
                                      existingMap);
                                  sharedPref.setStringList(
                                      Constants.faStoredNotificationIdKey,
                                      storedIds);
                                  break;
                                }
                              }
                            }

                            ///Notification Remove in firebase
                            int index = 0;
                            List<NotificationAlert> userNotify =
                                await notificationAlertRepository
                                    .getAllNotificationAlertByRefId(
                                        refId: widget.exercise.Es_ID,
                                        userId: userMaster!.UM_ID);
                            final result1 =
                                await notificationAlertRepository.delete(
                                    na_id: userNotify.elementAt(index).NA_ID);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(result1
                                    ? "${getTranslated(context, 'scheduled_delete')}"
                                    : "${getTranslated(context, 'error')}")));
                          }
                        }
                        for (int i = 0; i < scheduledDays.length; i++) {
                          int element = scheduledDays[i];
                          String dateString = format.format(date);
                          String tempDay = "";
                          if (element < 10) {
                            tempDay = '0$element';
                          } else {
                            tempDay = '$element';
                          }
                          dateString = '$dateString-$tempDay';
                          final result =
                              await scheduledWorkoutRepository.isExist(
                                  uid: userMaster!.UM_ID,
                                  refId: widget.exercise.Es_ID,
                                  date: dateString);
                          if (!result) {
                            ScheduledWorkout scheduledWorkout =
                                ScheduledWorkout(
                                    SW_ID: '',
                                    UM_ID: userMaster!.UM_ID,
                                    REF_ID: widget.exercise.Es_ID,
                                    REF_TYPE: 'exercise',
                                    sw_scheduledDate:
                                        Constants.getCurrentDate(),
                                    sw_scheduledForDate: dateString,
                                    sw_scheduledTime:
                                        Constants.getCurrentTime(),
                                    sw_isActive: true);
                            scheduledWorkout = await scheduledWorkoutRepository
                                .save(scheduledWorkout: scheduledWorkout);

                            SharedPreferences sharedPref =
                                await SharedPreferences.getInstance();
                            List<String> storedIds = sharedPref.getStringList(
                                    Constants.faStoredNotificationIdKey) ??
                                [];

                            int id = Random().nextInt(99999999);
                            while (storedIds.contains(id.toString())) {
                              id = Random().nextInt(99999999);
                            }
                            // print(id);
                            Map<String, int> notificationData = Map.fromEntries(
                                [MapEntry(scheduledWorkout.SW_ID, id)]);
                            List<String> existingMap = sharedPref.getStringList(
                                    Constants.faStoredNotificationMapKey) ??
                                [];

                            // print(existingMap);
                            final isNotExist = existingMap.every((element) {
                              Map<String, dynamic> decodedString =
                                  json.decode(element);
                              if (decodedString.keys.first ==
                                  notificationData.keys.first) {
                                return false;
                              }
                              return true;
                            });
                            if (isNotExist) {
                              // existingMap.add(JsonEncoder().convert(notificationData));

                              existingMap.add(json.encode(notificationData));
                              storedIds.add(id.toString());
                              sharedPref.setStringList(
                                  Constants.faStoredNotificationMapKey,
                                  existingMap);
                              sharedPref.setStringList(
                                  Constants.faStoredNotificationIdKey,
                                  storedIds);
                            }

                            ///Notification Add in firebase
                            NotificationAlert userNotification =
                                NotificationAlert(
                                    NA_ID: "",
                                    UM_ID: userMaster!.UM_ID,
                                    na_refType: widget.exercise.es_name,
                                    na_refId: widget.exercise.Es_ID,
                                    na_refImage: widget.exercise.es_image,
                                    na_adt: dateString);
                            await notificationAlertRepository.save(
                                notificationAlert: userNotification);

                            await showNotificationForWorkout(
                                id: id,
                                title: widget.exercise.es_name,
                                body: scheduledWorkout.sw_scheduledForDate,
                                payload: scheduledWorkout.SW_ID,
                                scheduleForDate:
                                    scheduledWorkout.sw_scheduledForDate);

                            if (!orgScheduledDays.contains(element)) {
                              orgScheduledDays.add(element);
                            }
                          }
                        }
                        this.context.loaderOverlay.hide();
                        if (!mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green.shade500,
                            content: Text(
                                "${getTranslated(context, 'scheduled')}")));
                        // await loadScheduledExercises();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text(
                          "${getTranslated(context, 'save')}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
              )
            ]));
      });
    });
  }

  // Future<void> scheduleOrStartExercise(BuildContext context) async {
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
  //           height: MediaQuery.of(context).size.height * 0.45,
  //           width: MediaQuery.of(context).size.width,
  //           child: Column(
  //             mainAxisAlignment:
  //             MainAxisAlignment.center,
  //             children: [
  //               Row(
  //                 mainAxisAlignment:
  //                 MainAxisAlignment.center,
  //                 children: [
  //                   InkWell(
  //                       onTap: () {
  //                         // pickImage().then((value) {
  //                         //   Navigator.pop(context);
  //                         // });
  //                       },
  //                       child: Column(
  //                         children: [
  //                           Icon(
  //                             Icons
  //                                 .schedule,
  //                             size: 90,
  //                           ),
  //                           Text(
  //                             'Schedule Exercise ',
  //                           ),
  //                         ],
  //                       )),
  //                   SizedBox(
  //                     width: MediaQuery.of(context)
  //                         .size
  //                         .width *
  //                         0.2,
  //                   ),
  //                   InkWell(
  //                       onTap: () {
  //                         // clickImage().then((value) {
  //                         //   Navigator.pop(context);
  //                         // });
  //                       },
  //                       child: Column(
  //                         crossAxisAlignment:
  //                         CrossAxisAlignment.center,
  //                         children: [
  //                           Icon(
  //                             Icons.camera_outlined,
  //                             size: 90,
  //                           ),
  //                           Text('Camera'),
  //                         ],
  //                       )),
  //                 ],
  //               ),
  //             ],
  //           ));
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
                  color: isCompleted
                      ? Theme.of(context).disabledColor.withOpacity(0.14)
                      : Colors.white),
              child: scheduledDays.contains(int.parse(footer))
                  ? Icon(
                      Icons.check,
                      size: 17.0,
                      // color: Colors.white,
                    )
                  : Container(),
            ),
            Text(footer)
          ],
        ),
      ),
    );
  }

  String getCamelCaseWord(String input) {
    String output = '';
    output = input.characters.first.toString().toUpperCase();
    output = output + input.substring(1);
    return output;
  }

  Future setAllOrientations() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    await Wakelock.disable();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // videoPlayerController!.dispose();
    // setAllOrientations();
  }
}
