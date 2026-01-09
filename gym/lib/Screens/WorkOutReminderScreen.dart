import '../Provider/ReminderWorkoutProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Screens/CreateWorkoutReminder.dart';
import '../firebase/DB/Models/ReminderWorkout.dart';
import '../firebase/DB/Repo/ReminderWorkoutsRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/DB/Repo/WorkoutsRepository.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../Util/Constants.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/Storage/StorageHandler.dart';
import '../local/localization/language_constants.dart';

class WorkOutReminderScreen extends StatefulWidget {
  static const String route = 'WorkoutReminder';

  const WorkOutReminderScreen({Key? key}) : super(key: key);

  @override
  State<WorkOutReminderScreen> createState() => _WorkOutReminderScreenState();
}

class _WorkOutReminderScreenState extends State<WorkOutReminderScreen> {
  bool isPinLock = false;

  List<ReminderWorkouts> reminderWorkouts = [];
  UserMaster? userMaster;

  UserRepository userRepository = UserRepository();
  ReminderWorkoutsRepository reminderWorkoutsRepository =
      ReminderWorkoutsRepository();
  WorkoutsRepository workoutsRepository = WorkoutsRepository();
  ReminderWorkoutProvider reminderWorkoutProvider = ReminderWorkoutProvider();

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
    }
  }

  Future<void> loadUserReminderWorkouts() async {
    // userWorkouts.clear();
    await loadUser();
    // DateTime now = DateTime.now();
    await reminderWorkoutProvider.reminderProvider(userID: userMaster!.UM_ID);
    context.loaderOverlay.hide();
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    reminderWorkoutProvider =
        Provider.of<ReminderWorkoutProvider>(context, listen: false);
    loadUserReminderWorkouts();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.loaderOverlay.show();
      }
    });
  }

  String currentDate = "";
  String previousDate = "";

  // bool isSecond = false;

  @override
  Widget build(BuildContext context) {
    reminderWorkoutProvider =
        Provider.of<ReminderWorkoutProvider>(context, listen: false);

    DateTime startDate = DateTime.now();
    startDate = startDate.add(const Duration(days: 0));
    // DateFormat format = DateFormat('EEEE');

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
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Colors.transparent,
          title: Text(
            "${getTranslated(context, 'workout_reminders')}",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5!.color),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CreateWorkOutReminder.route);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: reminderWorkoutProvider.reminderWorkouts.isEmpty
            ? Container()
            : ListView.builder(
                itemBuilder: (context, index) {
                  ReminderWorkouts reminderWorkouts0 =
                      reminderWorkoutProvider.reminderWorkouts.elementAt(index);
                  // String refType = reminderWorkouts0.WS_ID.trim().toLowerCase();
                  return Column(
                    children: [
                      // previousDate == "" || currentDate != previousDate
                      //     ? getDateTag(DateTime.parse(currentDate), "")
                      //     : Container(),

                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(color: Colors.grey),
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.11)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reminderWorkouts0.WS_ID.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  reminderWorkouts0.rw_reminderTime,
                                  // style: const TextStyle(),
                                ),
                              ],
                            ),
                            CupertinoSwitch(
                                onChanged: (value) async {
                                  context.loaderOverlay.show();

                                  // reminderWorkouts0.rw_isActive = value;

                                  ReminderWorkouts objRW = ReminderWorkouts(
                                      RW_ID: reminderWorkouts0.RW_ID,
                                      UM_ID: userMaster!.UM_ID,
                                      WS_ID: 'Lets Start Workouts',
                                      rw_reminderDay:
                                          Constants.getCurrentDate(),
                                      rw_scheduledForDay:
                                          reminderWorkouts0.rw_scheduledForDay,
                                      rw_reminderTime:
                                          reminderWorkouts0.rw_reminderTime,
                                      rw_isActive: value);
                                  var response =
                                      await reminderWorkoutsRepository.update(
                                          reminderWorkouts: objRW);

                                  if (response != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                Colors.green.shade500,
                                            content: Text(
                                                "${getTranslated(context, 'set_reminder')}")));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                Colors.red.shade500,
                                            content: const Text(
                                                'not_set_reminder')));
                                  }

                                  setState(() {
                                    reminderWorkouts[index] = objRW;
                                  });

                                  if (context.loaderOverlay.visible) {
                                    context.loaderOverlay.hide();
                                  }
                                },

                                /*onChanged: (bool value) async {

                                  setState(()  {
                                    reminderWorkouts0.rw_isActive = value;

                                  });
                                },*/
                                value: reminderWorkouts0.rw_isActive,
                                activeColor: Colors.blue.shade900),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                itemCount: reminderWorkoutProvider.reminderWorkouts.length,
              ),
      ),
    );
  }

  StorageHandler storageHandler = StorageHandler();

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
}
