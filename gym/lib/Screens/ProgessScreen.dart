import '../local/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../Components/WeightProgressBarChartMonth.dart';
import '../Components/WeightProgressLineChartYear.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'package:intl/intl.dart';
import '../Components/WeightProgressBarChart.dart';
import '../Components/WeightProgressLineChart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  static const String route = 'progress';

  // static const String route = '/';
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  String current = 'Week';

  // List<String> filters = <String>['Week', 'Month', 'Year'];

  List<int> scheduledDays = [];

  UserMaster? userMaster;
  List<UserMasterWorkout> userWorkouts = [];

  UserRepository userRepository = UserRepository();
  UserMasterWorkoutRepository userMasterWorkoutRepository =
      UserMasterWorkoutRepository();

  late TabController controller;

  List<BarChartGroupData> barChartGroupData = [];
  List<BarChartGroupData> barChartGroupDataMonth = [];
  List<BarChartGroupData> barChartGroupDataYear = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    loadUser();
    loadUserMasterWorkouts();
    loadUserMasterWorkoutsMonth();
    loadUserMasterWorkoutsYear();
  }

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
    }
    setState(() {});
  }

  Future<void> loadUserMasterWorkouts() async {
    await loadUser();
    userWorkouts = await userMasterWorkoutRepository
        .getAllUserMasterWorkoutFromUserIdByLimit(
            uid: userMaster!.UM_ID, limit: 100);

    DateTime startDate = DateTime.now();
    DateFormat format = DateFormat("yyyy-MM-dd");

    List<String> dates = [
      format.format(startDate.subtract(const Duration(days: 6))),
      format.format(startDate.subtract(const Duration(days: 5))),
      format.format(startDate.subtract(const Duration(days: 4))),
      format.format(startDate.subtract(const Duration(days: 3))),
      format.format(startDate.subtract(const Duration(days: 2))),
      format.format(startDate.subtract(const Duration(days: 1))),
      format.format(startDate.subtract(const Duration(days: 0))),
    ];
    for (int i = 0; i < dates.length; i++) {
      int kal = 0;
      for (var element in userWorkouts) {
        if (dates[i].trim() == element.um_ws_startDate.trim()) {
          kal = kal + element.um_ws_kalBurned;
        }
      }
      var barGroup = makeGroupData(i, kal.toDouble());

      barChartGroupData.add(barGroup);
    }
    setState(() {});
  }

  Future<void> loadUserMasterWorkoutsMonth() async {
    await loadUser();
    userWorkouts = await userMasterWorkoutRepository
        .getAllUserMasterWorkoutFromUserIdByLimit(
            uid: userMaster!.UM_ID, limit: 100);

    DateTime startDate = DateTime.now();
    // DateTime month = DateTime.parse(startDate.month.toString());
    DateFormat format = DateFormat("MMM");

    List<String> months = [
      format.format(startDate.subtract(Duration(days: startDate.month + 6))),
      format.format(startDate.subtract(Duration(days: startDate.month + 5))),
      format.format(startDate.subtract(Duration(days: startDate.month + 4))),
      format.format(startDate.subtract(Duration(days: startDate.month + 3))),
      format.format(startDate.subtract(Duration(days: startDate.month + 2))),
      format.format(startDate.subtract(Duration(days: startDate.month + 1))),
      format.format(startDate.subtract(Duration(days: startDate.month + 0))),
    ];

    for (int i = 0; i < months.length; i++) {
      int kal1 = 0;
      for (var element in userWorkouts) {
        if (months[i].trim() == element.um_ws_startDate.trim()) {
          kal1 = kal1 + element.um_ws_kalBurned;
        }
      }
      var barGroup = makeGroupData(i, kal1.toDouble());

      barChartGroupDataMonth.add(barGroup);
    }
    setState(() {});
  }

  Future<void> loadUserMasterWorkoutsYear() async {
    await loadUser();
    userWorkouts = await userMasterWorkoutRepository
        .getAllUserMasterWorkoutFromUserIdByLimit(
            uid: userMaster!.UM_ID, limit: 100);

    DateTime startDate = DateTime.now();
    // DateTime month = DateTime.parse(startDate.month.toString());
    DateFormat format = DateFormat("yyyy");

    List<String> year = [
      format.format(startDate.subtract(Duration(days: startDate.year + 6))),
      format.format(startDate.subtract(Duration(days: startDate.year + 5))),
      format.format(startDate.subtract(Duration(days: startDate.year + 4))),
      format.format(startDate.subtract(Duration(days: startDate.year + 3))),
      format.format(startDate.subtract(Duration(days: startDate.year + 2))),
      format.format(startDate.subtract(Duration(days: startDate.year + 1))),
      format.format(startDate.subtract(Duration(days: startDate.year + 0))),
    ];
    for (int i = 0; i < year.length; i++) {
      int kal2 = 0;
      for (var element in userWorkouts) {
        if (year[i].trim() == element.um_ws_startDate.trim()) {
          kal2 = kal2 + element.um_ws_kalBurned;
        }
      }
      var barGroup = makeGroupData(i, kal2.toDouble());

      barChartGroupDataYear.add(barGroup);
    }
    setState(() {});
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.blue.shade900,
          width: 7,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.now();
    // startDate = startDate.subtract(const Duration(days: 1));
    DateFormat format = DateFormat('EEEE');

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        // backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        title: Text(
          "${getTranslated(context, 'summary')}",
          style: TextStyle(color: Theme.of(context).textTheme.headline5!.color),
        ),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
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
                    text: "${getTranslated(context, 'week')}",
                  ),
                  Tab(
                    height: 30,
                    text: "${getTranslated(context, 'month')}",
                  ),
                  Tab(
                    height: 30,
                    text: "${getTranslated(context, 'year')}",
                  ),
                ],
                controller: controller,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
        height: MediaQuery.of(context).size.height - 170,
        width: MediaQuery.of(context).size.width,
        child: TabBarView(
          viewportFraction: 1.0,
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${getTranslated(context, 'kal_burn')}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  WeightProgressBarChart(
                    barChartGroupData: barChartGroupData,
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Weight tracking'),
                      Text('History')
                    ],
                  ),
                  const WeightProgressLineChart(),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("${getTranslated(context, 'kal_burn')}")],
                  ),
                  WeightProgressBarChartMonth(
                      barChartGroupDataMonth: barChartGroupDataMonth)
                ],
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  /*  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Weight tracking'),
                      Text('History')
                    ],
                  ),
                  const WeightProgressLineChart(),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("${getTranslated(context, 'kal_burn')}")],
                  ),
                  WeightProgressBarChartYear(
                      barChartGroupDataYear: barChartGroupDataYear),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                  color: isCompleted ? Colors.blue.shade900 : Colors.white),
              child: scheduledDays.contains(int.parse(footer))
                  ? Icon(
                      Icons.check,
                      size: 17.0,
                      color: Colors.white,
                    )
                  : Container(),
            ),
            Text(footer)
          ],
        ),
      ),
    );
  }
}
