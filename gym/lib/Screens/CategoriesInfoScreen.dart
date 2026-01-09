// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
//
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../Screens/MusicProviderScreen.dart';
// import '../firebase/DB/Models/Equipments.dart';
// import '../firebase/DB/Models/Exercises.dart';
// import '../firebase/DB/Models/Exercises_Equipments.dart';
// import '../firebase/DB/Repo/EquipmentsRepository.dart';
// import '../firebase/DB/Repo/ExercisesRepository.dart';
// import '../firebase/DB/Repo/Exercises_EquipmentsRepository.dart';
// import '../firebase/DB/Repo/NotificationAlertRepository.dart';
// import '../firebase/DB/Repo/ScheduledWorkoutRepository.dart';
// import '../firebase/DB/Repo/UserRepository.dart';
// import '../firebase/Storage/StorageHandler.dart';
// import 'package:intl/intl.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Components/EquipmentCarousel.dart';
// import '../Util/Constants.dart';
// import '../Util/Equipment.dart';
// import '../firebase/DB/Models/NotificationAlert.dart';
// import '../firebase/DB/Models/ScheduledWorkout.dart';
// import '../firebase/DB/Models/UserMaster.dart';
//
// class CategoriesInfoScreen extends StatefulWidget {
//   Exercises? exercises;
//   CategoriesInfoScreen({Key? key, required this.exercises}) : super(key: key);
//
//   static const String route = 'CategoriesInfoScreen';
//   @override
//   State<CategoriesInfoScreen> createState() => _CategoriesInfoScreenState();
// }
//
// class _CategoriesInfoScreenState extends State<CategoriesInfoScreen> {
//   StorageHandler storageHandler = StorageHandler();
//   String loaderUrl =
//       "https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc";
//   String loaderUrl2 =
//       "https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader4-unscreen.gif?alt=media&token=a6d1d873-3ed0-4406-b28f-1823a72bb1aa";
//
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   UserMaster? userMaster;
//   List<int> scheduledDays = [];
//   List<int> orgScheduledDays = [];
//   List<ScheduledWorkout> scheduledExercises = [];
//   List<NotificationAlert> notificationAlertList = [];
//
//   ScheduledWorkoutRepository scheduledWorkoutRepository =
//       ScheduledWorkoutRepository();
//   ExercisesRepository exercisesRepository = ExercisesRepository();
//   UserRepository userRepository = UserRepository();
//   NotificationAlertRepository notificationAlertRepository =
//       NotificationAlertRepository();
//
//   BoxDecoration decoration = BoxDecoration(
//       shape: BoxShape.rectangle,
//       borderRadius: BorderRadius.circular(10.0),
//       color: Colors.white,
//       boxShadow: [
//         BoxShadow(
//             color: Colors.blue.shade50,
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(4, 4)),
//         BoxShadow(
//             color: Colors.grey.shade300,
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(-4, -4)),
//       ]);
//
//   Future<void> loadUser() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     // print(user);
//     if (user != null) {
//       userMaster = await userRepository.getUserFromId(uid: user.uid);
//       context.loaderOverlay.hide();
//       setState(() {});
//     }
//   }
//
//   Future<void> loadScheduledExercises() async {
//     await loadUser();
//     DateTime startDate = DateTime.now();
//     // startDate = startDate.add(const Duration(days: 1));
//     DateTime endDate = startDate.add(const Duration(days: 7));
//     DateFormat dateFormat = DateFormat("yyyy-MM-dd");
//
//     List<ScheduledWorkout> tempScheduledWorkouts =
//         await scheduledWorkoutRepository
//             .getAllScheduledWorkoutFromUserIdByStartDate(
//                 uid: userMaster!.UM_ID,
//                 startDate: dateFormat.format(startDate).toString(),
//                 refId: widget.exercises!.Es_ID,
//                 endDate: dateFormat.format(endDate).toString());
//
//     for (var element in tempScheduledWorkouts) {
//       DateFormat format = DateFormat("dd");
//       String day = format.format(DateTime.parse(element.sw_scheduledForDate));
//       if (!scheduledDays.contains(int.parse(day))) {
//         scheduledDays.add(int.parse(day));
//         orgScheduledDays.add(int.parse(day));
//       }
//     }
//   }
//
//   Future<void> loadNotification() async {
//     await loadUser();
//     int index = 0;
//     List<NotificationAlert> tempNotify =
//         await notificationAlertRepository.getAllNotificationAlertByRefId(
//             refId: widget.exercises!.Es_ID, userId: userMaster!.UM_ID);
//
//     if (tempNotify.isNotEmpty) {
//       setState(() {
//         if (scheduledDays.contains(index)) {
//           scheduledDays.remove(index);
//         } else {
//           scheduledDays.add(index);
//         }
//       });
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadUser();
//     loadScheduledExercises();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       key: scaffoldKey,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               height:
//                   MediaQuery.of(context).size.height * 0.25 + kToolbarHeight,
//               width: MediaQuery.of(context).size.width,
//               child: FutureBuilder(
//                 future: storageHandler.getImageUrl(widget.exercises!.es_image),
//                 builder:
//                     (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   return CachedNetworkImage(
//                     imageUrl: snapshot.data != null && snapshot.data != ''
//                         ? snapshot.data!
//                         : loaderUrl2,
//                     fit: BoxFit.cover,
//                   );
//                 },
//                 initialData:
//                     'https://firebasestorage.googleapis.com/v0/b/thatsendfitness.appspot.com/o/public%2Floader3-unscreen.gif?alt=media&token=ec6b5d6e-a7f2-4d6a-847b-97da7b09dcdc',
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height:
//                     MediaQuery.of(context).size.height * 0.75 - kToolbarHeight,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(25.0),
//                         topLeft: Radius.circular(25.0))),
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(25.0)),
//                         padding: EdgeInsets.only(
//                             top: 25.0, left: 20, right: 20.0, bottom: 25.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                     child: Text(
//                                   widget.exercises!.es_name,
//                                   textAlign: TextAlign.start,
//                                   style: const TextStyle(
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.bold),
//                                 ))
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 15.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                       child: Text(
//                                     widget.exercises!.es_description,
//                                     textAlign: TextAlign.justify,
//                                     style: TextStyle(
//                                       fontSize: 14.0,
//                                     ),
//                                   ))
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 15.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     height: 75,
//                                     width: 100.0,
//                                     padding: EdgeInsets.all(7.0),
//                                     decoration: decoration,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset(
//                                           'assets/images/watch.png',
//                                           width: 35,
//                                           height: 35,
//                                         ),
//                                         Text(
//                                             '${widget.exercises!.es_duration} ${widget.exercises!.es_durationin}')
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 75,
//                                     width: 100.0,
//                                     padding: EdgeInsets.all(7.0),
//                                     decoration: decoration,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset(
//                                           'assets/images/kal.png',
//                                           width: 40,
//                                           height: 40,
//                                         ),
//                                         Text('${widget.exercises!.es_kal} kal')
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 75,
//                                     width: 100.0,
//                                     padding: EdgeInsets.all(7.0),
//                                     decoration: decoration,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset(
//                                           'assets/images/levels-removebg-preview.png',
//                                           width: 40,
//                                           height: 40,
//                                         ),
//                                         Text(getCamelCaseWord(
//                                             widget.exercises!.es_level))
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 20.0, left: 15.0, right: 15.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(25.0)),
//                           padding: EdgeInsets.only(
//                               top: 5.0, left: 20, right: 20.0, bottom: 5.0),
//                           child: Column(
//                             children: [
//                               ListTile(
//                                 visualDensity:
//                                     VisualDensity(horizontal: 0, vertical: -4),
//                                 onTap: () {},
//                                 contentPadding: EdgeInsets.zero,
//                                 isThreeLine: false,
//                                 title: Text('Equipments'),
//                                 trailing: Text(""),
//                                 tileColor: Colors.white,
//                               ),
//                               Divider(),
//                               ListTile(
//                                 visualDensity:
//                                     VisualDensity(horizontal: 0, vertical: -4),
//                                 onTap: () {},
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text('Focus Area'),
//                                 trailing: Text(getCamelCaseWord(
//                                     widget.exercises!.es_type)),
//                                 tileColor: Colors.white,
//                               ),
//                               Divider(),
//                               ListTile(
//                                 visualDensity:
//                                     VisualDensity(horizontal: 0, vertical: -4),
//                                 onTap: () {
//                                   scheduleExercise(context);
//                                 },
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text('Schedule exercise'),
//                                 trailing: IconButton(
//                                   onPressed: () {
//                                     scheduleExercise(context);
//                                   },
//                                   icon: Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 15.0,
//                                   ),
//                                 ),
//                                 tileColor: Colors.white,
//                               ),
//                               // Divider(),
//                               // ListTile(
//                               //   visualDensity:
//                               //   VisualDensity(horizontal: 0, vertical: -4),
//                               //   onTap: () {
//                               //     // showInfo(context);
//                               //     Navigator.pushNamed(context, MusicProviderScreen.route);
//                               //   },
//                               //   contentPadding: EdgeInsets.zero,
//                               //   title: Text('Pick a playlist'),
//                               //   trailing: IconButton(
//                               //     onPressed: () {
//                               //       Navigator.pushNamed(context, MusicProviderScreen.route);
//                               //
//                               //     },
//                               //     icon: Icon(
//                               //       Icons.arrow_forward_ios,
//                               //       size: 15.0,
//                               //     ),
//                               //   ),
//                               //   tileColor: Colors.white,
//                               // ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//                 top: 10.0,
//                 left: 10.0,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                         color: Colors.white, shape: BoxShape.circle),
//                     child: const Icon(
//                       Icons.arrow_back,
//                       size: 23,
//                       color: Colors.black,
//                     ),
//                   ),
//                 )),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> scheduleExercise(BuildContext context) async {
//     scaffoldKey.currentState!.showBottomSheet(
//         elevation: 0,
//         backgroundColor: Colors.blue.shade50,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25.0),
//             topRight: Radius.circular(25.0),
//           ),
//         ), (context) {
//       DateTime startDate = DateTime.now();
//       startDate = startDate.add(const Duration(days: 1));
//       DateFormat format = DateFormat('EEEE');
//       /*int weekDay = startDate.weekday ;
//         startDate = startDate.subtract(Duration(days: weekDay));*/
//       return StatefulBuilder(builder: (context, setState) {
//         return SizedBox(
//             height: MediaQuery.of(context).size.height * 0.6,
//             width: MediaQuery.of(context).size.width,
//             child: Stack(children: [
//               Wrap(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(Icons.cancel_outlined),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                             child: Text(
//                           'Schedule exercise',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 20.0, fontWeight: FontWeight.bold),
//                         ))
//                       ],
//                     ),
//                   ),
//                   Wrap(
//                     children: [
//                       SizedBox(
//                         height: 80.0,
//                         width: MediaQuery.of(context).size.width,
//                         child: ListView(
//                           physics: const BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           children: [
//                             getDayContainer(
//                                 setState: setState,
//                                 containerIndex: 1,
//                                 header: format
//                                     .format(startDate)
//                                     .toString()
//                                     .substring(0, 1),
//                                 isCompleted:
//                                     scheduledDays.contains(startDate.day),
//                                 footer: startDate.day.toString()),
//                             getDayContainer(
//                                 setState: setState,
//                                 containerIndex: 2,
//                                 header: format
//                                     .format(
//                                         startDate.add(const Duration(days: 1)))
//                                     .toString()
//                                     .substring(0, 1),
//                                 isCompleted: scheduledDays.contains(
//                                     startDate.add(const Duration(days: 1)).day),
//                                 footer: startDate
//                                     .add(const Duration(days: 1))
//                                     .day
//                                     .toString()),
//                             getDayContainer(
//                                 setState: setState,
//                                 containerIndex: 3,
//                                 header: format
//                                     .format(
//                                         startDate.add(const Duration(days: 2)))
//                                     .toString()
//                                     .substring(0, 1),
//                                 isCompleted: scheduledDays.contains(
//                                     startDate.add(const Duration(days: 2)).day),
//                                 footer: startDate
//                                     .add(const Duration(days: 2))
//                                     .day
//                                     .toString()),
//                             getDayContainer(
//                                 setState: setState,
//                                 containerIndex: 4,
//                                 header: format
//                                     .format(
//                                         startDate.add(const Duration(days: 3)))
//                                     .toString()
//                                     .substring(0, 1),
//                                 isCompleted: scheduledDays.contains(
//                                     startDate.add(const Duration(days: 3)).day),
//                                 footer: startDate
//                                     .add(const Duration(days: 3))
//                                     .day
//                                     .toString()),
//                             getDayContainer(
//                                 setState: setState,
//                                 containerIndex: 5,
//                                 header: format
//                                     .format(
//                                         startDate.add(const Duration(days: 4)))
//                                     .toString()
//                                     .substring(0, 1),
//                                 isCompleted: scheduledDays.contains(
//                                     startDate.add(const Duration(days: 4)).day),
//                                 footer: startDate
//                                     .add(const Duration(days: 4))
//                                     .day
//                                     .toString()),
//                             getDayContainer(
//                                 setState: setState,
//                                 containerIndex: 6,
//                                 header: format
//                                     .format(
//                                         startDate.add(const Duration(days: 5)))
//                                     .toString()
//                                     .substring(0, 1),
//                                 isCompleted: scheduledDays.contains(
//                                     startDate.add(const Duration(days: 5)).day),
//                                 footer: startDate
//                                     .add(const Duration(days: 5))
//                                     .day
//                                     .toString()),
//                             getDayContainer(
//                                 setState: setState,
//                                 containerIndex: 7,
//                                 header: format
//                                     .format(
//                                         startDate.add(const Duration(days: 6)))
//                                     .toString()
//                                     .substring(0, 1),
//                                 isCompleted: scheduledDays.contains(
//                                     startDate.add(const Duration(days: 6)).day),
//                                 footer: startDate
//                                     .add(const Duration(days: 6))
//                                     .day
//                                     .toString()),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Positioned(
//                 bottom: 25.0,
//                 child: Padding(
//                     padding: const EdgeInsets.only(
//                         top: 25.0, left: 15.0, right: 15.0),
//                     child: InkWell(
//                       onTap: () async {
//                         this.context.loaderOverlay.show();
//                         DateTime date = DateTime.now();
//                         DateFormat format = DateFormat('yyyy-MM');
//
//                         /* print('ORGSCHDATES:');
//                         print('$orgScheduledDays');
//                         print('SCHDATES:');dd
//                         print('$scheduledDays:');*/
//                         for (int i = 0; i < orgScheduledDays.length; i++) {
//                           int element = orgScheduledDays.elementAt(i);
//
//                           String stringDate = format.format(date);
//                           if (element < 10) {
//                             stringDate = '$stringDate-0$element';
//                           } else {
//                             stringDate = '$stringDate-$element';
//                           }
//                           // print(stringDate);
//
//                           if (!scheduledDays.contains(element)) {
//                             ScheduledWorkout? scheduleWorkout =
//                                 await scheduledWorkoutRepository
//                                     .getScheduledWorkoutFromUserIdByStartDate(
//                                         uid: userMaster!.UM_ID,
//                                         refId: widget.exercises!.Es_ID,
//                                         date: stringDate);
//                             if (scheduleWorkout != null) {
//                               await scheduledWorkoutRepository.delete(
//                                   sw_ID: scheduleWorkout.SW_ID);
//
//                               SharedPreferences sharedPref =
//                                   await SharedPreferences.getInstance();
//                               List<String> storedIds = sharedPref.getStringList(
//                                       Constants.faStoredNotificationIdKey) ??
//                                   [];
//
//                               Map<String, dynamic> notificationData =
//                                   Map.fromEntries(
//                                       [MapEntry(scheduleWorkout.SW_ID, 0)]);
//                               List<String> existingMap =
//                                   sharedPref.getStringList(Constants
//                                           .faStoredNotificationMapKey) ??
//                                       [];
//
//                               for (var element in existingMap) {
//                                 Map<String, dynamic> decodedString =
//                                     json.decode(element);
//
//                                 if (decodedString.keys.first ==
//                                     notificationData.keys.first) {
//                                   existingMap.remove(element);
//                                   storedIds.remove(
//                                       decodedString.values.first.toString());
//                                   AwesomeNotifications()
//                                       .cancel(decodedString.values.first);
//                                   sharedPref.setStringList(
//                                       Constants.faStoredNotificationMapKey,
//                                       existingMap);
//                                   sharedPref.setStringList(
//                                       Constants.faStoredNotificationIdKey,
//                                       storedIds);
//                                   break;
//                                 }
//                               }
//                             }
//
//                             ///Notification Remove in firebase
//                             int index = 0;
//                             List<NotificationAlert> userNotify =
//                                 await notificationAlertRepository
//                                     .getAllNotificationAlertByRefId(
//                                         refId: widget.exercises!.Es_ID,
//                                         userId: userMaster!.UM_ID);
//                             final result1 =
//                                 await notificationAlertRepository.delete(
//                                     na_id: userNotify.elementAt(index).NA_ID);
//                             if (!mounted) return;
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content:
//                                     Text(result1 ? 'Fav Removed' : 'Error')));
//                           }
//                         }
//                         for (int i = 0; i < scheduledDays.length; i++) {
//                           int element = scheduledDays[i];
//                           String dateString = format.format(date);
//                           String tempDay = "";
//                           if (element < 10) {
//                             tempDay = '0$element';
//                           } else {
//                             tempDay = '$element';
//                           }
//                           dateString = '$dateString-$tempDay';
//                           final result =
//                               await scheduledWorkoutRepository.isExist(
//                                   uid: userMaster!.UM_ID,
//                                   refId: widget.exercises!.Es_ID,
//                                   date: dateString);
//                           if (!result) {
//                             ScheduledWorkout scheduledWorkout =
//                                 ScheduledWorkout(
//                                     SW_ID: '',
//                                     UM_ID: userMaster!.UM_ID,
//                                     REF_ID: widget.exercises!.Es_ID,
//                                     REF_TYPE: 'exercise',
//                                     sw_scheduledDate:
//                                         Constants.getCurrentDate(),
//                                     sw_scheduledForDate: dateString,
//                                     sw_scheduledTime:
//                                         Constants.getCurrentTime(),
//                                     sw_isActive: true);
//                             scheduledWorkout = await scheduledWorkoutRepository
//                                 .save(scheduledWorkout: scheduledWorkout);
//
//                             SharedPreferences sharedPref =
//                                 await SharedPreferences.getInstance();
//                             List<String> storedIds = sharedPref.getStringList(
//                                     Constants.faStoredNotificationIdKey) ??
//                                 [];
//
//                             int id = Random().nextInt(99999999);
//                             while (storedIds.contains(id.toString())) {
//                               id = Random().nextInt(99999999);
//                             }
//                             // print(id);
//                             Map<String, int> notificationData = Map.fromEntries(
//                                 [MapEntry(scheduledWorkout.SW_ID, id)]);
//                             List<String> existingMap = sharedPref.getStringList(
//                                     Constants.faStoredNotificationMapKey) ??
//                                 [];
//
//                             // print(existingMap);
//                             final isNotExist = existingMap.every((element) {
//                               Map<String, dynamic> decodedString =
//                                   json.decode(element);
//                               if (decodedString.keys.first ==
//                                   notificationData.keys.first) {
//                                 return false;
//                               }
//                               return true;
//                             });
//                             if (isNotExist) {
//                               // existingMap.add(JsonEncoder().convert(notificationData));
//
//                               existingMap.add(json.encode(notificationData));
//                               storedIds.add(id.toString());
//                               sharedPref.setStringList(
//                                   Constants.faStoredNotificationMapKey,
//                                   existingMap);
//                               sharedPref.setStringList(
//                                   Constants.faStoredNotificationIdKey,
//                                   storedIds);
//                             }
//
//                             ///Notification Add in firebase
//                             NotificationAlert userNotification =
//                                 NotificationAlert(
//                                     NA_ID: "",
//                                     UM_ID: userMaster!.UM_ID,
//                                     na_refType: widget.exercises!.es_name,
//                                     na_refId: widget.exercises!.Es_ID,
//                                     na_refImage: widget.exercises!.es_image,
//                                     na_adt: dateString);
//                             await notificationAlertRepository.save(
//                                 notificationAlert: userNotification);
//
//                             await showNotificationForWorkout(
//                                 id: id,
//                                 title: widget.exercises!.es_name,
//                                 body: scheduledWorkout.sw_scheduledForDate,
//                                 payload: scheduledWorkout.SW_ID,
//                                 scheduleForDate:
//                                     scheduledWorkout.sw_scheduledForDate);
//
//                             if (!orgScheduledDays.contains(element)) {
//                               orgScheduledDays.add(element);
//                             }
//                           }
//                         }
//                         this.context.loaderOverlay.hide();
//                         if (!mounted) return;
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             backgroundColor: Colors.green.shade500,
//                             content: Text('Scheduled')));
//                         // await loadScheduledExercises();
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width - 30.0,
//                         height: 50.0,
//                         decoration: BoxDecoration(
//                             color: Colors.blue.shade900,
//                             border: Border.all(),
//                             borderRadius: BorderRadius.circular(40.0)),
//                         child: const Text(
//                           'Schedule exercise',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20.0,
//                               letterSpacing: 1.0,
//                               fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     )),
//               )
//             ]));
//       });
//     });
//   }
//
//   Widget getDayContainer(
//       {required String header,
//       required bool isCompleted,
//       required String footer,
//       required int containerIndex,
//       required dynamic setState}) {
//     return InkWell(
//       onTap: () {
//         if (scheduledDays.contains(int.parse(footer))) {
//           scheduledDays.remove(int.parse(footer));
//         } else {
//           scheduledDays.add(int.parse(footer));
//         }
//         setState(() {});
//       },
//       child: SizedBox(
//         width: (MediaQuery.of(context).size.width) / 7,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             header.trim().isEmpty ? Container() : Text(header),
//             Container(
//               height: 25.0,
//               width: 25.0,
//               decoration: BoxDecoration(
//                   border: Border.all(),
//                   borderRadius: BorderRadius.circular(50.0),
//                   color: isCompleted ? Colors.blue.shade900 : Colors.white),
//               child: scheduledDays.contains(int.parse(footer))
//                   ? Icon(
//                       Icons.check,
//                       size: 17.0,
//                       color: Colors.white,
//                     )
//                   : Container(),
//             ),
//             Text(footer)
//           ],
//         ),
//       ),
//     );
//   }
//
//   String getCamelCaseWord(String input) {
//     String output = '';
//     output = input.characters.first.toString().toUpperCase();
//     output = output + input.substring(1);
//     return output;
//   }
//
//   Future<void> showNotificationForWorkout(
//       {required int id,
//       required String title,
//       required String body,
//       required String payload,
//       required String scheduleForDate}) async {
//     StorageHandler storageHandler = StorageHandler();
//     String imageUrl =
//         await storageHandler.getImageUrl(widget.exercises!.es_image);
//     // print('SCHEDULED ON :${DateTime.parse(scheduleForDate).add(Duration(hours: 6))}');
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             // icon: "resource://drawable/1.jpg",
//             bigPicture: imageUrl,
//             largeIcon: imageUrl,
//             id: id,
//             channelKey: 'basic_channel',
//             title: title,
//             body: body,
//             notificationLayout: NotificationLayout.BigPicture,
//             // bigPicture: widget.workout.ws_image,
//             payload: {'uuid': payload},
//             category: NotificationCategory.Reminder
//             // autoDismissible: false,
//
//             ),
//         schedule: NotificationCalendar.fromDate(
//             date: DateTime.parse(scheduleForDate).add(Duration(hours: 6)),
//             allowWhileIdle: true));
//   }
// }
