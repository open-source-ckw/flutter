// ignore_for_file: file_names

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../Screens/BannerWorkoutsScreen.dart';
import '../Screens/ExerciseInfoScreen.dart';
import '../Screens/RunningTrainingScreen.dart';
import '../Screens/RunningWorkoutScreen.dart';
import '../Screens/TrainingInfoScreen.dart';
import '../Screens/TrainingScreen.dart';
import '../Screens/WorkoutScreen.dart';
import '../firebase/DB/Models/Banner.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/ScheduledWorkout.dart';
import '../firebase/DB/Models/Toning_Exercises.dart';
import '../firebase/DB/Models/Trainings.dart';
import '../firebase/DB/Models/Trainings_Exercises.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Models/User_Fav.dart';
import '../firebase/DB/Models/Workouts.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/Toning_ExercisesRepository.dart';
import '../firebase/DB/Repo/TonningWorkoutsRepository.dart';
import '../firebase/DB/Repo/TrainingRepository.dart';
import '../firebase/DB/Repo/Trainings_ExercisesRepository.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/User_FavRepository.dart';
import '../firebase/DB/Repo/WorkoutsRepository.dart';

import '../firebase/Storage/StorageHandler.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../Util/Constants.dart';
import '../firebase/DB/Repo/Workouts_CategoriesRepository.dart';
import '../local/localization/language_constants.dart';

class MyWorkoutsScreen extends StatefulWidget {
  const MyWorkoutsScreen({Key? key}) : super(key: key);

  static const String route = "MyWorkoutsScreen";

  @override
  State<MyWorkoutsScreen> createState() => _MyWorkoutsScreenState();
}

