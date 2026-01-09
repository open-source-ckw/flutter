// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import '../Provider/ReminderWorkoutProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import '../firebase/DB/Models/ReminderWorkout.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/ReminderWorkoutsRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/Constants.dart';
import '../firebase/Storage/StorageHandler.dart';
import '../local/localization/language_constants.dart';

class CreateWorkOutReminder extends StatefulWidget {
  static const String route = 'CreateWorkoutReminder';

  const CreateWorkOutReminder({Key? key}) : super(key: key);

  @override
  State<CreateWorkOutReminder> createState() => _CreateWorkOutReminderState();
}

class _CreateWorkOutReminderState extends State<CreateWorkOutReminder> {
  // var selectedVal = "";
  // List<int> scheduledDays = [];

  String selectHour = "";
  String selectMinute = "";
  String selectAmPm = "";

  List<int> scheduledDays = [];
  List<int> orgScheduledDays = [];
  List<int> selectedLevels = [];
  List<ReminderWorkouts> reminderWorkouts = [];

  UserMaster? userMaster;

  UserRepository userRepository = UserRepository();
  ReminderWorkoutsRepository reminderWorkoutsRepository =
      ReminderWorkoutsRepository();
  ReminderWorkoutProvider reminderWorkoutProvider = ReminderWorkoutProvider();

