import 'dart:convert';
import 'dart:math';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase/DB/Models/Banner.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Models/ScheduledWorkout.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Models/Workouts.dart';
import '../firebase/DB/Repo/CategoryRepository.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/ScheduledWorkoutRepository.dart';
import '../firebase/DB/Repo/Toning_ExercisesRepository.dart';
import '../firebase/DB/Repo/TonningWorkoutsRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/WorkoutsRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../local/localization/language_constants.dart';

class ScheduledWorkoutScreen extends StatefulWidget {
  const ScheduledWorkoutScreen({Key? key}) : super(key: key);

  static const String route = "ScheduledWorkoutScreen";

  @override
  State<ScheduledWorkoutScreen> createState() => _ScheduledWorkoutScreenState();
}

class _ScheduledWorkoutScreenState extends State<ScheduledWorkoutScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<int> scheduledWorkoutDays = [];
  List<int> orgScheduledWorkoutDays = [];
  List<int> scheduledExerciseDays = [];
  List<int> scheduledCategoryDays = [];
  List<int> orgScheduledCategoryDays = [];
  List<int> orgScheduledExerciseDays = [];
  List<int> scheduledToningWorkoutDays = [];
  List<int> orgScheduledToningWorkoutDays = [];

  StorageHandler storageHandler = StorageHandler();

  UserMaster? userMaster;

  // List<ScheduledWorkout> scheduledWorkoutList = [];
  List<ScheduledWorkout> scheduledWorkouts = [];
  UserMasterWorkout? userMasterWorkout;

  UserRepository userRepository = UserRepository();
  ScheduledWorkoutRepository scheduledWorkoutRepository =
      ScheduledWorkoutRepository();
  CategoryRepository categoryRepository = CategoryRepository();

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
    }
  }

  List<Workouts> workouts = [];
  List<Exercises> exercises = [];
  List<Categories> categories = [];
  List<TonningWorkoutsModel> toningWorkouts = [];

  // Future<void> loadWorkouts() async {
  //   // User? user = FirebaseAuth.instance.currentUser;
  //   // Future<List<Workouts>> workout = workoutsRepository.getAllWorkouts();
  //   if (workOuts != null) {
  //     Workouts workouts = await workoutsRepository.getWorkoutsFromId(uid: workOuts!.WS_ID);
  //     // if (context.loaderOverlay.visible) {
  //     //   context.loaderOverlay.hide();
  //     // }
  //     setState(() {
  //       this.workOuts = workouts;
  //     });
  //   }
  // }

  Future<void> loadWorkout() async {
    List<Workouts> tempWorkouts = await workoutsRepository.getAllWorkouts();

    if (workouts.isEmpty) {
      workouts = tempWorkouts;
    }
    setState(() {});
  }

  Future<void> loadExercise() async {
    List<Exercises> tempExercise = await exercisesRepository.getAllExercises();

    if (exercises.isEmpty) {
      exercises = tempExercise;
    }
    setState(() {});
  }

  Future<void> loadCategories() async {
    List<Categories> tempCategories =
        await categoryRepository.getAllCategories();

    if (categories.isEmpty) {
      categories = tempCategories;
    }
    setState(() {});
  }

  Future<void> loadToning() async {
    List<TonningWorkoutsModel> tempToning =
        await tonningWorkoutsRepository.getAllTonningWorkouts();

    if (toningWorkouts.isEmpty) {
      toningWorkouts = tempToning;
    }
    setState(() {});
  }

  Future<void> loadUserScheduleWorkouts() async {
    // userWorkouts.clear();
    await loadUser();
    DateTime now = DateTime.now();
    scheduledWorkouts.clear();
    List<ScheduledWorkout> tempScheduledWorkout =
        await scheduledWorkoutRepository.getAllScheduledWorkoutFromUserId(
            uid: userMaster!.UM_ID);
    for (var userScheduledWorkout in tempScheduledWorkout) {
      if (now
              .difference(
                  DateTime.parse(userScheduledWorkout.sw_scheduledForDate))
              .inDays <
          1) {
        if (!scheduledWorkouts.contains(userScheduledWorkout)) {
          scheduledWorkouts.add(userScheduledWorkout);
        }
      }
    }
    scheduledWorkouts = scheduledWorkouts.toList();
    context.loaderOverlay.hide();
    setState(() {});
  }

  WorkoutsRepository workoutsRepository = WorkoutsRepository();
  TonningWorkoutsRepository tonningWorkoutsRepository =
      TonningWorkoutsRepository();
  ToningExercisesRepository toningExercisesRepository =
      ToningExercisesRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();

