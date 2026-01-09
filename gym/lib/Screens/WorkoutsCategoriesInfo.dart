import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/ExerciseInfoScreen.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Models/Workouts.dart';
import '../firebase/DB/Models/Workouts_Categories.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/Exercises_CategoriesRepository.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/WorkoutsRepository.dart';
import '../firebase/DB/Repo/Workouts_CategoriesRepository.dart';
import '../firebase/Storage/StorageHandler.dart';

import '../firebase/DB/Models/UserMaster.dart';
import '../local/localization/language_constants.dart';
import 'RunningWorkoutScreen.dart';

class WorkoutsCategoriesInfoScreen extends StatefulWidget {
  final Categories category;
  final Workouts currentWorkout;

  const WorkoutsCategoriesInfoScreen(
      {Key? key, required this.category, required this.currentWorkout})
      : super(key: key);

  static const route = 'WorkoutsCategoriesInfoScreen';

  @override
  State<WorkoutsCategoriesInfoScreen> createState() =>
      _WorkoutsCategoriesInfoScreenState();
}

class _WorkoutsCategoriesInfoScreenState
    extends State<WorkoutsCategoriesInfoScreen> {
  StorageHandler storageHandler = StorageHandler();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ExercisesCategoriesRepository exercisesCategoriesRepository =
      ExercisesCategoriesRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();
  WorkoutsRepository workoutsRepository = WorkoutsRepository();
  WorkoutsCategoriesRepository workoutsCategoriesRepository =
      WorkoutsCategoriesRepository();
  UserMasterWorkoutRepository userMasterWorkoutRepository =
      UserMasterWorkoutRepository();
  UserRepository userRepository = UserRepository();

  List<Exercises> exercises = [];
  List<Workouts> workouts = [];
  List<String> workoutsString = [];
  List<String> exercisesString = [];

  // List<String> ca = [];

  UserMaster? userMaster;

  @override
  void initState() {
    super.initState();
    loadUser();
    loadExercises();
    loadWorkoutsCategory();
  }

  /*@override
  void dispose() {
    super.dispose();
    if(context.loaderOverlay.visible){
      context.loaderOverlay.hide();
    }
  }*/
  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user);
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      // context.loaderOverlay.hide();
      setState(() {});
    }
  }

  Future<void> loadExercises() async {
    // print(widget.exercise.Es_ID);
    List exercises = await exercisesRepository.getAllExercisesByCSID(
        CS_ID: widget.category.CS_ID);
    for (var exercise in exercises) {
      if (!this.exercises.contains(exercise)) {
        this.exercises.add(exercise);
        exercisesString.add(exercise.es_name);
      }
    }
    setState(() {});
  }

  Future<void> loadWorkoutsCategory() async {
    // print(widget.exercise.Es_ID);
    List exerciseCate = await workoutsCategoriesRepository
        .getAllWorkoutsCategoriesByCSId(csId: widget.category.CS_ID);
    for (var element in exerciseCate) {
      Workouts workout =
          await workoutsRepository.getWorkoutsFromId(uid: element.WS_ID);
      if (!workouts.contains(workout)) {
        workouts.add(workout);
        workoutsString.add(workout.WS_ID);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () async {
                UserMasterWorkout? userMasterWorkout =
                    await userMasterWorkoutRepository
                        .getUserMasterWorkoutExistForDateIfExistForWorkout(
                            date: Constants.getCurrentDate(),
                            workoutId: widget.currentWorkout.WS_ID,
                            categoryId: widget.category.CS_ID,
                            userId: userMaster!.UM_ID);
                if (userMasterWorkout != null &&
                    userMasterWorkout.um_ws_Is_Completed == true) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green.shade500,
                      content: Text("${getTranslated(context, 'completed')}")));
                  return;
                }
                if (userMasterWorkout == null) {
                  userMasterWorkout = UserMasterWorkout(
                      UM_WS_ID: '',
                      UM_ID: userMaster!.UM_ID,
                      WS_ID: widget.currentWorkout.WS_ID,
                      um_ws_startDate: Constants.getCurrentDate(),
                      um_ws_StartTime: Constants.getCurrentTime(),
                      um_ws_Is_Completed: false,
                      um_ws_activeCategoryId: widget.category.CS_ID,
                      um_ws_activeExerciseId: exercises.first.Es_ID,
                      um_ws_type: 'workout',
                      um_ws_categoryName: widget.category.cs_name,
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
                        uid: userMasterWorkout!.um_ws_activeExerciseId);
                if (!mounted) return;
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return RunningWorkoutScreen(
                    exercises: exercises,
                    activeExercise: activeExercise,
                    userMasterWorkout: userMasterWorkout!,
                  );
                })).then((value) async {
                  // await loadExercises();
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 30.0,
                height: 40.0,
                decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(40.0)),
                child: Text(
                  "${getTranslated(context, 'start_workout')}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      ),
      // backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          widget.category.cs_name,
          style: TextStyle(color: Theme.of(context).textTheme.headline5!.color),
        ),
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                "${getTranslated(context, 'exercises')}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
              child: getExerciseTitle(
                  text: "${getTranslated(context, 'warm_up')}",
                  exercises: 3,
                  minutes: 2),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    Exercises exercise = exercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExerciseInfoScreen(
                                        exercise: exercise,
                                      )));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          // side: BorderSide(color: Colors.grey),
                        ),
                        minVerticalPadding: 15.0,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FutureBuilder(
                            future: storageHandler
                                .getImageUrl(exercise.es_image.toString()),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              return CachedNetworkImage(
                                imageUrl:
                                    snapshot.data != null && snapshot.data != ''
                                        ? snapshot.data!
                                        : Constants.loaderUrl,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 50,
                              );
                            },
                            initialData: Constants.loaderUrl,
                          ),
                        ),
                        title: Text(
                          exercise.es_name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                            "${exercise.es_duration} ${exercise.es_durationin}"),
                        trailing: const Icon(Icons.info_outline),
                      ),
                    );
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
              child: getExerciseTitle(
                  text: "${getTranslated(context, 'workouts')}",
                  exercises: 3,
                  minutes: 2),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    Workouts workout = workouts[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: ListTile(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesInfoScreen(
                          //   exercises: workout,
                          // )));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          // side: BorderSide(color: Colors.grey),
                        ),
                        minVerticalPadding: 15.0,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FutureBuilder(
                            future: storageHandler
                                .getImageUrl(workout.ws_image.toString()),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              return CachedNetworkImage(
                                imageUrl:
                                    snapshot.data != null && snapshot.data != ''
                                        ? snapshot.data!
                                        : Constants.loaderUrl,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 50,
                              );
                            },
                            initialData: Constants.loaderUrl,
                          ),
                        ),
                        title: Text(
                          workout.ws_name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                            "${workout.ws_duration} ${workout.ws_durationin}"),
                        trailing: const Icon(Icons.info_outline),
                      ),
                    );
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
              child: getExerciseTitle(
                  text: 'Stretching', exercises: 3, minutes: 2),
            ),
            getTileContainer(
                imagePath: widget.category.cs_image,
                text: widget.category.cs_name,
                subText: widget.category.cs_type,
                iconData: Icons.info_outline,
                onTap: () {},
                bottomPadding: 10.0),
            // getRestContainer(hour: 00, minutes: 30),
          ],
        ),
      ),
    );
  }

  Widget getExerciseTitle(
      {required String text, required int exercises, required int minutes}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 7.0, right: 7.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 7.0),
                child:
                    Text('$exercises ${getTranslated(context, 'exercises')}'),
              ),
              const Icon(
                Icons.circle,
                size: 7.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Text('$minutes ${getTranslated(context, 'minutes')}'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getRestContainer(
      {required int hour,
      required int minutes,
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
                    child: Image.asset('assets/images/1.jpg',
                        height: 50.0, width: 80.0, fit: BoxFit.fill)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  children: [const Text('Rest'), Text('$hour:$minutes')],
                ),
              )
            ],
          )),
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
          // color: Colors.white,
          padding: const EdgeInsets.only(left: 7.0, right: 7.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FutureBuilder(
                    future:
                        storageHandler.getImageUrl(widget.category.cs_image),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
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
}