class _MyWorkoutsScreenState extends State<MyWorkoutsScreen>
    with SingleTickerProviderStateMixin {
  StorageHandler storageHandler = StorageHandler();

  UserRepository userRepository = UserRepository();

  WorkoutsRepository workoutsRepository = WorkoutsRepository();
  TrainingsRepository trainingsRepository = TrainingsRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();

  User_FavRepository userFavRepository = User_FavRepository();

  UserMasterWorkoutRepository userMasterWorkoutRepository =
      UserMasterWorkoutRepository();
  WorkoutsCategoriesRepository workoutCategoryRepository =
      WorkoutsCategoriesRepository();
  TonningWorkoutsRepository tonningWorkoutsRepository =
      TonningWorkoutsRepository();
  ToningExercisesRepository toningExercisesRepository =
      ToningExercisesRepository();

  TrainingsExercisesRepository trainingsExercisesRepository =
      TrainingsExercisesRepository();

  UserMaster? userMaster;
  List<User_Fav> favorites = [];
  List<UserMasterWorkout> userWorkouts = [];
  UserMasterWorkout? deActiveWorkouts;
  ScheduledWorkout? scheduledWorkout;
  Favorite fav = Favorite(
      heading: "", subText: "", icon: Icons.check, image: "", onTap: null);

  late TabController controller;

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
    }
  }

  Future<void> loadUserWorkouts() async {
    // userWorkouts.clear();
    await loadUser();
    userWorkouts.clear();
    List<UserMasterWorkout> tempUserWorkouts = await userMasterWorkoutRepository
        .getAllUserMasterWorkoutFromUserId(uid: userMaster!.UM_ID);
    for (var userWorkout in tempUserWorkouts) {
      if (!userWorkouts.contains(userWorkout)) {
        userWorkouts.add(userWorkout);
      }
    }
    userWorkouts = userWorkouts.toList();
    setState(() {});
  }

  Future<void> loadFavorites() async {
    // favorites.clear();
    await loadUser();
    List<User_Fav> tempUserFavList = await userFavRepository
        .getAllUserMasterWorkoutFromUserId(uid: userMaster!.UM_ID);
    if (tempUserFavList.isNotEmpty) {
      favorites = tempUserFavList;
    }
    setState(() {});
    if (context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
  }

  String displayTime = "";
  String displayMinutes = "";
  String displaySeconds = "00";
  int seconds = 0;
  int minutes = 0;

  // Future<void> resumingWorkout () async{
  //   if(timer!.isActive) {
  //     timer!.cancel();
  //     setState(() {
  //
  //     });
  //   }
  //   else{
  //     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       setState(() {
  //         displayTime = updateTime();
  //       });
  //     });
  //   }
  // }

  String currentDate = "";
  String previousDate = "";

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    loadUser();
    loadUserWorkouts();
    loadFavorites();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.loaderOverlay.show();
    });
  }

  DatabaseReference ref =
      FirebaseDatabase.instance.ref().child("UserMasterWorkout");

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // context.loaderOverlay.show();
  // }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            "${getTranslated(context, 'my_workouts')}",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5!.color),
          ),
          elevation: 0.0,
          // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          toolbarHeight: 70,
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20.0)),
                // padding: const EdgeInsets.only(left: 7,bottom: 10,right: 7,top: 10),
                alignment: Alignment.center,
                child: TabBar(
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                      fontSize: 17,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.grey.shade600,
                  indicator: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(20)),
                  tabs: [
                    Tab(
                      height: 30,
                      text: "${getTranslated(context, 'history')}",
                    ),
                    Tab(
                      height: 30,
                      text: "${getTranslated(context, 'fav')}",
                    ),
                  ],
                  controller: controller,
                ),
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  height: MediaQuery.of(context).size.height - 100.0,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    controller: controller,
                    children: [
                      userMaster == null
                          ? Container()
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                UserMasterWorkout userMasterWorkout =
                                    userWorkouts.elementAt(index);

                                return FutureBuilder(
                                  future: userMasterWorkout.um_ws_type
                                              .trim()
                                              .toLowerCase() ==
                                          'workout'
                                      ? workoutsRepository.getWorkoutsFromId(
                                          uid: userMasterWorkout.WS_ID)
                                      : userMasterWorkout.um_ws_type
                                                  .trim()
                                                  .toLowerCase() ==
                                              "banner"
                                          ? tonningWorkoutsRepository
                                              .getTonningWorkoutsModelFromId(
                                                  uid: userMasterWorkout.WS_ID)
                                          : trainingsRepository
                                              .getTrainingsFromId(
                                                  uid: userMasterWorkout.TS_ID),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot2) {
                                    if (snapshot2.hasData) {
                                      previousDate = currentDate;
                                      currentDate =
                                          userMasterWorkout.um_ws_startDate;

                                      if (userMasterWorkout.um_ws_type
                                              .trim()
                                              .toLowerCase() ==
                                          'workout') {
                                        Workouts workout = snapshot2.data;
                                        return Column(
                                          children: [
                                            previousDate == "" ||
                                                    currentDate != previousDate
                                                ? getDateTag(
                                                    DateTime.parse(currentDate),
                                                    "")
                                                : Container(),
                                            getNotificationContainer(
                                              image: workout.ws_image,
                                              heading: workout.ws_name,
                                              subText:
                                                  '${userMasterWorkout.um_ws_categoryName} ${userMasterWorkout.um_ws_StartTime}',
                                              icon: userMasterWorkout
                                                      .um_ws_Is_Completed
                                                  ? Icons.check
                                                  : Icons.info_outline,
                                              onTap: () async {
                                                // print(currentDate);
                                                // print(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                                // print(currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                                if (!userMasterWorkout
                                                        .um_ws_Is_Completed &&
                                                    currentDate ==
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                DateTime.now())
                                                            .toString()) {
                                                  List<Exercises> exercises =
                                                      [];

                                                  List<Exercises>
                                                      tempExercises =
                                                      await exercisesRepository
                                                          .getAllExercisesByCSID(
                                                              CS_ID: userMasterWorkout
                                                                  .um_ws_activeCategoryId);
                                                  for (var tempExercise
                                                      in tempExercises) {
                                                    if (!exercises.contains(
                                                        tempExercise)) {
                                                      exercises
                                                          .add(tempExercise);
                                                    }
                                                  }
                                                  Exercises activeExercise =
                                                      await exercisesRepository
                                                          .getExercisesFromId(
                                                              uid: userMasterWorkout
                                                                  .um_ws_activeExerciseId);
                                                  if (!mounted) return;
                                                  await Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RunningWorkoutScreen(
                                                      exercises: exercises,
                                                      activeExercise:
                                                          activeExercise,
                                                      userMasterWorkout:
                                                          userMasterWorkout,
                                                    );
                                                  })).then((value) async {
                                                    await loadUserWorkouts();
                                                    await loadFavorites();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      } else if (userMasterWorkout.um_ws_type
                                              .trim()
                                              .toLowerCase() ==
                                          "banner") {
                                        TonningWorkoutsModel workout =
                                            snapshot2.data;
                                        return Column(
                                          children: [
                                            previousDate == "" ||
                                                    currentDate != previousDate
                                                ? getDateTag(
                                                    DateTime.parse(currentDate),
                                                    "")
                                                : Container(),
                                            getNotificationContainer(
                                              image: workout.tWs_image,
                                              heading: workout.tWs_name,
                                              subText: userMasterWorkout
                                                  .um_ws_StartTime,
                                              icon: userMasterWorkout
                                                      .um_ws_Is_Completed
                                                  ? Icons.check
                                                  : Icons.info_outline,
                                              onTap: () async {
                                                if (!userMasterWorkout
                                                        .um_ws_Is_Completed &&
                                                    currentDate ==
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                DateTime.now())
                                                            .toString()) {
                                                  List<Exercises> exercises =
                                                      [];

                                                  List<ToningExercises>
                                                      tempTonningExercises =
                                                      await toningExercisesRepository
                                                          .getAllToningExercisesBytWsId(
                                                              tWsId: workout
                                                                  .TWS_ID);

                                                  for (var tonningExercise
                                                      in tempTonningExercises) {
                                                    Exercises tempExercise =
                                                        await exercisesRepository
                                                            .getExercisesFromId(
                                                                uid:
                                                                    tonningExercise
                                                                        .ES_ID);
                                                    if (!exercises.contains(
                                                        tempExercise)) {
                                                      exercises
                                                          .add(tempExercise);
                                                    }
                                                  }

                                                  Exercises activeExercise =
                                                      await exercisesRepository
                                                          .getExercisesFromId(
                                                              uid: userMasterWorkout
                                                                  .um_ws_activeExerciseId);
                                                  if (!mounted) return;
                                                  await Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RunningWorkoutScreen(
                                                      exercises: exercises,
                                                      activeExercise:
                                                          activeExercise,
                                                      userMasterWorkout:
                                                          userMasterWorkout,
                                                    );
                                                  })).then((value) async {
                                                    await loadUserWorkouts();
                                                    await loadFavorites();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      } else {
                                        Trainings training = snapshot2.data;
                                        return Column(
                                          children: [
                                            previousDate == "" ||
                                                    currentDate != previousDate
                                                ? getDateTag(
                                                    DateTime.parse(currentDate),
                                                    "")
                                                : Container(),
                                            getNotificationContainer(
                                              image: training.ts_image,
                                              heading: training.ts_name,
                                              subText:
                                                  '${userMasterWorkout.um_ws_categoryName} ${userMasterWorkout.um_ws_StartTime}',
                                              icon: userMasterWorkout
                                                      .um_ws_Is_Completed
                                                  ? Icons.check
                                                  : Icons.info_outline,
                                              onTap: () async {
                                                // print(currentDate);
                                                // print(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                                // print(currentDate==DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                                if (!userMasterWorkout
                                                        .um_ws_Is_Completed &&
                                                    currentDate ==
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                DateTime.now())
                                                            .toString()) {
                                                  List<Exercises>
                                                      exercisesTraining = [];
                                                  List<String> exercisesString =
                                                      [];
                                                  List<TrainingsExercises>?
                                                      trainingExercises =
                                                      await trainingsExercisesRepository
                                                          .getAllTrainingsExercisesByESId(
                                                              esId:
                                                                  exercisesTraining
                                                                      .elementAt(
                                                                          index)
                                                                      .Es_ID);

                                                  for (var trainingExercise
                                                      in trainingExercises) {
                                                    Exercises exercise =
                                                        await exercisesRepository
                                                            .getExercisesFromId(
                                                                uid:
                                                                    trainingExercise
                                                                        .ES_ID);
                                                    if (!exercisesTraining
                                                        .contains(exercise)) {
                                                      exercisesTraining
                                                          .add(exercise);
                                                      exercisesString.add(
                                                          exercise.es_name);
                                                    }
                                                  }
                                                  Exercises activeExercise =
                                                      await exercisesRepository
                                                          .getExercisesFromId(
                                                              uid: userMasterWorkout
                                                                  .um_ws_activeExerciseId);
                                                  if (!mounted) return;

                                                  await Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return RunningTrainingScreen(
                                                      exercises:
                                                          exercisesTraining,
                                                      activeExercise:
                                                          activeExercise,
                                                      userMasterWorkout:
                                                          userMasterWorkout,
                                                    );
                                                  })).then((value) async {
                                                    await loadUserWorkouts();
                                                    await loadFavorites();
                                                  });
                                                }
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
                              itemCount: userWorkouts.length,
                            ),
                      ListView.builder(
                          itemBuilder: (context, index) {
                            User_Fav userFav = favorites[index];
                            return FutureBuilder(
                                initialData: fav,
                                future: getData(userFav),
                                builder: (context, snapshot) {
                                  Favorite fav =
                                      snapshot.hasData && snapshot.data != null
                                          ? snapshot.data as Favorite
                                          : this.fav;
                                  return snapshot.hasData
                                      ? getNotificationContainer(
                                          image: fav.image,
                                          heading: fav.heading,
                                          subText: fav.subText,
                                          icon: Icons.favorite,
                                          onTap: fav.onTap)
                                      : Container();
                                });
                          },
                          itemCount: favorites.length),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                  style: const TextStyle(
                      // color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }

  Future<Favorite> getData(User_Fav fav) async {
    String image = "";
    String heading = "";
    IconData icon = Icons.check;
    String subText = "";
    dynamic onTap;

    switch (fav.REF_Type.trim().toLowerCase()) {
      case "workout":
        Workouts workout =
            await workoutsRepository.getWorkoutsFromId(uid: fav.REF_ID);
        heading = workout.ws_name;
        subText = workout.ws_duration;
        image = workout.ws_image;
        onTap = () async {
          await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkoutScreen(workout: workout)))
              .then((value) => loadFavorites());
        };
        break;
      case "training":
        Trainings training =
            await trainingsRepository.getTrainingsFromId(uid: fav.REF_ID);
        heading = training.ts_name;
        subText = training.ts_duration;
        image = training.ts_image;
        onTap = () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TrainingInfoScreen(trainings: training)));
        };
        break;
      case "exercise":
        Exercises exercise =
            await exercisesRepository.getExercisesFromId(uid: fav.REF_ID);
        heading = exercise.es_name;
        subText = exercise.es_duration;
        image = exercise.es_image;
        onTap = () async {
          await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseInfoScreen(exercise: exercise)))
              .then((value) => loadFavorites());
        };
        break;
      case "banner":
        TonningWorkoutsModel? tonningWorkoutsModel =
            await tonningWorkoutsRepository.getTonningWorkoutsModelFromId(
                uid: fav.REF_ID);
        heading = tonningWorkoutsModel.tWs_name;
        subText = tonningWorkoutsModel.tWs_duration;
        image = tonningWorkoutsModel.tWs_image;
        onTap = () async {
          await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BannerWorkoutsScreen(
                          tonningWorkoutsModel: tonningWorkoutsModel)))
              .then((value) => loadFavorites());
        };
        break;
    }
    return Favorite(
        heading: heading,
        subText: subText,
        icon: icon,
        image: image,
        onTap: onTap);
  }
}

class Favorite {
  String image;
  String heading;
  String subText;
  IconData icon;
  dynamic onTap;

  Favorite(
      {required this.heading,
      required this.subText,
      required this.icon,
      required this.image,
      required this.onTap});
}
