import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/ExerciseInfoScreen.dart';
import '../Screens/RunningWorkoutScreen.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/Trainings_Exercises.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/Trainings_ExercisesRepository.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../Util/Constants.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/Trainings.dart';
import '../firebase/DB/Models/Trainings_Exercises.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/Trainings_ExercisesRepository.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import '../local/localization/language_constants.dart';

class TrainingInfoScreen extends StatefulWidget {
  final Trainings trainings;

  const TrainingInfoScreen({Key? key, required this.trainings})
      : super(key: key);

  static const route = 'TrainingInfoScreen';

  @override
  State<TrainingInfoScreen> createState() => _TrainingInfoScreenState();
}

class _TrainingInfoScreenState extends State<TrainingInfoScreen> {
  StorageHandler storageHandler = StorageHandler();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TrainingsExercisesRepository trainingsExercisesRepository =
      TrainingsExercisesRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();
  UserMasterWorkoutRepository userMasterWorkoutRepository =
      UserMasterWorkoutRepository();

  List<Exercises> exercises = [];
  List<String> exercisesString = [];

  @override
  void initState() {
    super.initState();
    loadUser();
    loadTrainingExercises();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.loaderOverlay.show();
      }
    });
  }

  UserRepository userRepository = UserRepository();
  UserMaster? userMaster;

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user);
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      setState(() {});
    }
  }

  Future<void> loadTrainingExercises() async {
    await loadUser();
    List<TrainingsExercises>? trainingExercises =
        await trainingsExercisesRepository.getAllTrainingsExercisesByTSId(
            tsId: widget.trainings.TS_ID);
    for (var trainingExercise in trainingExercises!) {
      Exercises exercise = await exercisesRepository.getExercisesFromId(
          uid: trainingExercise.ES_ID);
      if (!exercises.contains(exercise)) {
        exercises.add(exercise);
        exercisesString.add(exercise.es_name);
      }
    }
    context.loaderOverlay.hide();
    setState(() {});
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
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () async {
                  UserMasterWorkout? userMasterWorkout =
                      await userMasterWorkoutRepository
                          .getUserMasterWorkoutExistForDateIfExistForTraining(
                    date: Constants.getCurrentDate(),
                    trainingID: widget.trainings.TS_ID,
                    userId: userMaster!.UM_ID,
                  );
                  if (userMasterWorkout != null &&
                      userMasterWorkout.um_ws_Is_Completed == true) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green.shade500,
                        content:
                            Text("${getTranslated(context, 'completed')}")));
                    return;
                  }
                  if (userMasterWorkout == null) {
                    userMasterWorkout = UserMasterWorkout(
                        UM_WS_ID: '',
                        UM_ID: userMaster!.UM_ID,
                        WS_ID: "",
                        um_ws_startDate: Constants.getCurrentDate(),
                        um_ws_StartTime: Constants.getCurrentTime(),
                        um_ws_Is_Completed: false,
                        um_ws_activeCategoryId: "",
                        um_ws_activeExerciseId: exercises.first.Es_ID,
                        um_ws_type: 'training',
                        um_ws_categoryName: "",
                        um_ws_kalBurned: 00,
                        um_ws_totalSpentTime: "",
                        um_ws_currentExerciseResumeTime:
                            '${exercises.first.es_duration}:0',
                        TS_ID: widget.trainings.TS_ID);
                    userMasterWorkout = await userMasterWorkoutRepository.save(
                        userMasterWorkout: userMasterWorkout);
                  }
                  Exercises activeExercise =
                      await exercisesRepository.getExercisesFromId(
                          uid: userMasterWorkout.um_ws_activeExerciseId);
                  if (!mounted) return;
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return RunningWorkoutScreen(
                      exercises: exercises,
                      activeExercise: activeExercise,
                      userMasterWorkout: userMasterWorkout!,
                    );
                  })).then((value) async {
                    //await loadTrainingExercises();
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
                    "${getTranslated(context, 'start_training')}",
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
        ),
        // backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            widget.trainings.ts_name,
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5!.color),
          ),
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Colors.transparent,
        ),
        body: exercises.isEmpty
            ? Container()
            : ListView.builder(
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
                      tileColor:
                          Theme.of(context).disabledColor.withOpacity(0.11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        // side: const BorderSide(color: Colors.grey),
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
    );
  }
}
