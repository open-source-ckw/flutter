// ignore_for_file: prefer_const_constructors

import '../Util/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Screens/CategoriesInfoScreen.dart';
import '../Screens/ExerciseInfoScreen.dart';
import '../Util/CategoryEntity.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/Exercises_Categories.dart';
import '../firebase/DB/Repo/CategoryRepository.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/Exercises_CategoriesRepository.dart';
import '../firebase/DB/Repo/Exercises_EquipmentsRepository.dart';
import '../firebase/Storage/StorageHandler.dart';

class CategoriesInfoList extends StatefulWidget {
  Categories category;

  CategoriesInfoList({Key? key, required this.category}) : super(key: key);

  static const route = 'CategoriesInfoList';

  @override
  State<CategoriesInfoList> createState() => _CategoriesInfoListState();
}

class _CategoriesInfoListState extends State<CategoriesInfoList> {
  StorageHandler storageHandler = StorageHandler();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ExercisesCategoriesRepository exercisesCategoriesRepository =
      ExercisesCategoriesRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();

  List<Exercises> exercises = [];
  List<String> exercisesString = [];

  // List<String> ca = [];

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    // print(widget.exercise.Es_ID);
    List<Exercises>? exercises = await exercisesRepository
        .getAllExercisesByCSID(CS_ID: widget.category.CS_ID);
    for (var exercise in exercises) {
      if (!this.exercises.contains(exercise)) {
        this.exercises.add(exercise);
        exercisesString.add(exercise.es_name);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            Exercises exercise = exercises[index];
            return Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: ListTile(
                tileColor: Theme.of(context).disabledColor.withOpacity(0.11),
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
                title: Text(
                  exercise.es_name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                subtitle:
                    Text("${exercise.es_duration} ${exercise.es_durationin}"),
                trailing: Icon(Icons.info_outline),
              ),
            );
          }),
    );
  }
}
