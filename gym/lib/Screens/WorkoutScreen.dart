import 'dart:convert';
import 'dart:math';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/Categories.dart';
import '../firebase/DB/Models/Equipments.dart';
import '../firebase/DB/Models/Exercises.dart';
import '../firebase/DB/Models/ScheduledWorkout.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Models/Workouts.dart';
import '../firebase/DB/Models/Workouts_Categories.dart';
import '../firebase/DB/Repo/EquipmentsRepository.dart';
import '../firebase/DB/Repo/ExercisesRepository.dart';
import '../firebase/DB/Repo/Exercises_EquipmentsRepository.dart';
import '../firebase/DB/Repo/NotificationAlertRepository.dart';
import '../firebase/DB/Repo/ScheduledWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/User_FavRepository.dart';
import '../firebase/DB/Repo/Workouts_CategoriesRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/DB/Models/Exercises_Equipments.dart';
import '../firebase/DB/Models/NotificationAlert.dart';
import '../firebase/DB/Models/User_Fav.dart';
import '../firebase/DB/Repo/CategoryRepository.dart';
import '../local/localization/language_constants.dart';
import 'WorkoutsCategoriesInfo.dart';
import 'dart:io' show Platform;

class WorkoutScreen extends StatefulWidget {
  Workouts workout;

  WorkoutScreen({Key? key, required this.workout}) : super(key: key);

  static const String route = 'WorkoutScreen';

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Equipments> equipments = [];
  List<String> equipmentsString = [];

  bool isFavorite = false;
  bool isNotify = false;

  WorkoutsCategoriesRepository workoutsCategoriesRepository =
      WorkoutsCategoriesRepository();
  ExercisesRepository exercisesRepository = ExercisesRepository();
  ExercisesEquipmentsRepository exercisesEquipmentsRepository =
      ExercisesEquipmentsRepository();
  EquipmentsRepository equipmentsRepository = EquipmentsRepository();
  CategoryRepository categoryRepository = CategoryRepository();
  User_FavRepository userFavRepository = User_FavRepository();
  UserRepository userRepository = UserRepository();
  ScheduledWorkoutRepository scheduledWorkoutRepository =
      ScheduledWorkoutRepository();
  NotificationAlertRepository notificationAlertRepository =
      NotificationAlertRepository();

  List<Categories> categories = [];
  List<Exercises> exercises = [];

  List<ScheduledWorkout> scheduledExercises = [];
  List<int> scheduledDays = [];
  List<int> selectedCategory = [];
  List<int> orgSelectedCategory = [];
  List<int> orgScheduledDays = [];

  List<Categories> mainCategories = [];

  UserMaster? userMaster;