/*  Future<void> showNotificationForWorkout({required int id,required String title,required String body,required String payload, required String startDate})async{
    StorageHandler storageHandler = StorageHandler();
    String imageUrl =await storageHandler.getImageUrl(workOuts!.ws_image);
    await AwesomeNotifications().createNotification(
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
        schedule: NotificationCalendar.fromDate(date: DateTime.parse(startDate).add(Duration(hours: 6)),allowWhileIdle: true));
  }*/

  String currentDate = "";
  String previousDate = "";

  @override
  void initState() {
    super.initState();
    loadUser();
    loadUserScheduleWorkouts();
    loadWorkout();
    loadExercise();
    loadToning();
    loadCategories();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.loaderOverlay.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        key: scaffoldKey,
        // backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            "${getTranslated(context, 'schedule_workout')}",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5!.color),
          ),
          elevation: 0.0,
          // backgroundColor: Colors.transparent,
          toolbarHeight: 70,
        ),
        body: scheduledWorkouts.isEmpty
            ? Container()
            : ListView.builder(
                itemBuilder: (context, index) {
                  ScheduledWorkout scheduledWorkout0 =
                      scheduledWorkouts.elementAt(index);
                  String refType =
                      scheduledWorkout0.REF_TYPE.trim().toLowerCase();
                  return FutureBuilder(
                    future: refType == "workout"
                        ? workoutsRepository.getWorkoutsFromId(
                            uid: scheduledWorkout0.REF_ID)
                        : refType == "banner"
                            ? tonningWorkoutsRepository
                                .getTonningWorkoutsModelFromId(
                                    uid: scheduledWorkout0.REF_ID)
                            : refType == "category"
                                ? categoryRepository.getCategoryFromId(
                                    uid: scheduledWorkout0.REF_ID)
                                : exercisesRepository.getExercisesFromId(
                                    uid: scheduledWorkout0.REF_ID),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot2) {
                      if (snapshot2.hasData) {
                        previousDate = currentDate;
                        currentDate = scheduledWorkout0.sw_scheduledForDate;
                        String refType =
                            scheduledWorkout0.REF_TYPE.trim().toLowerCase();
                        if (refType == 'workout') {
                          Workouts workout = snapshot2.data;
                          return Column(
                            children: [
                              previousDate == "" || currentDate != previousDate
                                  ? getDateTag(DateTime.parse(currentDate), "")
                                  : Container(),
                              getNotificationContainer(
                                image: workout.ws_image,
                                heading: workout.ws_name,
                                subText: scheduledWorkout0.sw_scheduledForDate,
                                icon: scheduledWorkout0.sw_isActive
                                    ? Icons.check
                                    : Icons.info_outline,
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              height: 150,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${getTranslated(context, 'are_change_scheduled')}"),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          scheduleWorkout(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'yes')}"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'no')}"),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      });
                                },
                              ),
                            ],
                          );
                        } else if (refType == 'banner') {
                          TonningWorkoutsModel workout = snapshot2.data;
                          return Column(
                            children: [
                              previousDate == "" || currentDate != previousDate
                                  ? getDateTag(DateTime.parse(currentDate), "")
                                  : Container(),
                              getNotificationContainer(
                                image: workout.tWs_image,
                                heading: workout.tWs_name,
                                subText: scheduledWorkout0.sw_scheduledForDate,
                                icon: scheduledWorkout0.sw_isActive
                                    ? Icons.check
                                    : Icons.info_outline,
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              height: 150,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${getTranslated(context, 'are_change_scheduled')}"),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          scheduleBannerWorkout(
                                                              context);

                                                          /*  print(scheduledWorkout0);
                                                if (!userMasterWorkout!.um_ws_Is_Completed
                                                    && currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
                                                ) {
                                                  List<Exercises> exercises = [];

                                                  List<Exercises> tempExercises =
                                                  await exercisesRepository.getAllExercisesByCSID(
                                                      CS_ID: userMasterWorkout!
                                                          .um_ws_activeCategoryId);
                                                  for (var tempExercise in tempExercises) {
                                                    if (!exercises.contains(tempExercise)) {
                                                      exercises.add(tempExercise);
                                                    }
                                                  }
                                                  Exercises activeExercise =
                                                  await exercisesRepository.getExercisesFromId(
                                                      uid: userMasterWorkout!
                                                          .um_ws_activeExerciseId);
                                                  if (!mounted) return;
                                                  await Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) {
                                                        return RunningWorkoutScreen(
                                                          exercises: exercises,
                                                          activeExercise: activeExercise,
                                                          userMasterWorkout: userMasterWorkout!,
                                                        );
                                                      })).then((value) async {
                                                    await loadUserScheduleWorkouts();
                                                  });
                                                }*/
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'yes')}"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'no')}"),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      });

                                  // print(currentDate);
                                  // print(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                  // print(currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());

                                  /* print(scheduledWorkout0);
                            if (!userMasterWorkout!.um_ws_Is_Completed
                                && currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
                                ) {
                              List<Exercises> exercises = [];

                              List<Exercises> tempExercises =
                                  await exercisesRepository.getAllExercisesByCSID(
                                      CS_ID: userMasterWorkout!
                                          .um_ws_activeCategoryId);
                              for (var tempExercise in tempExercises) {
                                if (!exercises.contains(tempExercise)) {
                                  exercises.add(tempExercise);
                                }
                              }
                              Exercises activeExercise =
                                  await exercisesRepository.getExercisesFromId(
                                      uid: userMasterWorkout!
                                          .um_ws_activeExerciseId);
                              if (!mounted) return;
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RunningWorkoutScreen(
                                  exercises: exercises,
                                  activeExercise: activeExercise,
                                  userMasterWorkout: userMasterWorkout!,
                                );
                              })).then((value) async {
                                await loadUserScheduleWorkouts();
                              });
                            }*/
                                },
                              ),
                            ],
                          );
                        } else if (refType == 'category') {
                          Categories category = snapshot2.data;
                          return Column(
                            children: [
                              previousDate == "" || currentDate != previousDate
                                  ? getDateTag(DateTime.parse(currentDate), "")
                                  : Container(),
                              getNotificationContainer(
                                image: category.cs_image,
                                heading: category.cs_name,
                                subText: scheduledWorkout0.sw_scheduledForDate,
                                icon: scheduledWorkout0.sw_isActive
                                    ? Icons.check
                                    : Icons.info_outline,
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              height: 150,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${getTranslated(context, 'are_change_scheduled')}"),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          scheduleCategories(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'yes')}"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'no')}"),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      });

                                  // print(currentDate);
                                  // print(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                  // print(currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());

                                  /* print(scheduledWorkout0);
                            if (!userMasterWorkout!.um_ws_Is_Completed
                                && currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
                                ) {
                              List<Exercises> exercises = [];

                              List<Exercises> tempExercises =
                                  await exercisesRepository.getAllExercisesByCSID(
                                      CS_ID: userMasterWorkout!
                                          .um_ws_activeCategoryId);
                              for (var tempExercise in tempExercises) {
                                if (!exercises.contains(tempExercise)) {
                                  exercises.add(tempExercise);
                                }
                              }
                              Exercises activeExercise =
                                  await exercisesRepository.getExercisesFromId(
                                      uid: userMasterWorkout!
                                          .um_ws_activeExerciseId);
                              if (!mounted) return;
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RunningWorkoutScreen(
                                  exercises: exercises,
                                  activeExercise: activeExercise,
                                  userMasterWorkout: userMasterWorkout!,
                                );
                              })).then((value) async {
                                await loadUserScheduleWorkouts();
                              });
                            }*/
                                },
                              ),
                            ],
                          );
                        } else {
                          Exercises exercise = snapshot2.data;
                          return Column(
                            children: [
                              previousDate == "" || currentDate != previousDate
                                  ? getDateTag(DateTime.parse(currentDate), "")
                                  : Container(),
                              getNotificationContainer(
                                image: exercise.es_image,
                                heading: exercise.es_name,
                                subText: scheduledWorkout0.sw_scheduledForDate,
                                icon: scheduledWorkout0.sw_isActive
                                    ? Icons.check
                                    : Icons.info_outline,
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              height: 150,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${getTranslated(context, 'are_change_scheduled')}"),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          scheduleExercise(
                                                              context);

                                                          // print(scheduledWorkout0);
                                                          // if (!userMasterWorkout!.um_ws_Is_Completed
                                                          //     && currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
                                                          // ) {
                                                          //   List<Exercises> exercises = [];
                                                          //
                                                          //   List<Exercises> tempExercises =
                                                          //   await exercisesRepository.getAllExercisesByCSID(
                                                          //       CS_ID: userMasterWorkout!
                                                          //           .um_ws_activeCategoryId);
                                                          //   for (var tempExercise in tempExercises) {
                                                          //     if (!exercises.contains(tempExercise)) {
                                                          //       exercises.add(tempExercise);
                                                          //     }
                                                          //   }
                                                          //   Exercises activeExercise =
                                                          //   await exercisesRepository.getExercisesFromId(
                                                          //       uid: userMasterWorkout!
                                                          //           .um_ws_activeExerciseId);
                                                          //   if (!mounted) return;
                                                          //   await Navigator.push(context,
                                                          //       MaterialPageRoute(builder: (context) {
                                                          //         return RunningWorkoutScreen(
                                                          //           exercises: exercises,
                                                          //           activeExercise: activeExercise,
                                                          //           userMasterWorkout: userMasterWorkout!,
                                                          //         );
                                                          //       })).then((value) async {
                                                          //     await loadUserScheduleWorkouts();
                                                          //   });
                                                          // }
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'yes')}"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${getTranslated(context, 'no')}"),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      });

                                  // print(currentDate);
                                  // print(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                  // print(currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());

                                  /* print(scheduledWorkout0);
                            if (!userMasterWorkout!.um_ws_Is_Completed
                                && currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
                                ) {
                              List<Exercises> exercises = [];

                              List<Exercises> tempExercises =
                                  await exercisesRepository.getAllExercisesByCSID(
                                      CS_ID: userMasterWorkout!
                                          .um_ws_activeCategoryId);
                              for (var tempExercise in tempExercises) {
                                if (!exercises.contains(tempExercise)) {
                                  exercises.add(tempExercise);
                                }
                              }
                              Exercises activeExercise =
                                  await exercisesRepository.getExercisesFromId(
                                      uid: userMasterWorkout!
                                          .um_ws_activeExerciseId);
                              if (!mounted) return;
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RunningWorkoutScreen(
                                  exercises: exercises,
                                  activeExercise: activeExercise,
                                  userMasterWorkout: userMasterWorkout!,
                                );
                              })).then((value) async {
                                await loadUserScheduleWorkouts();
                              });
                            }*/
                                },
                              ),
                            ],
                          );
                        }
                      }
                      return Container();
                    },
                  );
                },
                itemCount: scheduledWorkouts.length,
              ),
      ),
    );
  }

  Widget getDateTag(DateTime date, String text) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 15.0, bottom: 15.0, top: 15.0, right: 15.0),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(DateFormat('MMMM, dd yyyy').format(date).toUpperCase())),
          Text(text)
        ],
      ),
    );
  }

  Widget getNotificationContainer(
      {required String image,
      required String heading,
      required String subText,
      required IconData icon,
      required dynamic onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        onTap: onTap,
        tileColor: Theme.of(context).disabledColor.withOpacity(0.11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FutureBuilder(
              future: storageHandler.getImageUrl(image),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return CachedNetworkImage(
                  imageUrl: snapshot.data != null && snapshot.data != ''
                      ? snapshot.data!
                      : Constants.loaderUrl,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 50,
                );
              },
              initialData: Constants.loaderUrl,
            )),
        trailing: Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
                // color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(25.0)),
            child: Center(
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onTap,
                icon: Icon(
                  icon,
                  size: 15.0,
                  // color: Colors.white,
                ),
              ),
            )),
        title: Row(
          children: [Expanded(child: Text(heading))],
        ),
        subtitle: Row(
          children: [
            Container(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 10.0, top: 5.0, bottom: 5.0),
                /*decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(10.0)),*/
                child: Text(
                  subText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }

  Widget getDayContainerForWorkouts(
      {required String header,
      required bool isCompleted,
      required String footer,
      required int containerIndex,
      required dynamic setState}) {
    return InkWell(
      onTap: () {
        if (scheduledWorkoutDays.contains(int.parse(footer))) {
          scheduledWorkoutDays.remove(int.parse(footer));
        } else {
          scheduledWorkoutDays.add(int.parse(footer));
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
              child: scheduledWorkoutDays.contains(int.parse(footer))
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

  Widget getDayContainerExercise(
      {required String header,
      required bool isCompleted,
      required String footer,
      required int containerIndex,
      required dynamic setState}) {
    return InkWell(
      onTap: () {
        if (scheduledExerciseDays.contains(int.parse(footer))) {
          scheduledExerciseDays.remove(int.parse(footer));
        } else {
          scheduledExerciseDays.add(int.parse(footer));
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
              child: scheduledExerciseDays.contains(int.parse(footer))
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

  Widget getDayContainerToningWorkout(
      {required String header,
      required bool isCompleted,
      required String footer,
      required int containerIndex,
      required dynamic setState}) {
    return InkWell(
      onTap: () {
        if (scheduledToningWorkoutDays.contains(int.parse(footer))) {
          scheduledToningWorkoutDays.remove(int.parse(footer));
        } else {
          scheduledToningWorkoutDays.add(int.parse(footer));
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
              child: scheduledToningWorkoutDays.contains(int.parse(footer))
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

  Future<void> scheduleWorkout(BuildContext context) async {
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
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "${getTranslated(context, 'schedule_exercise')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            getDayContainerForWorkouts(
                                setState: setState,
                                containerIndex: 1,
                                header: format
                                    .format(startDate)
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledWorkoutDays
                                    .contains(startDate.day),
                                footer: startDate.day.toString()),
                            getDayContainerForWorkouts(
                                setState: setState,
                                containerIndex: 2,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 1)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledWorkoutDays.contains(
                                    startDate.add(const Duration(days: 1)).day),
                                footer: startDate
                                    .add(const Duration(days: 1))
                                    .day
                                    .toString()),
                            getDayContainerForWorkouts(
                                setState: setState,
                                containerIndex: 3,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 2)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledWorkoutDays.contains(
                                    startDate.add(const Duration(days: 2)).day),
                                footer: startDate
                                    .add(const Duration(days: 2))
                                    .day
                                    .toString()),
                            getDayContainerForWorkouts(
                                setState: setState,
                                containerIndex: 4,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 3)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledWorkoutDays.contains(
                                    startDate.add(const Duration(days: 3)).day),
                                footer: startDate
                                    .add(const Duration(days: 3))
                                    .day
                                    .toString()),
                            getDayContainerForWorkouts(
                                setState: setState,
                                containerIndex: 5,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 4)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledWorkoutDays.contains(
                                    startDate.add(const Duration(days: 4)).day),
                                footer: startDate
                                    .add(const Duration(days: 4))
                                    .day
                                    .toString()),
                            getDayContainerForWorkouts(
                                setState: setState,
                                containerIndex: 6,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 5)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledWorkoutDays.contains(
                                    startDate.add(const Duration(days: 5)).day),
                                footer: startDate
                                    .add(const Duration(days: 5))
                                    .day
                                    .toString()),
                            getDayContainerForWorkouts(
                                setState: setState,
                                containerIndex: 7,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 6)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledWorkoutDays.contains(
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
                bottom: 25.0,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 15.0, right: 15.0),
                    child: InkWell(
                      onTap: () async {
                        int index = 0;
                        ScheduledWorkout scheduleWorkouts0 =
                            scheduledWorkouts.elementAt(index);

                        this.context.loaderOverlay.show();
                        DateTime date = DateTime.now();
                        DateFormat format = DateFormat('yyyy-MM');

                        for (int i = 0;
                            i < orgScheduledWorkoutDays.length;
                            i++) {
                          int element = orgScheduledWorkoutDays.elementAt(i);

                          String stringDate = format.format(date);
                          if (element < 10) {
                            stringDate = '$stringDate-0$element';
                          } else {
                            stringDate = '$stringDate-$element';
                          }

                          if (!scheduledWorkoutDays.contains(element)) {
                            int index = 0;
                            Workouts work = workouts.elementAt(index);
                            ScheduledWorkout? scheduleWorkout =
                                await scheduledWorkoutRepository
                                    .getScheduledWorkoutFromUserIdByStartDate(
                                        uid: userMaster!.UM_ID,
                                        refId: work.WS_ID,
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
                              // print("======================================================================");
                              // print(existingMap);
                              // print("======================================================================");
                            }
                          }
                        }
                        for (int i = 0; i < scheduledWorkoutDays.length; i++) {
                          int element = scheduledWorkoutDays[i];
                          String dateString = format.format(date);
                          String tempDay = "";
                          if (element < 10) {
                            tempDay = '0$element';
                          } else {
                            tempDay = '$element';
                          }
                          int index = 0;
                          Workouts work = workouts.elementAt(index);
                          dateString = '$dateString-$tempDay';
                          final result =
                              await scheduledWorkoutRepository.isExist(
                                  uid: userMaster!.UM_ID,
                                  refId: work.WS_ID,
                                  date: dateString);
                          if (!result) {
                            ScheduledWorkout scheduledWorkout =
                                ScheduledWorkout(
                                    SW_ID: scheduleWorkouts0.SW_ID,
                                    UM_ID: userMaster!.UM_ID,
                                    REF_ID: work.WS_ID,
                                    REF_TYPE: 'workout',
                                    sw_scheduledDate:
                                        Constants.getCurrentDate(),
                                    sw_scheduledForDate: dateString,
                                    sw_scheduledTime:
                                        Constants.getCurrentTime(),
                                    sw_isActive: true);
                            scheduledWorkout = await scheduledWorkoutRepository
                                .update(scheduledWorkout: scheduledWorkout);

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
                            // await showNotificationForWorkout(id: id, title: workOuts!.ws_name, body: scheduledWorkout.sw_scheduledForDate, payload: scheduledWorkout.SW_ID, startDate: scheduledWorkout.sw_scheduledForDate);

                            Future<void> showNotificationForWorkout(
                                {required int id,
                                required String title,
                                required String body,
                                required String payload,
                                required String scheduleForDate}) async {
                              StorageHandler storageHandler = StorageHandler();
                              String imageUrl = await storageHandler
                                  .getImageUrl(work.ws_image);
                              // print('SCHEDULED ON :${DateTime.parse(scheduleForDate).add(Duration(hours: 6))}');
                              // await AwesomeNotifications().createNotification(
                              //     content: NotificationContent(
                              //         // icon: "resource://drawable/1.jpg",
                              //         bigPicture: imageUrl,
                              //         largeIcon: imageUrl,
                              //         id: id,
                              //         channelKey: 'basic_channel',
                              //         title: work.ws_name,
                              //         body:
                              //             scheduleWorkouts0.sw_scheduledForDate,
                              //         notificationLayout:
                              //             NotificationLayout.BigPicture,
                              //         // bigPicture: widget.workout.ws_image,
                              //         payload: {
                              //           'uuid': scheduleWorkouts0.SW_ID
                              //         },
                              //         category: NotificationCategory.Reminder
                              //         // autoDismissible: false,
                              //
                              //         ),
                              //     schedule: NotificationCalendar.fromDate(
                              //         date: DateTime.parse(scheduleForDate)
                              //             .add(Duration(hours: 6)),
                              //         allowWhileIdle: true));
                            }

                            if (!orgScheduledWorkoutDays.contains(element)) {
                              orgScheduledWorkoutDays.add(element);
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
                        width: MediaQuery.of(context).size.width - 30.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text(
                          "${getTranslated(context, 'schedule_workout')}",
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

  Future<void> scheduleExercise(BuildContext context) async {
    scaffoldKey.currentState!.showBottomSheet(
        elevation: 0,
        // backgroundColor: Colors.blue.shade50,
        shape: const RoundedRectangleBorder(
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
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "${getTranslated(context, 'schedule_exercise')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 1,
                                header: format
                                    .format(startDate)
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledExerciseDays
                                    .contains(startDate.day),
                                footer: startDate.day.toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 2,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 1)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledExerciseDays.contains(
                                    startDate.add(const Duration(days: 1)).day),
                                footer: startDate
                                    .add(const Duration(days: 1))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 3,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 2)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledExerciseDays.contains(
                                    startDate.add(const Duration(days: 2)).day),
                                footer: startDate
                                    .add(const Duration(days: 2))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 4,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 3)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledExerciseDays.contains(
                                    startDate.add(const Duration(days: 3)).day),
                                footer: startDate
                                    .add(const Duration(days: 3))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 5,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 4)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledExerciseDays.contains(
                                    startDate.add(const Duration(days: 4)).day),
                                footer: startDate
                                    .add(const Duration(days: 4))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 6,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 5)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledExerciseDays.contains(
                                    startDate.add(const Duration(days: 5)).day),
                                footer: startDate
                                    .add(const Duration(days: 5))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 7,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 6)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledExerciseDays.contains(
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
                bottom: 25.0,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 15.0, right: 15.0),
                    child: InkWell(
                      onTap: () async {
                        int index = 0;
                        ScheduledWorkout scheduleWorkout0 =
                            scheduledWorkouts.elementAt(index);

                        this.context.loaderOverlay.show();
                        DateTime date = DateTime.now();
                        DateFormat format = DateFormat('yyyy-MM');

                        for (int i = 0;
                            i < orgScheduledExerciseDays.length;
                            i++) {
                          int element = orgScheduledExerciseDays.elementAt(i);

                          String stringDate = format.format(date);
                          if (element < 10) {
                            stringDate = '$stringDate-0$element';
                          } else {
                            stringDate = '$stringDate-$element';
                          }
                          // print(stringDate);

                          if (!scheduledExerciseDays.contains(element)) {
                            int index = 0;
                            Exercises exe = exercises.elementAt(index);
                            ScheduledWorkout? scheduleWorkout =
                                await scheduledWorkoutRepository
                                    .getScheduledWorkoutFromUserIdByStartDate(
                                        uid: userMaster!.UM_ID,
                                        refId: exe.Es_ID,
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
                          }
                        }
                        for (int i = 0; i < scheduledExerciseDays.length; i++) {
                          int element = scheduledExerciseDays[i];
                          String dateString = format.format(date);
                          String tempDay = "";
                          if (element < 10) {
                            tempDay = '0$element';
                          } else {
                            tempDay = '$element';
                          }

                          int index = 0;
                          Exercises exe = exercises.elementAt(index);

                          dateString = '$dateString-$tempDay';
                          final result =
                              await scheduledWorkoutRepository.isExist(
                                  uid: userMaster!.UM_ID,
                                  refId: exe.Es_ID,
                                  date: dateString);
                          if (!result) {
                            int index = 0;
                            Exercises exe = exercises.elementAt(index);
                            ScheduledWorkout scheduledWorkout =
                                ScheduledWorkout(
                                    SW_ID: scheduleWorkout0.SW_ID,
                                    UM_ID: userMaster!.UM_ID,
                                    REF_ID: exe.Es_ID,
                                    REF_TYPE: 'exercise',
                                    sw_scheduledDate:
                                        Constants.getCurrentDate(),
                                    sw_scheduledForDate: dateString,
                                    sw_scheduledTime:
                                        Constants.getCurrentTime(),
                                    sw_isActive: true);
                            scheduledWorkout = await scheduledWorkoutRepository
                                .update(scheduledWorkout: scheduledWorkout);

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
                            // await showNotificationForWorkout(id: id, title: widget.exercise.es_name, body: scheduledWorkout.sw_scheduledForDate, payload: scheduledWorkout.SW_ID, scheduleForDate: scheduledWorkout.sw_scheduledForDate);

                            Future<void> showNotificationForWorkout(
                                {required int id,
                                required String title,
                                required String body,
                                required String payload,
                                required String scheduleForDate}) async {
                              StorageHandler storageHandler = StorageHandler();
                              String imageUrl = await storageHandler
                                  .getImageUrl(exe.es_image);
                              // print('SCHEDULED ON :${DateTime.parse(scheduleForDate).add(Duration(hours: 6))}');
                              /*await AwesomeNotifications().createNotification(
                                  content: NotificationContent(
                                      // icon: "resource://drawable/1.jpg",
                                      bigPicture: imageUrl,
                                      largeIcon: imageUrl,
                                      id: id,
                                      channelKey: 'basic_channel',
                                      title: exe.es_name,
                                      body:
                                          scheduleWorkout0.sw_scheduledForDate,
                                      notificationLayout:
                                          NotificationLayout.BigPicture,
                                      // bigPicture: widget.workout.ws_image,
                                      payload: {'uuid': scheduleWorkout0.SW_ID},
                                      category: NotificationCategory.Reminder
                                      // autoDismissible: false,

                                      ),
                                  schedule: NotificationCalendar.fromDate(
                                      date: DateTime.parse(scheduleForDate)
                                          .add(Duration(hours: 6)),
                                      allowWhileIdle: true));*/
                            }

                            if (!orgScheduledExerciseDays.contains(element)) {
                              orgScheduledExerciseDays.add(element);
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
                        width: MediaQuery.of(context).size.width - 30.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text(
                          "${getTranslated(context, 'schedule_exercise')}",
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

  Future<void> scheduleCategories(BuildContext context) async {
    scaffoldKey.currentState!.showBottomSheet(
        elevation: 0,
        // backgroundColor: Colors.blue.shade50,
        shape: const RoundedRectangleBorder(
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
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "${getTranslated(context, 'schedule_categories')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 1,
                                header: format
                                    .format(startDate)
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledCategoryDays
                                    .contains(startDate.day),
                                footer: startDate.day.toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 2,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 1)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledCategoryDays.contains(
                                    startDate.add(const Duration(days: 1)).day),
                                footer: startDate
                                    .add(const Duration(days: 1))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 3,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 2)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledCategoryDays.contains(
                                    startDate.add(const Duration(days: 2)).day),
                                footer: startDate
                                    .add(const Duration(days: 2))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 4,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 3)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledCategoryDays.contains(
                                    startDate.add(const Duration(days: 3)).day),
                                footer: startDate
                                    .add(const Duration(days: 3))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 5,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 4)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledCategoryDays.contains(
                                    startDate.add(const Duration(days: 4)).day),
                                footer: startDate
                                    .add(const Duration(days: 4))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 6,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 5)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledCategoryDays.contains(
                                    startDate.add(const Duration(days: 5)).day),
                                footer: startDate
                                    .add(const Duration(days: 5))
                                    .day
                                    .toString()),
                            getDayContainerExercise(
                                setState: setState,
                                containerIndex: 7,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 6)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledCategoryDays.contains(
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
                bottom: 25.0,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 15.0, right: 15.0),
                    child: InkWell(
                      onTap: () async {
                        int index = 0;
                        ScheduledWorkout scheduleWorkout0 =
                            scheduledWorkouts.elementAt(index);

                        this.context.loaderOverlay.show();
                        DateTime date = DateTime.now();
                        DateFormat format = DateFormat('yyyy-MM');

                        for (int i = 0;
                            i < orgScheduledCategoryDays.length;
                            i++) {
                          int element = orgScheduledCategoryDays.elementAt(i);

                          String stringDate = format.format(date);
                          if (element < 10) {
                            stringDate = '$stringDate-0$element';
                          } else {
                            stringDate = '$stringDate-$element';
                          }
                          // print(stringDate);

                          if (!scheduledCategoryDays.contains(element)) {
                            int index = 0;
                            Categories cate = categories.elementAt(index);
                            ScheduledWorkout? scheduleWorkout =
                                await scheduledWorkoutRepository
                                    .getScheduledWorkoutFromUserIdByStartDate(
                                        uid: userMaster!.UM_ID,
                                        refId: cate.CS_ID,
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
                          }
                        }
                        for (int i = 0; i < scheduledCategoryDays.length; i++) {
                          int element = scheduledCategoryDays[i];
                          String dateString = format.format(date);
                          String tempDay = "";
                          if (element < 10) {
                            tempDay = '0$element';
                          } else {
                            tempDay = '$element';
                          }

                          int index = 0;
                          Categories cate = categories.elementAt(index);

                          dateString = '$dateString-$tempDay';
                          final result =
                              await scheduledWorkoutRepository.isExist(
                                  uid: userMaster!.UM_ID,
                                  refId: cate.CS_ID,
                                  date: dateString);
                          if (!result) {
                            int index = 0;
                            Categories cate = categories.elementAt(index);
                            ScheduledWorkout scheduledWorkout =
                                ScheduledWorkout(
                                    SW_ID: scheduleWorkout0.SW_ID,
                                    UM_ID: userMaster!.UM_ID,
                                    REF_ID: cate.CS_ID,
                                    REF_TYPE: cate.cs_name,
                                    sw_scheduledDate:
                                        Constants.getCurrentDate(),
                                    sw_scheduledForDate: dateString,
                                    sw_scheduledTime:
                                        Constants.getCurrentTime(),
                                    sw_isActive: true);
                            scheduledWorkout = await scheduledWorkoutRepository
                                .update(scheduledWorkout: scheduledWorkout);

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
                            // await showNotificationForWorkout(id: id, title: widget.exercise.es_name, body: scheduledWorkout.sw_scheduledForDate, payload: scheduledWorkout.SW_ID, scheduleForDate: scheduledWorkout.sw_scheduledForDate);

                            Future<void> showNotificationForWorkout(
                                {required int id,
                                required String title,
                                required String body,
                                required String payload,
                                required String scheduleForDate}) async {
                              StorageHandler storageHandler = StorageHandler();
                              String imageUrl = await storageHandler
                                  .getImageUrl(cate.cs_image);
                              // print('SCHEDULED ON :${DateTime.parse(scheduleForDate).add(Duration(hours: 6))}');
                          /*    await AwesomeNotifications().createNotification(
                                  content: NotificationContent(
                                      // icon: "resource://drawable/1.jpg",
                                      bigPicture: imageUrl,
                                      largeIcon: imageUrl,
                                      id: id,
                                      channelKey: 'basic_channel',
                                      title: cate.cs_name,
                                      body:
                                          scheduleWorkout0.sw_scheduledForDate,
                                      notificationLayout:
                                          NotificationLayout.BigPicture,
                                      // bigPicture: widget.workout.ws_image,
                                      payload: {'uuid': scheduleWorkout0.SW_ID},
                                      category: NotificationCategory.Reminder
                                      // autoDismissible: false,

                                      ),
                                  schedule: NotificationCalendar.fromDate(
                                      date: DateTime.parse(scheduleForDate)
                                          .add(Duration(hours: 6)),
                                      allowWhileIdle: true));*/
                            }

                            if (!orgScheduledCategoryDays.contains(element)) {
                              orgScheduledCategoryDays.add(element);
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
                        width: MediaQuery.of(context).size.width - 30.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text(
                          "${getTranslated(context, 'schedule_categories')}",
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

  Future<void> scheduleBannerWorkout(BuildContext context) async {
    scaffoldKey.currentState!.showBottomSheet(
        elevation: 0,
        // backgroundColor: Colors.blue.shade50,
        shape: const RoundedRectangleBorder(
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
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "${getTranslated(context, 'schedule_toning_workout')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            getDayContainerToningWorkout(
                                setState: setState,
                                containerIndex: 1,
                                header: format
                                    .format(startDate)
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledToningWorkoutDays
                                    .contains(startDate.day),
                                footer: startDate.day.toString()),
                            getDayContainerToningWorkout(
                                setState: setState,
                                containerIndex: 2,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 1)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledToningWorkoutDays
                                    .contains(startDate
                                        .add(const Duration(days: 1))
                                        .day),
                                footer: startDate
                                    .add(const Duration(days: 1))
                                    .day
                                    .toString()),
                            getDayContainerToningWorkout(
                                setState: setState,
                                containerIndex: 3,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 2)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledToningWorkoutDays
                                    .contains(startDate
                                        .add(const Duration(days: 2))
                                        .day),
                                footer: startDate
                                    .add(const Duration(days: 2))
                                    .day
                                    .toString()),
                            getDayContainerToningWorkout(
                                setState: setState,
                                containerIndex: 4,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 3)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledToningWorkoutDays
                                    .contains(startDate
                                        .add(const Duration(days: 3))
                                        .day),
                                footer: startDate
                                    .add(const Duration(days: 3))
                                    .day
                                    .toString()),
                            getDayContainerToningWorkout(
                                setState: setState,
                                containerIndex: 5,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 4)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledToningWorkoutDays
                                    .contains(startDate
                                        .add(const Duration(days: 4))
                                        .day),
                                footer: startDate
                                    .add(const Duration(days: 4))
                                    .day
                                    .toString()),
                            getDayContainerToningWorkout(
                                setState: setState,
                                containerIndex: 6,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 5)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledToningWorkoutDays
                                    .contains(startDate
                                        .add(const Duration(days: 5))
                                        .day),
                                footer: startDate
                                    .add(const Duration(days: 5))
                                    .day
                                    .toString()),
                            getDayContainerToningWorkout(
                                setState: setState,
                                containerIndex: 7,
                                header: format
                                    .format(
                                        startDate.add(const Duration(days: 6)))
                                    .toString()
                                    .substring(0, 1),
                                isCompleted: scheduledToningWorkoutDays
                                    .contains(startDate
                                        .add(const Duration(days: 6))
                                        .day),
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
                bottom: 25.0,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 15.0, right: 15.0),
                    child: InkWell(
                      onTap: () async {
                        int index = 0;
                        ScheduledWorkout scheduleWorkout0 =
                            scheduledWorkouts.elementAt(index);

                        this.context.loaderOverlay.show();
                        DateTime date = DateTime.now();
                        DateFormat format = DateFormat('yyyy-MM');

                        for (int i = 0;
                            i < orgScheduledToningWorkoutDays.length;
                            i++) {
                          int element =
                              orgScheduledToningWorkoutDays.elementAt(i);

                          String stringDate = format.format(date);
                          if (element < 10) {
                            stringDate = '$stringDate-0$element';
                          } else {
                            stringDate = '$stringDate-$element';
                          }
                          // print(stringDate);

                          if (!scheduledToningWorkoutDays.contains(element)) {
                            int index = 0;
                            TonningWorkoutsModel toning =
                                toningWorkouts.elementAt(index);
                            ScheduledWorkout? scheduleWorkout =
                                await scheduledWorkoutRepository
                                    .getScheduledWorkoutFromUserIdByStartDate(
                                        uid: userMaster!.UM_ID,
                                        refId: toning.TWS_ID,
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
                          }
                        }

                        for (int i = 0;
                            i < scheduledToningWorkoutDays.length;
                            i++) {
                          int element = scheduledToningWorkoutDays[i];
                          String dateString = format.format(date);
                          String tempDay = "";
                          if (element < 10) {
                            tempDay = '0$element';
                          } else {
                            tempDay = '$element';
                          }

                          int index = 0;
                          TonningWorkoutsModel toning =
                              toningWorkouts.elementAt(index);

                          dateString = '$dateString-$tempDay';
                          final result =
                              await scheduledWorkoutRepository.isExist(
                                  uid: userMaster!.UM_ID,
                                  refId: toning.TWS_ID,
                                  date: dateString);
                          if (!result) {
                            int index = 0;
                            TonningWorkoutsModel toning =
                                toningWorkouts.elementAt(index);
                            ScheduledWorkout scheduledWorkout =
                                ScheduledWorkout(
                                    SW_ID: scheduleWorkout0.SW_ID,
                                    UM_ID: userMaster!.UM_ID,
                                    REF_ID: toning.TWS_ID,
                                    REF_TYPE: 'banner',
                                    sw_scheduledDate:
                                        Constants.getCurrentDate(),
                                    sw_scheduledForDate: dateString,
                                    sw_scheduledTime:
                                        Constants.getCurrentTime(),
                                    sw_isActive: true);
                            scheduledWorkout = await scheduledWorkoutRepository
                                .update(scheduledWorkout: scheduledWorkout);

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
                            // await showNotificationForWorkout(id: id, title: widget.exercise.es_name, body: scheduledWorkout.sw_scheduledForDate, payload: scheduledWorkout.SW_ID, scheduleForDate: scheduledWorkout.sw_scheduledForDate);

                            Future<void> showNotificationForWorkout(
                                {required int id,
                                required String title,
                                required String body,
                                required String payload,
                                required String scheduleForDate}) async {
                              StorageHandler storageHandler = StorageHandler();
                              String imageUrl = await storageHandler
                                  .getImageUrl(toning.tWs_image);
                              // print('SCHEDULED ON :${DateTime.parse(scheduleForDate).add(Duration(hours: 6))}');
                         /*     await AwesomeNotifications().createNotification(
                                  content: NotificationContent(
                                      // icon: "resource://drawable/1.jpg",
                                      bigPicture: imageUrl,
                                      largeIcon: imageUrl,
                                      id: id,
                                      channelKey: 'basic_channel',
                                      title: toning.tWs_name,
                                      body:
                                          scheduleWorkout0.sw_scheduledForDate,
                                      notificationLayout:
                                          NotificationLayout.BigPicture,
                                      // bigPicture: widget.workout.ws_image,
                                      payload: {'uuid': scheduleWorkout0.SW_ID},
                                      category: NotificationCategory.Reminder
                                      // autoDismissible: false,

                                      ),
                                  schedule: NotificationCalendar.fromDate(
                                      date: DateTime.parse(scheduleForDate)
                                          .add(Duration(hours: 6)),
                                      allowWhileIdle: true));*/
                            }

                            if (!orgScheduledToningWorkoutDays
                                .contains(element)) {
                              orgScheduledToningWorkoutDays.add(element);
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
                        width: MediaQuery.of(context).size.width - 30.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text(
                          "${getTranslated(context, 'schedule_toning_workout')}",
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
}
