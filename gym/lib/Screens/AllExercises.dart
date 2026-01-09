// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import '../local/localization/language_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import '../Screens/ExerciseInfoScreen.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Models/Equipments.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Repo/CategoryRepository.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import '../Components/EquipmentCarousel.dart';
import '../Util/Constants.dart';

class AllExercises extends StatefulWidget {
  const AllExercises({Key? key}) : super(key: key);

  // static const route = '/';
  static const route = 'AllExercises';

  @override
  State<AllExercises> createState() => _AllExercisesState();
}

class _AllExercisesState extends State<AllExercises> {
  List<String> selectedFilters = [];

  List<Exercises> exercises = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Equipments> equipment = [];

  ExercisesRepository exercisesRepository = ExercisesRepository();
  CategoryRepository categoryRepository = CategoryRepository();
  StorageHandler storageHandler = StorageHandler();

  List<String> filters = [
    'All',
    'Chest',
    'Back',
    'Shoulders',
    'Legs',
    'Biceps',
    'Core',
    'Calves'
  ];

  Future<void> loadExercises() async {
    exercises.clear();
    List<Exercises> tempExercises = await exercisesRepository.getAllExercises();
    List<String> allExercisesName = [];
    for (int i = 0; i < tempExercises.length; i++) {
      Exercises t = tempExercises.elementAt(i);
      String csId = t.CS_ID;
      Categories eCat = await categoryRepository.getCategoryFromId(uid: csId);

      String catType = eCat.cs_name.toString().trim().toLowerCase();
      allExercisesName.add(catType);
    }
    tempExercises.map((e) {}).toList();
    if (selectedExercises.isEmpty || selectedExercises.contains(0)) {
      exercises = tempExercises;
    } else {
      for (var selectedExercise in selectedExercises) {
        for (int i = 0; i < allExercisesName.length; i++) {
          String exerciseName = allExercisesName[i];

          if (exerciseName.toLowerCase() ==
              filters.elementAt(selectedExercise).toLowerCase()) {
            Exercises tempExercise = tempExercises.elementAt(i);

            if (!exercises.contains(tempExercise)) {
              exercises.add(tempExercise);
            }
          }
        }
      }
    }
    if (mounted) {
      context.loaderOverlay.hide();
    }
    setState(() {});
  }

  List<Exercises> mainExercise = [];

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      exercises = mainExercise;
    } else {
      exercises = exercises
          .where((e) =>
              e.es_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {});
  }

  List<int> selectedExercises = [];

  @override
  void initState() {
    super.initState();
    loadExercises();
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
        // backgroundColor: Colors.white,
        key: scaffoldKey,
        appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
            iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
            title: Text(
              "${getTranslated(context, 'all')} ${getTranslated(context, 'exercises')}",
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline5!.color),
            ),
            centerTitle: true,
            elevation: 0.0,
            // backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      // color: Colors.white,
                      height: 35.0,
                      width: MediaQuery.of(context).size.width - 15.0,
                      child: ListView.builder(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 7.0, right: 7.0),
                            child: InkWell(
                              onTap: () async {
                                if (selectedExercises.contains(index)) {
                                  selectedExercises.remove(index);
                                } else {
                                  selectedExercises.add(index);
                                }
                                await loadExercises();
                              },
                              child: Container(
                                  height: 5.0,
                                  width: 85.0,
                                  padding: EdgeInsets.all(7.0),
                                  decoration: BoxDecoration(
                                    color: selectedExercises.contains(index)
                                        ? Colors.blue.shade900
                                        : Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.11),
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    filters[index],
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: selectedExercises.contains(index)
                                            ? Colors.white
                                            : Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.6)),
                                  )),
                            ),
                          );
                        },
                        itemCount: filters.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Exercises exercise = exercises[index];
              return Padding(
                padding: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
                child: ListTile(
                  tileColor: Theme.of(context).disabledColor.withOpacity(0.11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // side: BorderSide(
                    //     color: Colors.grey.withOpacity(0.3))
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseInfoScreen(
                                  exercise: exercise,
                                )));
                    // Navigator.pushNamed(context, WorkoutScreen.route);
                    // showInfo(context);
                  },
                  minVerticalPadding: 15.0,
                  // tileColor: Colors.pink.shade50,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FutureBuilder(
                      future: storageHandler.getImageUrl(exercise.es_image),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return FancyShimmerImage(
                          shimmerBaseColor: Colors.blue.shade200,
                          shimmerHighlightColor: Colors.grey[300],
                          shimmerBackColor: Colors.black.withBlue(1),
                          imageUrl: snapshot.data != null && snapshot.data != ''
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(exercise.es_name,
                          overflow: TextOverflow.ellipsis, maxLines: 1),
                      Text('${exercise.es_duration} ${exercise.es_durationin}')
                    ],
                  ),
                ),
              );
            },
            itemCount: exercises.length,
          ),
        ),
      ),
    );
  }
}