  @override
  void initState() {
    super.initState();
    loadFavorite();
    loadCategories();
    loadNotification();
    loadEquipments();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.loaderOverlay.show();
      }
    });
  }

  @override
  void dispose() {
    /*if(context.loaderOverlay.visible){
      context.loaderOverlay.hide();
    }*/
    super.dispose();
  }

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
      context.loaderOverlay.hide();
      setState(() {});
    }
  }

  Future<void> loadCategories() async {
    List workoutCategories = await workoutsCategoriesRepository
        .getAllWorkoutsCategoriesByWSId(wsId: widget.workout.WS_ID);

    for (var workoutCategory in workoutCategories) {
      Categories category = await categoryRepository.getCategoryFromId(
          uid: workoutCategory.CS_ID);
      if (!categories.contains(category)) {
        categories.add(category);
      }
    }
    setState(() {});
  }

  Future<void> loadFavorite() async {
    await loadUser();
    List tempFav = await userFavRepository.getAllFavoriteByRefId(
        spId: widget.workout.WS_ID, userId: userMaster!.UM_ID);
    if (tempFav.isNotEmpty) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> loadNotification() async {
    await loadUser();
    int index = 0;
    List<NotificationAlert> tempNotify =
        await notificationAlertRepository.getAllNotificationAlertByRefId(
            refId: widget.workout.WS_ID, userId: userMaster!.UM_ID);

    if (tempNotify.isNotEmpty) {
      setState(() {
        if (scheduledDays.contains(index)) {
          scheduledDays.remove(index);
        } else {
          scheduledDays.add(index);
        }
      });
    }
  }

  Future<void> loadEquipments() async {
    // print(widget.workout.WS_ID);
    Workouts workout = widget.workout;

    List workoutCategories = await workoutsCategoriesRepository
        .getAllWorkoutsCategoriesByWSId(wsId: workout.WS_ID);

    for (var workoutCategory in workoutCategories) {
      List catExercises = await exercisesRepository.getAllExercisesByCSID(
          CS_ID: workoutCategory.CS_ID);
      for (var catExercise in catExercises) {
        List exerciseEquipments = await exercisesEquipmentsRepository
            .getAllExercisesEquipmentsByESId(esId: catExercise.Es_ID);
        for (var element in exerciseEquipments) {
          Equipments equipment = await equipmentsRepository.getEquipmentsFromId(
              uid: element.EQ_ID);
          if (!equipments.contains(equipment)) {
            equipments.add(equipment);
            equipmentsString.add(getCamelCaseWord(equipment.eq_name));
          }
        }
      }
    }
    if (mounted && context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> showNotificationForWorkout(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required String startDate}) async {
    StorageHandler storageHandler = StorageHandler();
    String imageUrl = await storageHandler.getImageUrl(widget.workout.ws_image);
    // await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //         // icon: "resource://drawable/1.jpg",
    //         bigPicture: imageUrl,
    //         largeIcon: imageUrl,
    //         id: id,
    //         channelKey: 'basic_channel',
    //         title: title,
    //         body: body,
    //         notificationLayout: NotificationLayout.BigPicture,
    //         // bigPicture: widget.workout.ws_image,
    //         payload: {'uuid': payload},
    //         category: NotificationCategory.Reminder
    //         // autoDismissible: false,
    //
    //         ),
    //     schedule: NotificationCalendar.fromDate(
    //         date: DateTime.parse(startDate).add(Duration(hours: 6)),
    //         allowWhileIdle: true));
  }

  StorageHandler storageHandler = StorageHandler();

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
        /*appBar: AppBar(
          title: Text(
            widget.tonningWorkoutsModel.tWs_name,
            style: TextStyle(color: Colors.white),
          ),
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          elevation: 0.00,
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red,
                size: 30.0,
              ),
              onPressed: () async {
                context.loaderOverlay.show();

                if (isFavorite) {
                  List<User_Fav> userFav =
                      await user_favRepository.getAllFavoriteByRefId(
                          spId: widget.tonningWorkoutsModel.TWS_ID,
                          userId: userMaster!.UM_ID);
                  final result = await user_favRepository.delete(
                      favId: userFav.first.FAV_ID);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result ? 'Fav Removed' : 'Error')));
                } else {
                  User? user = FirebaseAuth.instance.currentUser;
                  User_Fav userFav = User_Fav(
                      FAV_ID: '',
                      UM_ID: user!.uid,
                      REF_ID: widget.tonningWorkoutsModel.TWS_ID,
                      REF_Type: 'banner');
                  await user_favRepository.save(user_Fav: userFav);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green.shade500,
                      content: Text('Success')));
                }
                setState(() {
                  isFavorite = !isFavorite;
                });
                if (context.loaderOverlay.visible) {
                  context.loaderOverlay.hide();
                }
              },
            )
          ],
          //backgroundColor: Colors.greenAccent[400],
          backgroundColor: Colors.blueAccent[100],
        ),*/ //AppBar
        bottomNavigationBar: Constants.BottomContainer(
            onTap: () async {
              await scheduleWorkouts(context).then((value) async {
                // await loadScheduledExercises();
              });
            },
            title: "${getTranslated(context, 'schedule_workout')}",
            context: context),

        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Constants.BodyInfoContainer(
                    context: context,
                    image: storageHandler.getImageUrl(widget.workout.ws_image),
                    title: widget.workout.ws_name,
                    duration:
                        '${widget.workout.ws_duration} ${widget.workout.ws_durationin.substring(0, 3)}',
                    kal: widget.workout.ws_kal,
                    level: widget.workout.ws_level,
                    description: widget.workout.ws_description,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.14)),
                    equipments: equipmentsString.join(","),
                    type: "",
                    onTap: () {},
                    // equipmentCarousel: EquipmentCarousel(equipments: equipments),
                  ),
                  CategoriesList(context: context),
                ],
              ),
            ),
            Constants.HeaderContainer(
              context: context,
              title: widget.workout.ws_name,
              backIcon: Icon(Icons.arrow_back_ios),
              favIcon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red,
                size: 30.0,
              ),
              favOnPressed: () async {
                context.loaderOverlay.show();

                if (isFavorite) {
                  List userFav = await userFavRepository.getAllFavoriteByRefId(
                      spId: widget.workout.WS_ID, userId: userMaster!.UM_ID);
                  final result = await userFavRepository.delete(
                      favId: userFav.first.FAV_ID);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result
                          ? "${getTranslated(context, 'fav_rem')}"
                          : "${getTranslated(context, 'error')}")));
                } else {
                  User? user = FirebaseAuth.instance.currentUser;
                  User_Fav userFav = User_Fav(
                      FAV_ID: '',
                      UM_ID: user!.uid,
                      REF_ID: widget.workout.WS_ID,
                      REF_Type: 'workout');
                  await userFavRepository.save(user_Fav: userFav);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green.shade500,
                      content: Text("${getTranslated(context, 'success')}")));
                }
                setState(() {
                  isFavorite = !isFavorite;
                });
                if (context.loaderOverlay.visible) {
                  context.loaderOverlay.hide();
                }
              },
              backOnPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget CategoriesList({
    required context,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "${getTranslated(context, 'categories')}",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 10, right: 7, left: 7),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.11),
                borderRadius: BorderRadius.circular(25.0)),
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Categories category = categories.elementAt(index);
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 0.0, right: 0.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutsCategoriesInfoScreen(
                                    category: category,
                                    currentWorkout: widget.workout,
                                  )));
                      // Navigator.pushNamed(context, CategoriesInfoScreen.route);
                    },
                    minVerticalPadding: 25.0,
                    // tileColor: Theme.of(context).disabledColor.withOpacity(0.14),
                    leading: FutureBuilder(
                      future: storageHandler.getImageUrl(category.cs_image),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data != null && snapshot.data != ''
                              ? snapshot.data!
                              : Constants.loaderUrl,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        );
                      },
                      initialData: Constants.loaderUrl,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15.0,
                    ),
                    title: Text(category.cs_name),
                    // subtitle: Text('2 workouts'),

                    /*Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entity.text),
                                Text(entity.duration)
                              ],
                            ),*/
                  ),
                );
              },
              itemCount: categories.length,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget getExerciseTitle(
      {required String text, required int exercises, required int minutes}) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7.0),
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
                  children: [Text('Rest'), Text('$hour:$minutes')],
                ),
              )
            ],
          )),
    );
  }

  Future<void> scheduleWorkouts(BuildContext context) async {
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${getTranslated(context, 'schedule_workout')}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: Icon(Icons.cancel_outlined)),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Wrap(
                          children: [
                            SizedBox(
                              height: 80.0,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  getDayContainer(
                                      setState: setState,
                                      containerIndex: 1,
                                      header: format
                                          .format(startDate)
                                          .toString()
                                          .substring(0, 1),
                                      isCompleted:
                                          scheduledDays.contains(startDate.day),
                                      footer: startDate.day.toString()),
                                  getDayContainer(
                                      setState: setState,
                                      containerIndex: 2,
                                      header: format
                                          .format(startDate
                                              .add(const Duration(days: 1)))
                                          .toString()
                                          .substring(0, 1),
                                      isCompleted: scheduledDays.contains(
                                          startDate
                                              .add(const Duration(days: 1))
                                              .day),
                                      footer: startDate
                                          .add(const Duration(days: 1))
                                          .day
                                          .toString()),
                                  getDayContainer(
                                      setState: setState,
                                      containerIndex: 3,
                                      header: format
                                          .format(startDate
                                              .add(const Duration(days: 2)))
                                          .toString()
                                          .substring(0, 1),
                                      isCompleted: scheduledDays.contains(
                                          startDate
                                              .add(const Duration(days: 2))
                                              .day),
                                      footer: startDate
                                          .add(const Duration(days: 2))
                                          .day
                                          .toString()),
                                  getDayContainer(
                                      setState: setState,
                                      containerIndex: 4,
                                      header: format
                                          .format(startDate
                                              .add(const Duration(days: 3)))
                                          .toString()
                                          .substring(0, 1),
                                      isCompleted: scheduledDays.contains(
                                          startDate
                                              .add(const Duration(days: 3))
                                              .day),
                                      footer: startDate
                                          .add(const Duration(days: 3))
                                          .day
                                          .toString()),
                                  getDayContainer(
                                      setState: setState,
                                      containerIndex: 5,
                                      header: format
                                          .format(startDate
                                              .add(const Duration(days: 4)))
                                          .toString()
                                          .substring(0, 1),
                                      isCompleted: scheduledDays.contains(
                                          startDate
                                              .add(const Duration(days: 4))
                                              .day),
                                      footer: startDate
                                          .add(const Duration(days: 4))
                                          .day
                                          .toString()),
                                  getDayContainer(
                                      setState: setState,
                                      containerIndex: 6,
                                      header: format
                                          .format(startDate
                                              .add(const Duration(days: 5)))
                                          .toString()
                                          .substring(0, 1),
                                      isCompleted: scheduledDays.contains(
                                          startDate
                                              .add(const Duration(days: 5))
                                              .day),
                                      footer: startDate
                                          .add(const Duration(days: 5))
                                          .day
                                          .toString()),
                                  getDayContainer(
                                      setState: setState,
                                      containerIndex: 7,
                                      header: format
                                          .format(startDate
                                              .add(const Duration(days: 6)))
                                          .toString()
                                          .substring(0, 1),
                                      isCompleted: scheduledDays.contains(
                                          startDate
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
                      ),

                      // SizedBox(height: 100,),

                      GridView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          // scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1 / 0.60,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                // mainAxisSize:MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (selectedCategory.contains(index)) {
                                        selectedCategory.remove(index);
                                      } else {
                                        selectedCategory.add(index);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedCategory.contains(index)
                                            ? Colors.blue.shade900
                                            : Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(
                                        //     color: Colors.grey, width: 2)
                                      ),
                                      height: 40,
                                      // width: 120,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      // padding: EdgeInsets.symmetric(horizontal: 1,vertical: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 2),
                                        child: Center(
                                          child: Text(
                                            categories[index].cs_name,
                                            style: TextStyle(
                                                color: selectedCategory
                                                        .contains(index)
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(0.6)),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                      // Wrap(
                      //   children: [
                      //     // Row(
                      //     //   mainAxisAlignment: MainAxisAlignment.end,
                      //     //   children: [
                      //     //     IconButton(
                      //     //       onPressed: () {
                      //     //         Navigator.pop(context);
                      //     //       },
                      //     //       icon: Icon(Icons.cancel_outlined),
                      //     //     ),
                      //     //   ],
                      //     // ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
                      //       child: Row(
                      //         children: [
                      //           Expanded(
                      //               child: Text(
                      //             'Schedule Workout',
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //                 fontSize: 20.0, fontWeight: FontWeight.bold),
                      //           )),
                      //           IconButton(
                      //             onPressed: () {
                      //               Navigator.pop(context);
                      //             },
                      //             icon: Icon(Icons.cancel_outlined),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(bottom: 30),
                      //       child: Wrap(
                      //         children: [
                      //           SizedBox(
                      //             height: 80.0,
                      //             width: MediaQuery.of(context).size.width,
                      //             child: ListView(
                      //               physics: const BouncingScrollPhysics(),
                      //               scrollDirection: Axis.horizontal,
                      //               children: [
                      //                 getDayContainer(
                      //                     setState: setState,
                      //                     containerIndex: 1,
                      //                     header: format
                      //                         .format(startDate)
                      //                         .toString()
                      //                         .substring(0, 1),
                      //                     isCompleted:
                      //                         scheduledDays.contains(startDate.day),
                      //                     footer: startDate.day.toString()),
                      //                 getDayContainer(
                      //                     setState: setState,
                      //                     containerIndex: 2,
                      //                     header: format
                      //                         .format(startDate
                      //                             .add(const Duration(days: 1)))
                      //                         .toString()
                      //                         .substring(0, 1),
                      //                     isCompleted: scheduledDays.contains(startDate
                      //                         .add(const Duration(days: 1))
                      //                         .day),
                      //                     footer: startDate
                      //                         .add(const Duration(days: 1))
                      //                         .day
                      //                         .toString()),
                      //                 getDayContainer(
                      //                     setState: setState,
                      //                     containerIndex: 3,
                      //                     header: format
                      //                         .format(startDate
                      //                             .add(const Duration(days: 2)))
                      //                         .toString()
                      //                         .substring(0, 1),
                      //                     isCompleted: scheduledDays.contains(startDate
                      //                         .add(const Duration(days: 2))
                      //                         .day),
                      //                     footer: startDate
                      //                         .add(const Duration(days: 2))
                      //                         .day
                      //                         .toString()),
                      //                 getDayContainer(
                      //                     setState: setState,
                      //                     containerIndex: 4,
                      //                     header: format
                      //                         .format(startDate
                      //                             .add(const Duration(days: 3)))
                      //                         .toString()
                      //                         .substring(0, 1),
                      //                     isCompleted: scheduledDays.contains(startDate
                      //                         .add(const Duration(days: 3))
                      //                         .day),
                      //                     footer: startDate
                      //                         .add(const Duration(days: 3))
                      //                         .day
                      //                         .toString()),
                      //                 getDayContainer(
                      //                     setState: setState,
                      //                     containerIndex: 5,
                      //                     header: format
                      //                         .format(startDate
                      //                             .add(const Duration(days: 4)))
                      //                         .toString()
                      //                         .substring(0, 1),
                      //                     isCompleted: scheduledDays.contains(startDate
                      //                         .add(const Duration(days: 4))
                      //                         .day),
                      //                     footer: startDate
                      //                         .add(const Duration(days: 4))
                      //                         .day
                      //                         .toString()),
                      //                 getDayContainer(
                      //                     setState: setState,
                      //                     containerIndex: 6,
                      //                     header: format
                      //                         .format(startDate
                      //                             .add(const Duration(days: 5)))
                      //                         .toString()
                      //                         .substring(0, 1),
                      //                     isCompleted: scheduledDays.contains(startDate
                      //                         .add(const Duration(days: 5))
                      //                         .day),
                      //                     footer: startDate
                      //                         .add(const Duration(days: 5))
                      //                         .day
                      //                         .toString()),
                      //                 getDayContainer(
                      //                     setState: setState,
                      //                     containerIndex: 7,
                      //                     header: format
                      //                         .format(startDate
                      //                             .add(const Duration(days: 6)))
                      //                         .toString()
                      //                         .substring(0, 1),
                      //                     isCompleted: scheduledDays.contains(startDate
                      //                         .add(const Duration(days: 6))
                      //                         .day),
                      //                     footer: startDate
                      //                         .add(const Duration(days: 6))
                      //                         .day
                      //                         .toString()),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //
                      //     // SizedBox(height: 100,),
                      //
                      //     GridView.builder(
                      //         // physics: NeverScrollableScrollPhysics(),
                      //       // scrollDirection: Axis.vertical,
                      //         gridDelegate:
                      //             const SliverGridDelegateWithFixedCrossAxisCount(
                      //                 crossAxisCount: 3,
                      //                 childAspectRatio: 1 / 0.60,
                      //                 crossAxisSpacing: 10,
                      //                 mainAxisSpacing: 10),
                      //         shrinkWrap: true,
                      //         itemCount: categories.length,
                      //         itemBuilder: (BuildContext context, int index) {
                      //           return Padding(
                      //             padding: EdgeInsets.zero,
                      //             child: Column(
                      //               // mainAxisSize:MainAxisSize.min,
                      //               children: [
                      //                 InkWell(
                      //                   onTap: () {
                      //                     if (selectedCategory.contains(index)) {
                      //                       selectedCategory.remove(index);
                      //                     } else {
                      //                       selectedCategory.add(index);
                      //                     }
                      //                     setState(() {});
                      //                   },
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                         color: selectedCategory.contains(index)
                      //                             ? Colors.blue.shade900
                      //                             : Colors.white,
                      //                         borderRadius: BorderRadius.circular(10),
                      //                         border: Border.all(
                      //                             color: Colors.grey, width: 2)),
                      //                     height: 40,
                      //                     // width: 120,
                      //                     margin: EdgeInsets.symmetric(
                      //                         vertical: 2, horizontal: 10),
                      //                     // padding: EdgeInsets.symmetric(horizontal: 1,vertical: 5),
                      //                     child: Padding(
                      //                       padding: const EdgeInsets.symmetric(
                      //                           horizontal: 2, vertical: 2),
                      //                       child: Center(
                      //                         child: Text(
                      //                           categories[index].cs_name,
                      //                           style: TextStyle(
                      //                               color:
                      //                                   selectedCategory.contains(index)
                      //                                       ? Colors.white
                      //                                       : Colors.black),
                      //                           overflow: TextOverflow.ellipsis,
                      //                           maxLines: 2,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         }),
                      //   ],
                      // ),
                      // Positioned(
                      //   left: 20,
                      //   right: 20,
                      //   bottom: 25.0,
                      //   child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           top: 25.0, left: 15.0, right: 15.0),
                      //       child: InkWell(
                      //         onTap: () async {
                      //           this.context.loaderOverlay.show();
                      //           DateTime date = DateTime.now();
                      //           DateFormat format = DateFormat('yyyy-MM');
                      //
                      //           /* print('ORGSCHDATES:');
                      //           print('$orgScheduledDays');
                      //           print('SCHDATES:');dd
                      //           print('$scheduledDays:');*/
                      //           for (int i = 0; i < orgSelectedCategory.length; i++) {
                      //             int element = orgScheduledDays.elementAt(i);
                      //
                      //             String stringDate = format.format(date);
                      //             if (element < 10) {
                      //               stringDate = '$stringDate-0$element';
                      //             } else {
                      //               stringDate = '$stringDate-$element';
                      //             }
                      //             // print(stringDate);
                      //
                      //             if (!scheduledDays.contains(element)) {
                      //               ScheduledWorkout? scheduleWorkout =
                      //                   await scheduledWorkoutRepository
                      //                       .getScheduledWorkoutFromUserIdByStartDate(
                      //                           uid: userMaster!.UM_ID,
                      //                           refId: widget.workout.WS_ID,
                      //                           date: stringDate);
                      //               if (scheduleWorkout != null) {
                      //                 await scheduledWorkoutRepository.delete(
                      //                     sw_ID: scheduleWorkout.SW_ID);
                      //
                      //                 SharedPreferences sharedPref =
                      //                     await SharedPreferences.getInstance();
                      //                 List<String> storedIds = sharedPref.getStringList(
                      //                         Constants.faStoredNotificationIdKey) ??
                      //                     [];
                      //
                      //                 Map<String, dynamic> notificationData =
                      //                     Map.fromEntries(
                      //                         [MapEntry(scheduleWorkout.SW_ID, 0)]);
                      //                 List<String> existingMap =
                      //                     sharedPref.getStringList(Constants
                      //                             .faStoredNotificationMapKey) ??
                      //                         [];
                      //
                      //                 for (var element in existingMap) {
                      //                   Map<String, dynamic> decodedString =
                      //                       json.decode(element);
                      //
                      //                   if (decodedString.keys.first ==
                      //                       notificationData.keys.first) {
                      //                     existingMap.remove(element);
                      //                     storedIds.remove(
                      //                         decodedString.values.first.toString());
                      //                     AwesomeNotifications()
                      //                         .cancel(decodedString.values.first);
                      //                     sharedPref.setStringList(
                      //                         Constants.faStoredNotificationMapKey,
                      //                         existingMap);
                      //                     sharedPref.setStringList(
                      //                         Constants.faStoredNotificationIdKey,
                      //                         storedIds);
                      //                     break;
                      //                   }
                      //                 }
                      //               }
                      //
                      //               ///Notification Remove in firebase
                      //               int index = 0;
                      //               List<NotificationAlert> userNotify =
                      //                   await notificationAlertRepository
                      //                       .getAllNotificationAlertByRefId(
                      //                           refId: widget.workout.WS_ID,
                      //                           userId: userMaster!.UM_ID);
                      //               final result1 =
                      //                   await notificationAlertRepository.delete(
                      //                       na_id: userNotify.elementAt(index).NA_ID);
                      //               if (!mounted) return;
                      //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //                   content:
                      //                       Text(result1 ? 'Fav Removed' : 'Error')));
                      //             }
                      //           }
                      //           for (int i = 0; i < selectedCategory.length; i++) {
                      //             int element = scheduledDays[i];
                      //             String dateString = format.format(date);
                      //             String tempDay = "";
                      //             if (element < 10) {
                      //               tempDay = '0$element';
                      //             } else {
                      //               tempDay = '$element';
                      //             }
                      //             dateString = '$dateString-$tempDay';
                      //             final result =
                      //                 await scheduledWorkoutRepository.isExist(
                      //                     uid: userMaster!.UM_ID,
                      //                     refId: widget.workout.WS_ID,
                      //                     date: dateString);
                      //             if (!result) {
                      //               ScheduledWorkout scheduledWorkout =
                      //                   ScheduledWorkout(
                      //                       SW_ID: '',
                      //                       UM_ID: userMaster!.UM_ID,
                      //                       REF_ID: widget.workout.WS_ID,
                      //                       REF_TYPE: 'workout',
                      //                       sw_scheduledDate:
                      //                           Constants.getCurrentDate(),
                      //                       sw_scheduledForDate: dateString,
                      //                       sw_scheduledTime:
                      //                           Constants.getCurrentTime(),
                      //                       sw_isActive: true);
                      //               scheduledWorkout = await scheduledWorkoutRepository
                      //                   .save(scheduledWorkout: scheduledWorkout);
                      //
                      //               SharedPreferences sharedPref =
                      //                   await SharedPreferences.getInstance();
                      //               List<String> storedIds = sharedPref.getStringList(
                      //                       Constants.faStoredNotificationIdKey) ??
                      //                   [];
                      //
                      //               int id = Random().nextInt(99999999);
                      //               while (storedIds.contains(id.toString())) {
                      //                 id = Random().nextInt(99999999);
                      //               }
                      //               // print(id);
                      //               Map<String, int> notificationData = Map.fromEntries(
                      //                   [MapEntry(scheduledWorkout.SW_ID, id)]);
                      //               List<String> existingMap = sharedPref.getStringList(
                      //                       Constants.faStoredNotificationMapKey) ??
                      //                   [];
                      //
                      //               // print(existingMap);
                      //               final isNotExist = existingMap.every((element) {
                      //                 Map<String, dynamic> decodedString =
                      //                     json.decode(element);
                      //                 if (decodedString.keys.first ==
                      //                     notificationData.keys.first) {
                      //                   return false;
                      //                 }
                      //                 return true;
                      //               });
                      //               if (isNotExist) {
                      //                 // existingMap.add(JsonEncoder().convert(notificationData));
                      //
                      //                 existingMap.add(json.encode(notificationData));
                      //                 storedIds.add(id.toString());
                      //                 sharedPref.setStringList(
                      //                     Constants.faStoredNotificationMapKey,
                      //                     existingMap);
                      //                 sharedPref.setStringList(
                      //                     Constants.faStoredNotificationIdKey,
                      //                     storedIds);
                      //               }
                      //
                      //               ///Notification Add in firebase
                      //               NotificationAlert userNotification =
                      //                   NotificationAlert(
                      //                       NA_ID: "",
                      //                       UM_ID: userMaster!.UM_ID,
                      //                       na_refType: widget.workout.ws_name,
                      //                       na_refId: widget.workout.WS_ID,
                      //                       na_refImage: widget.workout.ws_image,
                      //                       na_adt: dateString);
                      //               await notificationAlertRepository.save(
                      //                   notificationAlert: userNotification);
                      //
                      //               await showNotificationForWorkout(
                      //                   id: id,
                      //                   title: widget.workout.ws_name,
                      //                   body: scheduledWorkout.sw_scheduledForDate,
                      //                   payload: scheduledWorkout.SW_ID,
                      //                   startDate:
                      //                       scheduledWorkout.sw_scheduledForDate);
                      //
                      //               if (!orgScheduledDays.contains(element)) {
                      //                 orgScheduledDays.add(element);
                      //               }
                      //             }
                      //           }
                      //
                      //           for (int i = 0; i < orgSelectedCategory.length; i++) {
                      //             int element = selectedCategory.elementAt(i);
                      //
                      //             String stringDate = format.format(date);
                      //             if (element < 10) {
                      //               stringDate = '$stringDate-0$element';
                      //             } else {
                      //               stringDate = '$stringDate-$element';
                      //             }
                      //             // print(stringDate);
                      //
                      //             if (!selectedCategory.contains(element)) {
                      //               int index = 0;
                      //               Categories category = categories.elementAt(index);
                      //               ScheduledWorkout? scheduleWorkout =
                      //                   await scheduledWorkoutRepository
                      //                       .getScheduledWorkoutFromUserIdByStartDate(
                      //                           uid: userMaster!.UM_ID,
                      //                           refId: category.cs_name,
                      //                           date: stringDate);
                      //               if (scheduleWorkout != null) {
                      //                 await scheduledWorkoutRepository.delete(
                      //                     sw_ID: scheduleWorkout.SW_ID);
                      //
                      //                 SharedPreferences sharedPref =
                      //                     await SharedPreferences.getInstance();
                      //                 List<String> storedIds = sharedPref.getStringList(
                      //                         Constants.faStoredNotificationIdKey) ??
                      //                     [];
                      //
                      //                 Map<String, dynamic> notificationData =
                      //                     Map.fromEntries(
                      //                         [MapEntry(scheduleWorkout.SW_ID, 0)]);
                      //                 List<String> existingMap =
                      //                     sharedPref.getStringList(Constants
                      //                             .faStoredNotificationMapKey) ??
                      //                         [];
                      //
                      //                 for (var element in existingMap) {
                      //                   Map<String, dynamic> decodedString =
                      //                       json.decode(element);
                      //
                      //                   if (decodedString.keys.first ==
                      //                       notificationData.keys.first) {
                      //                     existingMap.remove(element);
                      //                     storedIds.remove(
                      //                         decodedString.values.first.toString());
                      //                     AwesomeNotifications()
                      //                         .cancel(decodedString.values.first);
                      //                     sharedPref.setStringList(
                      //                         Constants.faStoredNotificationMapKey,
                      //                         existingMap);
                      //                     sharedPref.setStringList(
                      //                         Constants.faStoredNotificationIdKey,
                      //                         storedIds);
                      //                     break;
                      //                   }
                      //                 }
                      //               }
                      //
                      //               ///Notification Remove in firebase
                      //               int index1 = 0;
                      //               List<NotificationAlert> userNotify =
                      //                   await notificationAlertRepository
                      //                       .getAllNotificationAlertByRefId(
                      //                           refId: category.cs_name,
                      //                           userId: userMaster!.UM_ID);
                      //               final result1 =
                      //                   await notificationAlertRepository.delete(
                      //                       na_id: userNotify.elementAt(index1).NA_ID);
                      //               if (!mounted) return;
                      //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //                   content:
                      //                       Text(result1 ? 'Fav Removed' : 'Error')));
                      //             }
                      //           }
                      //           for (int i = 0; i < selectedCategory.length; i++) {
                      //             int index = 0;
                      //             Categories category = categories.elementAt(index);
                      //             int element = selectedCategory[i];
                      //             String dateString = format.format(date);
                      //             String tempDay = "";
                      //             if (element < 10) {
                      //               tempDay = '0$element';
                      //             } else {
                      //               tempDay = '$element';
                      //             }
                      //             dateString = '$dateString-$tempDay';
                      //             final result =
                      //                 await scheduledWorkoutRepository.isExist(
                      //                     uid: userMaster!.UM_ID,
                      //                     refId: category.cs_name,
                      //                     date: dateString);
                      //             if (!result) {
                      //               ScheduledWorkout scheduledWorkout =
                      //                   ScheduledWorkout(
                      //                       SW_ID: '',
                      //                       UM_ID: userMaster!.UM_ID,
                      //                       REF_ID: category.CS_ID,
                      //                       REF_TYPE: 'category',
                      //                       sw_scheduledDate:
                      //                           Constants.getCurrentDate(),
                      //                       sw_scheduledForDate: dateString,
                      //                       sw_scheduledTime:
                      //                           Constants.getCurrentTime(),
                      //                       sw_isActive: true);
                      //               scheduledWorkout = await scheduledWorkoutRepository
                      //                   .save(scheduledWorkout: scheduledWorkout);
                      //
                      //               SharedPreferences sharedPref =
                      //                   await SharedPreferences.getInstance();
                      //               List<String> storedIds = sharedPref.getStringList(
                      //                       Constants.faStoredNotificationIdKey) ??
                      //                   [];
                      //
                      //               int id = Random().nextInt(99999999);
                      //               while (storedIds.contains(id.toString())) {
                      //                 id = Random().nextInt(99999999);
                      //               }
                      //               // print(id);
                      //               Map<String, int> notificationData = Map.fromEntries(
                      //                   [MapEntry(scheduledWorkout.SW_ID, id)]);
                      //               List<String> existingMap = sharedPref.getStringList(
                      //                       Constants.faStoredNotificationMapKey) ??
                      //                   [];
                      //
                      //               // print(existingMap);
                      //               final isNotExist = existingMap.every((element) {
                      //                 Map<String, dynamic> decodedString =
                      //                     json.decode(element);
                      //                 if (decodedString.keys.first ==
                      //                     notificationData.keys.first) {
                      //                   return false;
                      //                 }
                      //                 return true;
                      //               });
                      //               if (isNotExist) {
                      //                 // existingMap.add(JsonEncoder().convert(notificationData));
                      //
                      //                 existingMap.add(json.encode(notificationData));
                      //                 storedIds.add(id.toString());
                      //                 sharedPref.setStringList(
                      //                     Constants.faStoredNotificationMapKey,
                      //                     existingMap);
                      //                 sharedPref.setStringList(
                      //                     Constants.faStoredNotificationIdKey,
                      //                     storedIds);
                      //               }
                      //
                      //               ///Notification Add in firebase
                      //               NotificationAlert userNotification =
                      //                   NotificationAlert(
                      //                       NA_ID: "",
                      //                       UM_ID: userMaster!.UM_ID,
                      //                       na_refType: category.cs_name,
                      //                       na_refId: category.CS_ID,
                      //                       na_refImage: category.cs_image,
                      //                       na_adt: dateString);
                      //               await notificationAlertRepository.save(
                      //                   notificationAlert: userNotification);
                      //
                      //               await showNotificationForWorkout(
                      //                   id: id,
                      //                   title: category.cs_name,
                      //                   body: scheduledWorkout.sw_scheduledForDate,
                      //                   payload: scheduledWorkout.SW_ID,
                      //                   startDate:
                      //                       scheduledWorkout.sw_scheduledForDate);
                      //
                      //               if (!orgScheduledDays.contains(element)) {
                      //                 orgScheduledDays.add(element);
                      //               }
                      //             }
                      //           }
                      //
                      //           this.context.loaderOverlay.hide();
                      //           if (!mounted) return;
                      //           Navigator.pop(context);
                      //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //               backgroundColor: Colors.green.shade500,
                      //               content: Text('Scheduled')));
                      //           // await loadScheduledExercises();
                      //         },
                      //         child: Container(
                      //           alignment: Alignment.center,
                      //           width: MediaQuery.of(context).size.width * 0.6,
                      //           height: 40.0,
                      //           decoration: BoxDecoration(
                      //               color: Colors.blue.shade900,
                      //               border: Border.all(),
                      //               borderRadius: BorderRadius.circular(40.0)),
                      //           child: const Text(
                      //             'Save',
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20.0,
                      //                 letterSpacing: 1.0,
                      //                 fontWeight: FontWeight.bold),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //         ),
                      //       )),
                      // )
                    ]),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 25.0,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 15.0, right: 15.0),
                    child: InkWell(
                      onTap: () async {
                        this.context.loaderOverlay.show();
                        DateTime date = DateTime.now();
                        DateFormat format = DateFormat('yyyy-MM');

                        /* print('ORGSCHDATES:');
                          print('$orgScheduledDays');
                          print('SCHDATES:');dd
                          print('$scheduledDays:');*/
                        for (int i = 0; i < orgSelectedCategory.length; i++) {
                          int element = orgScheduledDays.elementAt(i);

                          String stringDate = format.format(date);
                          if (element < 10) {
                            stringDate = '$stringDate-0$element';
                          } else {
                            stringDate = '$stringDate-$element';
                          }
                          // print(stringDate);

                          if (!scheduledDays.contains(element)) {
                            ScheduledWorkout? scheduleWorkout =
                                await scheduledWorkoutRepository
                                    .getScheduledWorkoutFromUserIdByStartDate(
                                        uid: userMaster!.UM_ID,
                                        refId: widget.workout.WS_ID,
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

                            ///Notification Remove in firebase
                            int index = 0;
                            List<NotificationAlert> userNotify =
                                await notificationAlertRepository
                                    .getAllNotificationAlertByRefId(
                                        refId: widget.workout.WS_ID,
                                        userId: userMaster!.UM_ID);
                            final result1 =
                                await notificationAlertRepository.delete(
                                    na_id: userNotify.elementAt(index).NA_ID);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(result1
                                    ? "${getTranslated(context, 'fav_rem')}"
                                    : "${getTranslated(context, 'error')}")));
                          }
                        }
                        for (int i = 0; i < selectedCategory.length; i++) {
                          int element = scheduledDays[i];
                          String dateString = format.format(date);
                          String tempDay = "";
                          if (element < 10) {
                            tempDay = '0$element';
                          } else {
                            tempDay = '$element';
                          }
                          dateString = '$dateString-$tempDay';
                          final result =
                              await scheduledWorkoutRepository.isExist(
                                  uid: userMaster!.UM_ID,
                                  refId: widget.workout.WS_ID,
                                  date: dateString);
                          if (!result) {
                            ScheduledWorkout scheduledWorkout =
                                ScheduledWorkout(
                                    SW_ID: '',
                                    UM_ID: userMaster!.UM_ID,
                                    REF_ID: widget.workout.WS_ID,
                                    REF_TYPE: 'workout',
                                    sw_scheduledDate:
                                        Constants.getCurrentDate(),
                                    sw_scheduledForDate: dateString,
                                    sw_scheduledTime:
                                        Constants.getCurrentTime(),
                                    sw_isActive: true);
                            scheduledWorkout = await scheduledWorkoutRepository
                                .save(scheduledWorkout: scheduledWorkout);

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

                            ///Notification Add in firebase
                            NotificationAlert userNotification =
                                NotificationAlert(
                                    NA_ID: "",
                                    UM_ID: userMaster!.UM_ID,
                                    na_refType: widget.workout.ws_name,
                                    na_refId: widget.workout.WS_ID,
                                    na_refImage: widget.workout.ws_image,
                                    na_adt: dateString);
                            await notificationAlertRepository.save(
                                notificationAlert: userNotification);

                            await showNotificationForWorkout(
                                id: id,
                                title: widget.workout.ws_name,
                                body: scheduledWorkout.sw_scheduledForDate,
                                payload: scheduledWorkout.SW_ID,
                                startDate:
                                    scheduledWorkout.sw_scheduledForDate);

                            if (!orgScheduledDays.contains(element)) {
                              orgScheduledDays.add(element);
                            }
                          }
                        }

                        for (int i = 0; i < orgSelectedCategory.length; i++) {
                          int element = selectedCategory.elementAt(i);

                          String stringDate = format.format(date);
                          if (element < 10) {
                            stringDate = '$stringDate-0$element';
                          } else {
                            stringDate = '$stringDate-$element';
                          }
                          // print(stringDate);

                          if (!selectedCategory.contains(element)) {
                            int index = 0;
                            Categories category = categories.elementAt(index);
                            ScheduledWorkout? scheduleWorkout =
                                await scheduledWorkoutRepository
                                    .getScheduledWorkoutFromUserIdByStartDate(
                                        uid: userMaster!.UM_ID,
                                        refId: category.cs_name,
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

                            ///Notification Remove in firebase
                            int index1 = 0;
                            List<NotificationAlert> userNotify =
                                await notificationAlertRepository
                                    .getAllNotificationAlertByRefId(
                                        refId: category.cs_name,
                                        userId: userMaster!.UM_ID);
                            final result1 =
                                await notificationAlertRepository.delete(
                                    na_id: userNotify.elementAt(index1).NA_ID);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(result1
                                    ? "${getTranslated(context, 'fav_rem')}"
                                    : "${getTranslated(context, 'error')}")));
                          }
                        }
                        for (int i = 0; i < selectedCategory.length; i++) {
                          int index = 0;
                          Categories category = categories.elementAt(index);
                          int element = selectedCategory[i];
                          String dateString = format.format(date);
                          String tempDay = "";
                          if (element < 10) {
                            tempDay = '0$element';
                          } else {
                            tempDay = '$element';
                          }
                          dateString = '$dateString-$tempDay';
                          final result =
                              await scheduledWorkoutRepository.isExist(
                                  uid: userMaster!.UM_ID,
                                  refId: category.cs_name,
                                  date: dateString);
                          if (!result) {
                            ScheduledWorkout scheduledWorkout =
                                ScheduledWorkout(
                                    SW_ID: '',
                                    UM_ID: userMaster!.UM_ID,
                                    REF_ID: category.CS_ID,
                                    REF_TYPE: 'category',
                                    sw_scheduledDate:
                                        Constants.getCurrentDate(),
                                    sw_scheduledForDate: dateString,
                                    sw_scheduledTime:
                                        Constants.getCurrentTime(),
                                    sw_isActive: true);
                            scheduledWorkout = await scheduledWorkoutRepository
                                .save(scheduledWorkout: scheduledWorkout);

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

                            ///Notification Add in firebase
                            NotificationAlert userNotification =
                                NotificationAlert(
                                    NA_ID: "",
                                    UM_ID: userMaster!.UM_ID,
                                    na_refType: category.cs_name,
                                    na_refId: category.CS_ID,
                                    na_refImage: category.cs_image,
                                    na_adt: dateString);
                            await notificationAlertRepository.save(
                                notificationAlert: userNotification);

                            await showNotificationForWorkout(
                                id: id,
                                title: category.cs_name,
                                body: scheduledWorkout.sw_scheduledForDate,
                                payload: scheduledWorkout.SW_ID,
                                startDate:
                                    scheduledWorkout.sw_scheduledForDate);

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
                            content: Text(
                                "${getTranslated(context, 'scheduled')}")));
                        // await loadScheduledExercises();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text(
                          "${getTranslated(context, 'save')}",
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
            ],
          ),
        );
      });
    });
  }

  Widget getDayContainer(
      {required String header,
      required bool isCompleted,
      required String footer,
      required int containerIndex,
      required dynamic setState}) {
    return InkWell(
      onTap: () {
        if (scheduledDays.contains(int.parse(footer))) {
          scheduledDays.remove(int.parse(footer));
        } else {
          scheduledDays.add(int.parse(footer));
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
                  color: isCompleted
                      ? Theme.of(context).disabledColor.withOpacity(0.14)
                      : Colors.white),
              child: scheduledDays.contains(int.parse(footer))
                  ? Icon(
                      Icons.check,
                      size: 17.0,
                      // color: Colors.white,
                    )
                  : Container(),
            ),
            Text(footer)
          ],
        ),
      ),
    );
  }

  String getCamelCaseWord(String input) {
    String output = '';
    output = input.characters.first.toString().toUpperCase();
    output = output + input.substring(1);
    return output;
  }
}
