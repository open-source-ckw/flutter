// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../firebase/DB/Models/Equipments.dart';
import '../firebase/DB/Models/Workouts.dart';
import '../firebase/DB/Repo/WorkoutsRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import '../Components/EquipmentCarousel.dart';
import '../Util/Constants.dart';
import '../local/localization/language_constants.dart';
import 'WorkoutScreen.dart';

class AllWorkout extends StatefulWidget {
  const AllWorkout({Key? key}) : super(key: key);

  // static const route = '/';
  static const route = 'AllWorkout';

  @override
  State<AllWorkout> createState() => _AllWorkoutState();
}

class _AllWorkoutState extends State<AllWorkout> {
  // List<String> filters = ['All', 'Beginner', 'Advance', 'Intermediate'];
  List<Workouts> workOuts = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  StorageHandler storageHandler = StorageHandler();

  List<Equipments> equipment = [
    // Equipment("assets/images/1.jpg", "2 Dumbells"),
    // Equipment("assets/images/1.jpg", "Mat"),
  ];

  List<int> selectedLevels = [];

  WorkoutsRepository workoutsRepository = WorkoutsRepository();

  List<Workouts> mainWorkout = [];

  List filters = ['All', 'Beginner', 'Advance', 'Irregular Training'];

  Future<void> loadWorkouts() async {
    workOuts.clear();
    List<Workouts> tempWorkouts = await workoutsRepository.getAllWorkouts();
    List<String> allWorkoutsLevels = [];
    for (int i = 0; i < tempWorkouts.length; i++) {
      Workouts t = tempWorkouts.elementAt(i);
      // String csId = t.ws_level.toLowerCase();
      // Categories eCat = await categoryRepository.getCategoryFromId(uid: csId);
      //
      // String catType = eCat.cs_name.toString().trim().toLowerCase();
      allWorkoutsLevels.add(t.ws_level);
    }
    tempWorkouts.map((e) {}).toList();
    // List<String> newFilters = filters;
    // newFilters.removeAt(0);
    if (selectedLevels.isEmpty || selectedLevels.contains(0)) {
      workOuts = tempWorkouts;
    } else {
      for (var selectedLevel in selectedLevels) {
        for (int i = 0; i < allWorkoutsLevels.length; i++) {
          String workoutsLevels = allWorkoutsLevels[i];

          if (workoutsLevels.toLowerCase() ==
              filters.elementAt(selectedLevel).toLowerCase()) {
            Workouts tempWorkout = tempWorkouts.elementAt(i);

            if (!workOuts.contains(tempWorkout)) {
              workOuts.add(tempWorkout);
            }
          }
        }
      }
    }
    setState(() {});
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      workOuts = mainWorkout;
    } else {
      workOuts = workOuts
          .where((w) =>
              w.ws_name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  @override
  void dispose() {
    /*if(mounted && context.loaderOverlay.visible){
      context.loaderOverlay.hide();
    }*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "${getTranslated(context, 'all')} ${getTranslated(context, 'workouts')}",
          style: TextStyle(color: Theme.of(context).textTheme.headline5!.color),
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
                        padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                        child: InkWell(
                          onTap: () async {
                            if (selectedLevels.contains(index)) {
                              selectedLevels.remove(index);
                            } else {
                              selectedLevels.add(index);
                            }
                            await loadWorkouts();
                          },
                          child: Container(
                              height: 5.0,
                              width: 85.0,
                              padding: EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                color: selectedLevels.contains(index)
                                    ? Colors.blue.shade900
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.14),
                                borderRadius: BorderRadius.circular(25.0),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                filters[index],
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: selectedLevels.contains(index)
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            Workouts workout = workOuts[index];
            return Padding(
              padding: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
              child: ListTile(
                tileColor: Theme.of(context).disabledColor.withOpacity(0.11),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutScreen(
                                workout: workout,
                              )));
                  // Navigator.pushNamed(context, WorkoutScreen.route);
                  // showInfo(context);
                },
                minVerticalPadding: 15.0,
                // tileColor: Colors.pink.shade50,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FutureBuilder(
                    future: storageHandler.getImageUrl(workout.ws_image),
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
                trailing: Icon(
                  Icons.info_outline,
                  size: 30.0,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(workout.ws_name), Text(workout.ws_level)],
                ),
              ),
            );
          },
          itemCount: workOuts.length,
        ),
      ),
    );
  }
}