  TimeOfDay time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  // bool isSecond = false;

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user);
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      context.loaderOverlay.hide();
      setState(() {});
    }
  }

  Future<void> loadReminderWorkouts() async {
    await loadUser();
    await reminderWorkoutProvider.createReminderProvider(
        userID: userMaster!.UM_ID, time: '${selectHour} : ${selectMinute}');
  }

  // Future<void> loadReminderWorkouts() async {
  //   await loadUser();
  //   DateTime startDate = DateTime.now();
  //   startDate = startDate.add(const Duration(days: 1));
  //
  //   List<ReminderWorkouts> tempReminderWorkouts =
  //   await reminderWorkoutsRepository
  //       .getAllReminderWorkoutsFromUserIdByStartDate(
  //       uid: userMaster!.UM_ID,
  //       startDate: scheduledDays.toString(),
  //       setTime: '${selectHour} : ${selectMinute}');
  //
  //   for (var element in tempReminderWorkouts) {
  //     DateFormat format = DateFormat("dd");
  //     String day = format.format(DateTime.parse(element.rw_scheduledForDay));
  //     if (!scheduledDays.contains(int.parse(day))) {
  //       scheduledDays.add(int.parse(day));
  //       orgScheduledDays.add(int.parse(day));
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    loadUser();
    reminderWorkoutProvider =
        Provider.of<ReminderWorkoutProvider>(context, listen: false);
    loadReminderWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    reminderWorkoutProvider =
        Provider.of<ReminderWorkoutProvider>(context, listen: false);

    DateTime startDate = DateTime.now();
    startDate = startDate.add(const Duration(days: 0));
    DateFormat format = DateFormat('EEEE');

    // final hours = time.hour.toString().padLeft(2, '0');
    // final minute = time.minute.toString().padLeft(2, '0');

    List<String> filters = [
      " ${format.format(startDate).toString().substring(0, 1)}",
      (format
          .format(startDate.add(const Duration(days: 1)))
          .toString()
          .substring(0, 1)),
      (format
          .format(startDate.add(const Duration(days: 2)))
          .toString()
          .substring(0, 1)),
      (format
          .format(startDate.add(const Duration(days: 3)))
          .toString()
          .substring(0, 1)),
      (format
          .format(startDate.add(const Duration(days: 4)))
          .toString()
          .substring(0, 1)),
      (format
          .format(startDate.add(const Duration(days: 5)))
          .toString()
          .substring(0, 1)),
      (format
          .format(startDate.add(const Duration(days: 6)))
          .toString()
          .substring(0, 1)),
    ];

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        // backgroundColor: Colors.transparent,
        title: Text(
          "${getTranslated(context, 'create_ws_reminder')}",
          style: TextStyle(color: Theme.of(context).textTheme.headline5!.color),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 75.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 55.0, bottom: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                "${getTranslated(context, 'select_days_exercise')}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ))
                            ],
                          )),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          // physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 7.0, right: 7.0),
                              child: InkWell(
                                onTap: () async {
                                  if (scheduledDays.contains(index)) {
                                    scheduledDays.remove(index);
                                  } else {
                                    scheduledDays.add(index);
                                  }
                                  // print(scheduledDays);
                                  setState(() {});
                                  await loadReminderWorkouts();
                                },
                                child: SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width) / 7,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        scheduledDays.contains(index)
                                            ? Colors.blue.shade900
                                            : Colors.grey,
                                    minRadius: 25.0,
                                    child: Text(
                                      filters[index],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: filters.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 55.0, bottom: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                "${getTranslated(context, 'select_time_workout')}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ))
                            ],
                          )),
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 55.0, bottom: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 110.0,
                                width: 50.0,
                                child: ListWheelScrollView.useDelegate(
                                  physics: const FixedExtentScrollPhysics(),
                                  perspective: 0.01,
                                  diameterRatio: 1.5,
                                  // mainAxisSize: MainAxisSize.max,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  itemExtent: 45.0,
                                  onSelectedItemChanged: (index) {
                                    selectHour = (index + 1).toString();
                                    // isMin.length = index;
                                    // print(selectHour);
                                  },
                                  offAxisFraction: 0.2,
                                  childDelegate:
                                      ListWheelChildLoopingListDelegate(
                                          children: List.generate(
                                              12,
                                              (index) => CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue.shade900,
                                                    minRadius: 25.0,
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 26.0,
                                                          color: Colors.white),
                                                    ),
                                                  ))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: SizedBox(
                                  height: 110.0,
                                  width: 50.0,
                                  child: ListWheelScrollView.useDelegate(
                                    physics: const FixedExtentScrollPhysics(),
                                    perspective: 0.01,
                                    diameterRatio: 1.5,
                                    // mainAxisSize: MainAxisSize.max,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    itemExtent: 45.0,
                                    onSelectedItemChanged: (index) {
                                      selectMinute = (index >= 0 && index <= 9
                                              ? '0$index'
                                              : '$index')
                                          .toString();
                                      // print(selectMinute);
                                      // isSecond.first = index;
                                    },
                                    offAxisFraction: 0.2,
                                    childDelegate:
                                        ListWheelChildLoopingListDelegate(
                                            children: List.generate(
                                                60,
                                                (index) => CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue.shade900,
                                                      minRadius: 25.0,
                                                      child: Text(
                                                        index >= 0 && index <= 9
                                                            ? '0$index'
                                                            : '$index',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 26.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: SizedBox(
                                  height: 110.0,
                                  width: 50.0,
                                  child: ListWheelScrollView.useDelegate(
                                    physics: const FixedExtentScrollPhysics(),
                                    perspective: 0.01,
                                    diameterRatio: 1.5,
                                    // mainAxisSize: MainAxisSize.max,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    itemExtent: 45.0,
                                    onSelectedItemChanged: (index) {
                                      selectAmPm =
                                          (index == 0 ? 'AM' : 'PM').toString();
                                      // print(selectAmPm);
                                      // isAMOrPM.length = index;
                                    },
                                    offAxisFraction: 0.2,
                                    childDelegate: ListWheelChildListDelegate(
                                        children: List.generate(
                                            2,
                                            (index) => Text(
                                                  index == 0 ? 'AM' : 'PM',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 26.0,
                                                      color:
                                                          Colors.blue.shade900),
                                                ))),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: InkWell(
                    /*    onTap: () async {
                      this.context.loaderOverlay.show();
                      DateTime date = DateTime.now();
                      DateFormat format = DateFormat('EEEE');

                      for (int i = 0; i < orgScheduledDays.length; i++) {
                        int element = orgScheduledDays.elementAt(i);

                        String stringDate = format.format(date);
                        if (element < 10) {
                          stringDate = '$stringDate-$element';
                        } else {
                          stringDate = '$stringDate-$element';
                        }
                        // print(stringDate);

                        if (!scheduledDays.contains(element)) {
                          int index = 0;
                          ReminderWorkouts rWorkouts =
                              reminderWorkouts.elementAt(index);

                          List<ReminderWorkouts> reminderWorkout =
                              await reminderWorkoutsRepository
                                  .getAllReminderWorkoutsFromUserIdByStartDate(
                                      uid: userMaster!.UM_ID,
                                      startDate: stringDate,
                                      setTime: "$hours : $minute");
                          if (reminderWorkout != null) {
                            await reminderWorkoutsRepository.delete(
                                rw_id: rWorkouts.RW_ID);

                            SharedPreferences sharedPref =
                                await SharedPreferences.getInstance();
                            List<String> storedIds = sharedPref.getStringList(
                                    Constants.faStoredNotificationIdKey) ??
                                [];

                            Map<String, dynamic> notificationData =
                                Map.fromEntries([MapEntry(rWorkouts.RW_ID, 0)]);
                            List<String> existingMap = sharedPref.getStringList(
                                    Constants.faStoredNotificationMapKey) ??
                                [];

                            for (var element in existingMap) {
                              Map<String, dynamic> decodedString =
                                  json.decode(element);
                              if (decodedString.keys.first ==
                                  notificationData.keys.first) {
                                existingMap.remove(element);
                                storedIds.remove(
                                    decodedString.values.first.toString());
                                AwesomeNotifications()
                                    .cancel(decodedString.values.first);
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
                        }
                      }
                      for (int i = 0; i < scheduledDays.length; i++) {
                        int element = scheduledDays[i];
                        String dateString = format.format(date);
                        String tempDay = "";
                        if (element < 10) {
                          tempDay = '$element';
                        } else {
                          tempDay = '$element';
                        }
                        dateString = '$dateString-$tempDay';
                        final result = await reminderWorkoutsRepository.isExist(
                            uid: userMaster!.UM_ID,
                            day: scheduledDays.toString());
                        if (!result) {
                          ReminderWorkouts reminderWorkouts = ReminderWorkouts(
                              RW_ID: '',
                              UM_ID: userMaster!.UM_ID,
                              WS_ID: 'Lets Start Workouts',
                              rw_reminderDay: Constants.getCurrentDate(),
                              rw_scheduledForDay: dateString,
                              rw_reminderTime: '$hours : $minute',
                              rw_isActive: true);
                          reminderWorkouts = await reminderWorkoutsRepository.save(reminderWorkouts: reminderWorkouts);

                          // print(reminderWorkouts);

                          SharedPreferences sharedPref =
                              await SharedPreferences.getInstance();
                          List<String> storedIds = sharedPref.getStringList(
                                  Constants.faStoredNotificationIdKey) ?? [];

                          int id = Random().nextInt(99999999);
                          while (storedIds.contains(id.toString())) {
                            id = Random().nextInt(99999999);
                          }
                          // print(id);
                          Map<String, int> notificationData = Map.fromEntries(
                              [MapEntry(reminderWorkouts.RW_ID, id)]);
                          List<String> existingMap = sharedPref.getStringList(
                                  Constants.faStoredNotificationMapKey) ?? [];

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
                                Constants.faStoredNotificationIdKey, storedIds);
                          }
                          await showNotificationForWorkout(
                              id: id,
                              title: "Today Workouts Reminder",
                              body: reminderWorkouts.rw_reminderTime,
                              payload: reminderWorkouts.RW_ID,
                              scheduleForDate:
                                  reminderWorkouts.rw_scheduledForDay);

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
                          content: Text('Scheduled')));
                      // await loadScheduledExercises();
                    },*/

                    onTap: () async {
                      if (selectHour == null &&
                          selectMinute == null &&
                          selectAmPm == null &&
                          scheduledDays.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red.shade500,
                            content: Text(
                                "${getTranslated(context, 'please_select_day')}")));
                      } else {
                        int index = 0;
                        var day = scheduledDays.elementAt(index);

                        final result = await reminderWorkoutsRepository.isExist(
                            uid: userMaster!.UM_ID,
                            day: scheduledDays.toString());
                        if (!result) {
                          ReminderWorkouts reminderWorkouts = ReminderWorkouts(
                              RW_ID: '',
                              UM_ID: userMaster!.UM_ID,
                              WS_ID: 'Lets Start Workouts',
                              rw_reminderDay: Constants.getCurrentDate(),
                              rw_scheduledForDay: day.toString(),
                              rw_reminderTime:
                                  '$selectHour : $selectMinute $selectAmPm',
                              rw_isActive: true);
                          reminderWorkouts = await reminderWorkoutsRepository
                              .save(reminderWorkouts: reminderWorkouts);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red.shade500,
                              content: Text(
                                  "${getTranslated(context, 'set_reminder')}")));

                          // print(existingMap);
                          await showNotificationForWorkout(
                              id: 1,
                              title: "Today Workouts Reminder",
                              body: reminderWorkouts.rw_reminderTime,
                              payload: reminderWorkouts.RW_ID,
                              scheduleForDate:
                                  reminderWorkouts.rw_scheduledForDay);
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50.00,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[900],
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Text(
                        "${getTranslated(context, 'create_reminder')}",
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
          ],
        ),
      ),
    );
  }

  Future<void> showNotificationForWorkout(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required String scheduleForDate}) async {
    // StorageHandler storageHandler = StorageHandler();
    // String imageUrl =await storageHandler.getImageUrl(widget.exercise.es_image);
    // print('SCHEDULED ON :${DateTime.parse(scheduleForDate).add(Duration(hours: 6))}');
   /* await AwesomeNotifications().createNotification(
      content: NotificationContent(
          icon: "resource://drawable/1.jpg",
          //   bigPicture: imageUrl,
          largeIcon: 'resource://drawable/1.jpg',
          bigPicture: "resource://drawable/1.jpg",
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
      // schedule: NotificationCalendar.fromDate(date: DateTime.parse(scheduleForDate).add(const Duration(minutes: 10)),allowWhileIdle: true)
    );*/
    // print(scheduleForDate);
  }
}
