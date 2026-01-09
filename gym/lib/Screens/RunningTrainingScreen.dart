import 'dart:async';

import '../firebase/DB/Models/Exercises.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/Storage/StorageHandler.dart';

class RunningTrainingScreen extends StatefulWidget {
  final List<Exercises> exercises;
  final Exercises activeExercise;
  final UserMasterWorkout userMasterWorkout;

  const RunningTrainingScreen(
      {Key? key,
      required this.exercises,
      required this.activeExercise,
      required this.userMasterWorkout})
      : super(key: key);

  static const String route = "RunningTrainingScreen";

  // static const String route = "/";
  @override
  State<RunningTrainingScreen> createState() => _RunningTrainingScreenState();
}

class _RunningTrainingScreenState extends State<RunningTrainingScreen>
    with SingleTickerProviderStateMixin {
  StorageHandler storageHandler = StorageHandler();
  String loaderUrl =
      "https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc";
  String loaderUrl2 =
      "https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa";

  ExercisesRepository exercisesRepository = ExercisesRepository();
  UserMasterWorkoutRepository userMasterWorkoutRepository =
      UserMasterWorkoutRepository();

  // Exercises? exercise;
  int initialExerciseNum = 1;
  Exercises? activeExercise;
  List<Exercises> exercises = [];

  Timer? updateTimeTimer;

  Timer? timer;
  String displayTime = "";
  String displayMinutes = "";
  String displaySeconds = "00";
  int seconds = 0;
  int minutes = 0;

  bool isWorkoutCompleted = false;

  @override
  void initState() {
    super.initState();
    initialExerciseNum =
        getIndexNumber(widget.exercises, widget.activeExercise) + 1;

    activeExercise = widget.activeExercise;
    exercises = widget.exercises;
    // displayMinutes = activeExercise!.es_duration;
    displayMinutes = Constants.getCurrentExerciseSpentTime(
        time: widget.userMasterWorkout.um_ws_currentExerciseResumeTime)['m'];
    displaySeconds = Constants.getCurrentExerciseSpentTime(
        time: widget.userMasterWorkout.um_ws_currentExerciseResumeTime)['s'];
    /*minutes = 0;
    seconds =15;*/
    minutes = int.parse(displayMinutes);
    seconds = int.parse(displaySeconds);
    String tempTime;
    if (seconds < 10) {
      if (minutes < 10) {
        tempTime = "0$minutes:0$seconds";
      } else {
        tempTime = "$minutes:0$seconds";
      }
    } else {
      if (minutes < 10) {
        tempTime = "0$minutes:$seconds";
      } else {
        tempTime = "$minutes:$seconds";
      }
    }
    displayTime = tempTime;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          displayTime = updateTime();
        });
      });
      updateTimeTimer =
          Timer.periodic(const Duration(minutes: 1), (timer) async {
        await saveActiveExerciseRunningTime();
      });
    });
    // loadExercises();
  }

  String updateTime() {
    String tempTime = "";

    if (seconds == 1 && minutes == 0) {
      seconds = 0;
      timer!.cancel();
      updateTimeTimer!.cancel();
      int index = getIndexNumber(exercises, activeExercise!);

      if (index + 1 == exercises.length) {
        updateUserMasterWorkout(widget.userMasterWorkout);
        updateActiveExerciseId(widget.userMasterWorkout, activeExercise);
        FlutterRingtonePlayer.playNotification();
        setState(() {
          isWorkoutCompleted = true;
        });
      } else {
        activeExercise = exercises.elementAt(index + 1);
        updateActiveExerciseId(widget.userMasterWorkout, activeExercise);
        initialExerciseNum = (index + 1) + 1;
        displayMinutes = activeExercise!.es_duration;
        minutes = int.parse(displayMinutes);
        saveActiveExerciseRunningTime();
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            displayTime = updateTime();
          });
        });
      }
    } else if (seconds == 00) {
      seconds = 59;
      minutes = minutes - 1;
    } else {
      seconds = seconds - 1;
    }

    if (seconds < 10) {
      if (minutes < 10) {
        tempTime = "0$minutes:0$seconds";
      } else {
        tempTime = "$minutes:0$seconds";
      }
    } else {
      if (minutes < 10) {
        tempTime = "0$minutes:$seconds";
      } else {
        tempTime = "$minutes:$seconds";
      }
    }
    return tempTime;
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
    updateTimeTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.exercises.isEmpty
          ? Container()
          : Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Training $initialExerciseNum/${widget.exercises.length}',
                              style: const TextStyle(fontSize: 24.0),
                            ),
                            Text(
                                "${activeExercise!.es_duration} ${activeExercise!.es_durationin.substring(0, 3)}",
                                style: const TextStyle(fontSize: 24.0))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2.1,
                              width: MediaQuery.of(context).size.width - 40.0,
                              child: FutureBuilder(
                                future: storageHandler
                                    .getImageUrl(activeExercise!.es_image),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  return CachedNetworkImage(
                                      imageUrl: snapshot.data != null &&
                                              snapshot.data != ''
                                          ? snapshot.data!
                                          : loaderUrl2,
                                      fit: BoxFit.fill);
                                },
                                initialData:
                                    'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  displayTime,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 38.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  !isWorkoutCompleted
                                      ? activeExercise!.es_name
                                      : "Workout is complete!",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 35.0),
                        //   child: Row(
                        //     children: const [
                        //       /*Expanded(
                        //   child: Text(
                        //     'Next Exercise',
                        //     style: TextStyle(
                        //         fontSize: 12.0, fontWeight: FontWeight.bold),
                        //   ),
                        // )*/
                        //     ],
                        //   ),
                        // ),

                        initialExerciseNum < exercises.length
                            ? getTileContainer(
                                imagePath: exercises
                                    .elementAt(initialExerciseNum)
                                    .es_image,
                                text: exercises
                                    .elementAt(initialExerciseNum)
                                    .es_name,
                                subText:
                                    '${exercises.elementAt(initialExerciseNum).es_duration} ${exercises.elementAt(initialExerciseNum).es_durationin}',
                                iconData: Icons.info_outline,
                                onTap: () {})
                            : Container()
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 10.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !isWorkoutCompleted
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: InkWell(
                                  onTap: () async {
                                    if (timer!.isActive) {
                                      timer!.cancel();
                                      updateTimeTimer!.cancel();
                                      await saveActiveExerciseRunningTime();
                                      setState(() {});
                                    } else {
                                      timer = Timer.periodic(
                                          const Duration(seconds: 1), (timer) {
                                        setState(() {
                                          displayTime = updateTime();
                                        });
                                      });
                                      updateTimeTimer = Timer.periodic(
                                          const Duration(minutes: 1),
                                          (timer) async {
                                        await saveActiveExerciseRunningTime();
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                        30),
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.lightBlue[900]!),
                                        borderRadius:
                                            BorderRadius.circular(40.0)),
                                    child: Text(
                                      timer == null
                                          ? 'Pause'
                                          : timer!.isActive
                                              ? 'Pause'
                                              : 'Play',
                                      style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontSize: 20.0,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                        30),
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue[900],
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(40.0)),
                                    child: const Text(
                                      'Finish',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ))
              ],
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
          top: topPadding, bottom: bottomPadding, left: 0.0, right: 0.0),
      child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FutureBuilder(
                    future: storageHandler.getImageUrl(imagePath),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return CachedNetworkImage(
                        imageUrl: snapshot.data != null && snapshot.data != ''
                            ? snapshot.data!
                            : loaderUrl2,
                        fit: BoxFit.contain,
                        width: 80,
                        height: 50,
                      );
                    },
                    initialData:
                        'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
                  ),
                ),
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

  int getIndexNumber(List<Exercises> exercises, Exercises activeExercise) {
    int index = -1;
    if (exercises
        .where((element) => element.Es_ID == activeExercise.Es_ID)
        .isNotEmpty) {
      for (var element in exercises) {
        if (element.Es_ID == activeExercise.Es_ID) {
          index = exercises.indexOf(element);
          break;
        }
      }
    }
    return index;
  }

  Future<void> saveActiveExerciseRunningTime() async {
    UserMasterWorkout temp = widget.userMasterWorkout;
    temp.um_ws_currentExerciseResumeTime = "$minutes:$seconds";
    await userMasterWorkoutRepository.update(userMasterWorkout: temp);
  }

  Future<void> updateUserMasterWorkout(
      UserMasterWorkout userMasterWorkout) async {
    userMasterWorkout.um_ws_Is_Completed = true;
    await userMasterWorkoutRepository.update(
        userMasterWorkout: userMasterWorkout);
  }

  Future<void> updateActiveExerciseId(
      UserMasterWorkout userMasterWorkout, Exercises? activeExercise) async {
    Exercises prevExercise = await exercisesRepository.getExercisesFromId(
        uid: userMasterWorkout.um_ws_activeExerciseId);

    int kalBurned = userMasterWorkout.um_ws_kalBurned;
    int prevExerciseKal = int.parse(prevExercise.es_kal);
    kalBurned += prevExerciseKal;

    String totalSpentTime = userMasterWorkout.um_ws_totalSpentTime;

    List<String> timeList = totalSpentTime.split(":");
    int hour = 0;
    int minute = 0;
    int seconds = 0;
    if (timeList.length == 3) {
      hour = int.parse(timeList[0]);
      minute = int.parse(timeList[1]);
      seconds = int.parse(timeList[2]);
    }

    List<String> exTimeList = prevExercise.es_duration.split(":");
    int exMinute = int.parse(exTimeList[0]);

    if (exMinute == 60) {
      hour++;
    } else if (exMinute > 60) {
      hour++;
      minute = minute + (exMinute % 60);
      if (minute >= 60) {
        hour++;
        minute = minute % 60;
      }
    } else {
      minute = minute + exMinute;
      if (minute >= 60) {
        hour++;
        minute = minute % 60;
      }
    }

    String newTime = "$hour:$minute:$seconds";
    userMasterWorkout.um_ws_totalSpentTime = newTime;
    userMasterWorkout.um_ws_kalBurned = kalBurned;
    userMasterWorkout.um_ws_activeExerciseId = activeExercise!.Es_ID;
    userMasterWorkout.um_ws_currentExerciseResumeTime =
        activeExercise.es_duration;

    await userMasterWorkoutRepository.update(
        userMasterWorkout: userMasterWorkout);
  }
}
