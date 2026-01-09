import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../local/localization/language_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/Workouts.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/TonningWorkoutsRepository.dart';
import '../firebase/DB/Repo/TrainingRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/WorkoutsRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Util/Constants.dart';
import '../firebase/DB/Models/Banner.dart';
import '../firebase/DB/Models/Trainings.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/CategoryRepository.dart';
import 'ExerciseInfoScreen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const String route = "SearchScreen";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearchActive = true;

  bool isEmptyText = true;

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  StorageHandler storageHandler = StorageHandler();

  UserRepository userRepository = UserRepository();
  WorkoutsRepository workoutsRepository = WorkoutsRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();
  TonningWorkoutsRepository tonningWorkoutsRepository =
      TonningWorkoutsRepository();
  TrainingsRepository trainingsRepository = TrainingsRepository();
  CategoryRepository categoryRepository = CategoryRepository();

  List<Exercises> usersExFiltered = [];
  List<Workouts> usersWsFiltered = [];
  List<Categories> usersCsFiltered = [];
  List<TonningWorkoutsModel> usersTSWSFiltered = [];
  List<Trainings> usersTSFiltered = [];
  String typedKeyword = "";

  UserMaster? userMaster;
  List<Trainings> trainings = [];
  List<TonningWorkoutsModel> toningWorkout = [];
  List<Categories> categories = [];
  List<Exercises> exercises = [];
  List<Workouts> workouts = [];

  List<Exercises> exerciseMain = [];
  List<Workouts> workoutMain = [];
  List<Trainings> trainingMain = [];
  List<TonningWorkoutsModel> toningMain = [];
  List<Categories> categoryMain = [];

  Future<void> loadTrainings() async {
    List<Trainings> tempTrainings = await trainingsRepository.getAllTrainings();

    // trainings.clear();
    trainings = tempTrainings;
    if (context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
    setState(() {});
  }

  Future<void> loadTonningWorkouts() async {
    List<TonningWorkoutsModel> tempTonningWorkouts =
        await tonningWorkoutsRepository.getAllTonningWorkouts();

    // toningWorkout.clear();
    toningWorkout = tempTonningWorkouts;
    setState(() {});
  }

  Future<void> loadCategories() async {
    List<Categories> tempcategories =
        await categoryRepository.getAllCategories();

    // categories.clear();
    categories = tempcategories;
    setState(() {});
  }

  Future<void> loadExercises() async {
    List<Exercises> tempExercises = await exercisesRepository.getAllExercises();

    // exercises.clear();
    exercises = tempExercises;
    setState(() {});
  }

  Future<void> loadWorkouts() async {
    List<Workouts> tempWorkouts = await workoutsRepository.getAllWorkouts();

    // workouts.clear();
    workouts = tempWorkouts;
    setState(() {});
  }

  // List<Exercises> mainExercise = [];

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isNotEmpty) {
      usersExFiltered = exercises
          .where((e) => e.es_name.toLowerCase().contains(enteredKeyword))
          .toList();
      ;
      usersTSFiltered = trainings
          .where((e) => e.ts_name.toLowerCase().contains(enteredKeyword))
          .toList();
      ;
      usersTSWSFiltered = toningWorkout
          .where((e) => e.tWs_name.toLowerCase().contains(enteredKeyword))
          .toList();
      ;
      usersCsFiltered = categories
          .where((e) => e.cs_name.toLowerCase().contains(enteredKeyword))
          .toList();
      ;
      usersWsFiltered = workouts
          .where((e) => e.ws_name.toLowerCase().contains(enteredKeyword))
          .toList();
    }
    setState(() {});
  }

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    requestSpeechPermission().then((value) async {
      if (value.isNotEmpty) {
        if (value[Permission.speech]!.isGranted) {
          await _speechToText.listen(onResult: _onSpeechResult);
          setState(() {});
        }
      }
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    if (mounted) {
      setState(() {});
    }
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     textEditingController.text = result.recognizedWords;
  //     _lastWords = result.recognizedWords;
  //   });
  // }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    setState(() {
      usersExFiltered = exercises
          .where(
              (e) => e.es_name.toLowerCase().contains(result.recognizedWords))
          .toList();
      ;
      usersTSFiltered = trainings
          .where(
              (e) => e.ts_name.toLowerCase().contains(result.recognizedWords))
          .toList();
      ;
      usersTSWSFiltered = toningWorkout
          .where(
              (e) => e.tWs_name.toLowerCase().contains(result.recognizedWords))
          .toList();
      ;
      usersCsFiltered = categories
          .where(
              (e) => e.cs_name.toLowerCase().contains(result.recognizedWords))
          .toList();
      ;
      usersWsFiltered = workouts
          .where(
              (e) => e.ws_name.toLowerCase().contains(result.recognizedWords))
          .toList();
      textEditingController.text = result.recognizedWords;
      _lastWords = result.recognizedWords;
    });
  }

  bool focusFlag = true;

  int threshold = 50;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadExercises();
    loadWorkouts();
    loadTrainings();
    loadCategories();
    loadTonningWorkouts();
    _initSpeech();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (focusFlag) {
      FocusScope.of(context).requestFocus(focusNode);
      focusFlag = false;
    }

    return LoaderOverlay(
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      useDefaultLoading: false,
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onHorizontalDragDown: (details) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onVerticalDragDown: (details) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            // backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(75.0),
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                automaticallyImplyLeading: false,
                iconTheme:
                    IconThemeData(color: Theme.of(context).iconTheme.color),
                elevation: 0,
                toolbarHeight: 75.0,
                // backgroundColor: Colors.transparent,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isSearchActive
                        ? GestureDetector(
                            onTap: () {
                              // isSearchActive = false;
                              if (MediaQuery.of(context).viewInsets.bottom ==
                                  0) {
                                Navigator.pop(context);
                              } else {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: const BoxDecoration(
                                  // color: Colors.white,
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  // color: Colors.black,
                                  size: 25.0,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(
                        child: AnimatedPadding(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutExpo,
                      padding: EdgeInsets.only(
                          right: Platform.isIOS ? 10.0 : 0.0,
                          left: isSearchActive ? 10.0 : 0.0,
                          top: 15.0,
                          bottom: 15.0),
                      child: OutlineSearchBar(
                        focusNode: focusNode,
                        // backgroundColor: Colors.white,
                        maxHeight: 50.0,
                        borderColor: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        backgroundColor:
                            Theme.of(context).disabledColor.withOpacity(0.14),
                        hintText: "${getTranslated(context, 'search')}",
                        searchButtonPosition: SearchButtonPosition.leading,
                        textEditingController: textEditingController,
                        onTap: () {
                          isSearchActive = true;
                        },
                        onKeywordChanged: (enteredKeyword) {
                          _lastWords = enteredKeyword;
                          typedKeyword = enteredKeyword;
                          // speechWord = enteredKeyword;
                          usersExFiltered = exercises
                              .where((e) => e.es_name
                                  .toLowerCase()
                                  .contains(enteredKeyword))
                              .toList();
                          ;
                          usersTSFiltered = trainings
                              .where((e) => e.ts_name
                                  .toLowerCase()
                                  .contains(enteredKeyword))
                              .toList();
                          ;
                          usersTSWSFiltered = toningWorkout
                              .where((e) => e.tWs_name
                                  .toLowerCase()
                                  .contains(enteredKeyword))
                              .toList();
                          ;
                          usersCsFiltered = categories
                              .where((e) => e.cs_name
                                  .toLowerCase()
                                  .contains(enteredKeyword))
                              .toList();
                          ;
                          usersWsFiltered = workouts
                              .where((e) => e.ws_name
                                  .toLowerCase()
                                  .contains(enteredKeyword))
                              .toList();
                          // textEditingController.text = enteredKeyword;
                          _runFilter(enteredKeyword);
                        },
                        onClearButtonPressed: (enteredKeyword) {
                          setState(() {
                            // isSearchActive=false;
                            typedKeyword = '';
                            _lastWords = '';
                            // speechWord = '';
                            // _textSpeech = '';
                            usersExFiltered.clear();
                            usersWsFiltered.clear();
                            usersCsFiltered.clear();
                            usersTSFiltered.clear();
                            usersTSWSFiltered.clear();
                          });
                        },
                      ),
                    )),
                    IconButton(
                        onPressed: _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                        icon: Icon(_speechToText.isNotListening
                            ? Icons.mic_off
                            : Icons.mic)),
                  ],
                ),
                flexibleSpace: Container(
                    // decoration: BoxDecoration(color: Colors.white),
                    ),
              ),
            ),
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  typedKeyword.isNotEmpty || _speechEnabled
                      ? usersExFiltered.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "${getTranslated(context, 'exercises')}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          : usersWsFiltered.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "${getTranslated(context, 'workouts')}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : usersCsFiltered.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "${getTranslated(context, 'categories')}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : usersTSFiltered.isNotEmpty
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            "${getTranslated(context, 'training')}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : usersTSWSFiltered.isNotEmpty
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Text(
                                                "${getTranslated(context, 'toning_workouts')}",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : SizedBox() /*Center(
                                              child: Text(
                                                  "${getTranslated(context, 'no_data')}"))*/
                      : Container(),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    height: Platform.isIOS
                        ? MediaQuery.of(context).size.height
                        : MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(color: Colors.transparent),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0))),
                    child: typedKeyword.isNotEmpty || _speechEnabled
                        ? usersExFiltered.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Exercises exercise = usersExFiltered[index];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, left: 20.0, right: 20.0),
                                        child: ListTile(
                                          tileColor: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            // side: BorderSide(
                                            //     color: Colors.grey
                                            //         .withOpacity(0.3))
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExerciseInfoScreen(
                                                          exercise: exercise,
                                                        )));
                                            // Navigator.pushNamed(context, WorkoutScreen.route);
                                            // showInfo(context);
                                          },
                                          minVerticalPadding: 15.0,
                                          // tileColor: Colors.pink.shade50,
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: FutureBuilder(
                                              future:
                                                  storageHandler.getImageUrl(
                                                      exercise.es_image),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                return FancyShimmerImage(
                                                  shimmerBaseColor:
                                                      Colors.blue.shade200,
                                                  shimmerHighlightColor:
                                                      Colors.grey[300],
                                                  shimmerBackColor:
                                                      Colors.black.withBlue(1),
                                                  imageUrl: snapshot.data !=
                                                              null &&
                                                          snapshot.data != ''
                                                      ? snapshot.data!
                                                      : Constants.loaderUrl,
                                                  boxFit: BoxFit.cover,
                                                  errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                                                  width: 80,
                                                  height: 50,
                                                );
                                              },
                                              initialData: Constants.loaderUrl,
                                            ),
                                          ),

                                          // https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa

                                          trailing: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(exercise.es_name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1),
                                              Text(
                                                  '${exercise.es_duration} ${exercise.es_durationin}')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                itemCount: usersExFiltered.length,
                              )
                            : usersWsFiltered.isNotEmpty
                                ? ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Workouts workout = usersWsFiltered[index];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 20.0,
                                                right: 20.0),
                                            child: ListTile(
                                              tileColor: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                // side: BorderSide(
                                                //     color: Colors.grey
                                                //         .withOpacity(0.3))
                                              ),
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => ExerciseInfoScreen(
                                                //           exercise: exercise,
                                                //         )));
                                                // Navigator.pushNamed(context, WorkoutScreen.route);
                                                // showInfo(context);
                                              },
                                              minVerticalPadding: 15.0,
                                              // tileColor: Colors.pink.shade50,
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: FutureBuilder(
                                                  future: storageHandler
                                                      .getImageUrl(
                                                          workout.ws_image),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                    return FancyShimmerImage(
                                                      shimmerBaseColor:
                                                          Colors.blue.shade200,
                                                      shimmerHighlightColor:
                                                          Colors.grey[300],
                                                      shimmerBackColor: Colors
                                                          .black
                                                          .withBlue(1),
                                                      imageUrl: snapshot.data !=
                                                                  null &&
                                                              snapshot.data !=
                                                                  ''
                                                          ? snapshot.data!
                                                          : Constants.loaderUrl,
                                                      boxFit: BoxFit.cover,
                                                      errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                                                      width: 80,
                                                      height: 50,
                                                    );
                                                  },
                                                  initialData:
                                                      Constants.loaderUrl,
                                                ),
                                              ),

                                              // https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa

                                              trailing: Icon(
                                                Icons.info_outline,
                                                size: 30.0,
                                              ),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(workout.ws_name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1),
                                                  Text(
                                                      '${workout.ws_duration} ${workout.ws_durationin}')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: usersWsFiltered.length,
                                  )
                                : usersCsFiltered.isNotEmpty
                                    ? ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          Categories category =
                                              usersCsFiltered[index];
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 20.0,
                                                    right: 20.0),
                                                child: ListTile(
                                                  tileColor: Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    // side: BorderSide(
                                                    //     color: Colors.grey
                                                    //         .withOpacity(0.3))
                                                  ),
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => ExerciseInfoScreen(
                                                    //           exercise: exercise,
                                                    //         )));
                                                    // Navigator.pushNamed(context, WorkoutScreen.route);
                                                    // showInfo(context);
                                                  },
                                                  minVerticalPadding: 15.0,
                                                  // tileColor: Colors.pink.shade50,
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: FutureBuilder(
                                                      future: storageHandler
                                                          .getImageUrl(category
                                                              .cs_image),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                        return FancyShimmerImage(
                                                          shimmerBaseColor:
                                                              Colors.blue
                                                                  .shade200,
                                                          shimmerHighlightColor:
                                                              Colors.grey[300],
                                                          shimmerBackColor:
                                                              Colors.black
                                                                  .withBlue(1),
                                                          imageUrl: snapshot
                                                                          .data !=
                                                                      null &&
                                                                  snapshot.data !=
                                                                      ''
                                                              ? snapshot.data!
                                                              : Constants
                                                                  .loaderUrl,
                                                          boxFit: BoxFit.cover,
                                                          errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                                                          width: 80,
                                                          height: 50,
                                                        );
                                                      },
                                                      initialData:
                                                          Constants.loaderUrl,
                                                    ),
                                                  ),

                                                  // https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa

                                                  trailing: Icon(
                                                    Icons.info_outline,
                                                    size: 30.0,
                                                  ),
                                                  title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(category.cs_name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1),
                                                        Text(category.cs_type)
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        itemCount: usersCsFiltered.length,
                                      )
                                    : usersTSFiltered.isNotEmpty
                                        ? ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              Trainings training =
                                                  usersTSFiltered[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 20.0,
                                                            right: 20.0),
                                                    child: ListTile(
                                                      tileColor: Theme.of(
                                                              context)
                                                          .disabledColor
                                                          .withOpacity(0.14),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        // side: BorderSide(
                                                        //     color: Colors.grey
                                                        //         .withOpacity(0.3))
                                                      ),
                                                      onTap: () {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) => ExerciseInfoScreen(
                                                        //           exercise: exercise,
                                                        //         )));
                                                        // Navigator.pushNamed(context, WorkoutScreen.route);
                                                        // showInfo(context);
                                                      },
                                                      minVerticalPadding: 15.0,
                                                      // tileColor: Colors.pink.shade50,
                                                      leading: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: FutureBuilder(
                                                          future: storageHandler
                                                              .getImageUrl(
                                                                  training
                                                                      .ts_image),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      String>
                                                                  snapshot) {
                                                            return FancyShimmerImage(
                                                              shimmerBaseColor:
                                                                  Colors.blue
                                                                      .shade200,
                                                              shimmerHighlightColor:
                                                                  Colors.grey[
                                                                      300],
                                                              shimmerBackColor:
                                                                  Colors.black
                                                                      .withBlue(
                                                                          1),
                                                              imageUrl: snapshot.data !=
                                                                          null &&
                                                                      snapshot.data !=
                                                                          ''
                                                                  ? snapshot
                                                                      .data!
                                                                  : Constants
                                                                      .loaderUrl,
                                                              boxFit:
                                                                  BoxFit.cover,
                                                              errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                                                              width: 80,
                                                              height: 50,
                                                            );
                                                          },
                                                          initialData: Constants
                                                              .loaderUrl,
                                                        ),
                                                      ),

                                                      // https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa

                                                      trailing: Icon(
                                                        Icons.info_outline,
                                                        size: 30.0,
                                                      ),
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(training.ts_name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1),
                                                          Text(
                                                              '${training.ts_duration} ${training.ts_durationin}')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: usersTSFiltered.length,
                                          )
                                        : usersTSWSFiltered.isNotEmpty
                                            ? ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  TonningWorkoutsModel toning =
                                                      usersTSWSFiltered[index];
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                left: 20.0,
                                                                right: 20.0),
                                                        child: ListTile(
                                                          tileColor:
                                                              Theme.of(context)
                                                                  .disabledColor
                                                                  .withOpacity(
                                                                      0.14),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            // side: BorderSide(
                                                            //     color: Colors.grey
                                                            //         .withOpacity(0.3))
                                                          ),
                                                          onTap: () {
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder: (context) => ExerciseInfoScreen(
                                                            //           exercise: exercise,
                                                            //         )));
                                                            // Navigator.pushNamed(context, WorkoutScreen.route);
                                                            // showInfo(context);
                                                          },
                                                          minVerticalPadding:
                                                              15.0,
                                                          // tileColor: Colors.pink.shade50,
                                                          leading: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child:
                                                                FutureBuilder(
                                                              future: storageHandler
                                                                  .getImageUrl(
                                                                      toning
                                                                          .tWs_image),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          String>
                                                                      snapshot) {
                                                                return FancyShimmerImage(
                                                                  shimmerBaseColor:
                                                                      Colors
                                                                          .blue
                                                                          .shade200,
                                                                  shimmerHighlightColor:
                                                                      Colors.grey[
                                                                          300],
                                                                  shimmerBackColor:
                                                                      Colors
                                                                          .black
                                                                          .withBlue(
                                                                              1),
                                                                  imageUrl: snapshot.data !=
                                                                              null &&
                                                                          snapshot.data !=
                                                                              ''
                                                                      ? snapshot
                                                                          .data!
                                                                      : Constants
                                                                          .loaderUrl,
                                                                  boxFit: BoxFit
                                                                      .cover,
                                                                  errorWidget: Image.network(Constants.noImg, fit: BoxFit.cover,),
                                                                  width: 80,
                                                                  height: 50,
                                                                );
                                                              },
                                                              initialData:
                                                                  Constants
                                                                      .loaderUrl,
                                                            ),
                                                          ),

                                                          // https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa

                                                          trailing: Icon(
                                                            Icons.info_outline,
                                                            size: 30.0,
                                                          ),
                                                          title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  toning
                                                                      .tWs_name,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1),
                                                              Text(
                                                                  '${toning.tWs_duration} ${toning.tWs_durationin}')
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                itemCount:
                                                    usersTSWSFiltered.length,
                                              )
                                            : Center(
                                                child: Text(
                                                    "${getTranslated(context, 'no_data')}"))
                        : Container(),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<Map<Permission, PermissionStatus>> requestSpeechPermission() async {
    final serviceStatus = await Permission.microphone.isGranted;

    bool isRequestMicrophonePermissionOn = serviceStatus == ServiceStatus.enabled;

    Map<Permission, PermissionStatus> status = await [
      Permission.speech,
      //add more permission to request here.
    ].request();

    if (status[Permission.speech]!.isPermanentlyDenied) {
      await _showMyPermissionDialog();
    } else {
      if (status[Permission.speech]!.isDenied) {
        _startListening();
      }
    }

    return status;
  }

  /// Permission setting move dialog......
  _showMyPermissionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Need to permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This feature cannot be used without permission.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              ),
              child: Text('Cancel', style: TextStyle(color: Colors.lightBlue[900]),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              ),
              child: Text('Go to Settings', style: TextStyle(color: Colors.lightBlue[900]),),
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
