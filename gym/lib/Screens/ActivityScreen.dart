// ignore_for_file: unused_field

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import '../firebase/DB/Models/Trainings.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Models/UserMaster_Workout.dart';
import '../firebase/DB/Repo/UserMasterWorkoutRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:wakelock/wakelock.dart';
import '../Components/ActivitySleepBarChart.dart';
import '../Util/ChartForHartRate.dart';
import '../local/localization/language_constants.dart';

class ActivityScreen extends StatefulWidget {
  List<Trainings> trainings = [];

  ActivityScreen({Key? key, required this.trainings}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  bool _toggled = false; // toggle button value
  final List<SensorValue> _data = <SensorValue>[]; // array to store the values
  CameraController? _controller;
  final double _alpha = 0.3; // factor for the mean value
  AnimationController? _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  final int _fs = 30; // sampling frequency (fps)
  final int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage? _image; // store the last camera image
  double? _avg; // store the average value during calculation
  DateTime? _now; // store the now Datetime
  Timer? _timer; // timer for image processing

  String selectedDate = "";

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '', _steps = '0';

  void onStepCount(StepCount event) {
    // print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    // print(event);
    _status = event.status;
    if (!mounted) return;
    setState(() {});
  }

  void onPedestrianStatusError(error) {
    // print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    // print(_status);
  }

  void onStepCountError(error) {
    // print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState({required String date}) {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
    setState(() {});
  }

  /// list to store raw values in
  List<SensorValue> data = [];

  // List<SensorValue> bpmValues = [];

  /// variable to store measured BPM value
  // int? bpmValue;
  // bool isBPMEnabled = false;

  UserMaster? userMaster;
  UserRepository userRepository = UserRepository();

  List<UserMasterWorkout> userWorkouts = [];
  UserMasterWorkoutRepository userMasterWorkoutRepository =
      UserMasterWorkoutRepository();

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
    }
    setState(() {});
  }

  int kal = 0;
  int trainingTime = 0;

  // int stepByDate=0;
  int selectedDatebox = 0;

  // Widget? dialog;

  Future<void> loadKalForDate({required String date}) async {
    await loadUserMasterWorkouts();
    kal = 0;
    for (var element in userWorkouts) {
      if (date.trim() == element.um_ws_startDate.trim()) {
        kal = kal + element.um_ws_kalBurned;
      }
    }
    setState(() {});
  }

  Future<void> loadTrainingForDate({required String date}) async {
    await loadUserMasterWorkouts();
    trainingTime = 0;
    if (userWorkouts.length > 0) {
      for (var element in userWorkouts) {
        if (element.um_ws_totalSpentTime.isNotEmpty &&
            date.trim() == element.um_ws_startDate.trim()) {
          List dTime = element.um_ws_totalSpentTime.split(':');
          var oneExTime = Duration(
              hours: int.parse(dTime[0]),
              minutes: int.parse(dTime[1]),
              seconds: int.parse(dTime[2]));
          //Duration(hours: dTime[0], minutes: dTime[1], seconds: dTime[2]);
          trainingTime = trainingTime + oneExTime.inMinutes;
        }
      }
      setState(() {});
    }
  }

  Future<void> loadStepForDate({required String date}) async {
    initPlatformState(date: date);
    _steps = "0";
    if (date.trim() == _steps) {
      _steps = _steps + _steps.trim().toString();
    }
    setState(() {});
  }

  Future<void> loadUserMasterWorkouts() async {
    await loadUser();
    userWorkouts = await userMasterWorkoutRepository
        .getAllUserMasterWorkoutFromUserIdByLimit(
            uid: userMaster!.UM_ID, limit: 100);
  }

  /* Future<void> loadHeartRate() async {

    isBPMEnabled
        ? dialog = HeartBPMDialog(
      context: context,
      onRawData: (value) {
        setState(() {
          if (data.length >= 100) data.removeAt(0);
          data.add(value);
        });
        // chart = BPMChart(data);
      },
      onBPM: (value) => setState(() {
        if (bpmValues.length >= 100) bpmValues.removeAt(0);
        bpmValues.add(SensorValue(
            value: value.toDouble(), time: DateTime.now()));
      }),
      // sampleDelay: 1000 ~/ 20,
      // child: Container(
      //   height: 50,
      //   width: 100,
      //   child: BPMChart(data),
      // ),
    )
        : SizedBox();
    setState(() {
      if (isBPMEnabled) {
        isBPMEnabled = false;
        // dialog.
      } else
        isBPMEnabled = true;
    });
  }*/

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DateTime startDate = DateTime.now();
    DateFormat format = DateFormat("yyyy-MM-dd");
    loadKalForDate(date: format.format(startDate));
    initPlatformState(date: format.format(startDate));
    loadTrainingForDate(date: format.format(startDate));
  }

  @override
  void initState() {
    super.initState();
    requestMotionPermission();
    DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
    DateFormat format = DateFormat("yyyy-MM-dd");
    loadKalForDate(date: format.format(startDate));
    initPlatformState(date: format.format(startDate));
    loadTrainingForDate(date: format.format(startDate));
    // _updateBPM();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animationController!.addListener(() {
      setState(() {
        _iconScale = 1.0 + _animationController!.value * 0.4;
      });
    });

    // loadStepForDate(date: format.format(startDateSteps));
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      '${getTranslated(context, 'jan')}',
      '${getTranslated(context, 'feb')}',
      '${getTranslated(context, 'mar')}',
      '${getTranslated(context, 'apr')}',
      '${getTranslated(context, 'may')}',
      '${getTranslated(context, 'jun')}',
      '${getTranslated(context, 'jul')}',
      '${getTranslated(context, 'aug')}',
      '${getTranslated(context, 'sep')}',
      '${getTranslated(context, 'oct')}',
      '${getTranslated(context, 'nov')}',
      '${getTranslated(context, 'dec')}',
    ];

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${getTranslated(context, 'activity')}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    // fontSize: 36,
                    color: Theme.of(context).textTheme.headline5!.color),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.local_activity_outlined),
                color: Theme.of(context).disabledColor.withOpacity(0.6))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 7.0, bottom: 15.0),
                child: SizedBox(
                  height: 65.0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      // reverse: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            DateTime dateTime = DateTime.now();
                            DateFormat dateFormat = DateFormat('yyyy-MM-dd');

                            await loadKalForDate(
                                date: dateFormat.format(
                                    dateTime.subtract(Duration(days: index))));
                            await loadStepForDate(
                                date: dateFormat.format(
                                    dateTime.subtract(Duration(days: index))));
                            await loadTrainingForDate(
                                date: dateFormat.format(
                                    dateTime.subtract(Duration(days: index))));

                            setState(() {
                              selectedDatebox = index;
                            });
                            // await loadWorkouts();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: selectedDatebox == index
                                      ? Colors.blue.shade900
                                      : Theme.of(context)
                                          .disabledColor
                                          .withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    (DateTime.now().day - index).toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: selectedDatebox == index
                                            ? Colors.white
                                            : Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    months[DateTime.now().month - 1],
                                    style: TextStyle(
                                        color: selectedDatebox == index
                                            ? Colors.white
                                            : Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.6)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height - 225,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: [
                      // Steps
                      Container(
                        padding: const EdgeInsets.only(
                            left: 7.0, right: 7.0, top: 0.0, bottom: 15.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.11),

                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${getTranslated(context, 'step')}s'),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: IconButton(
                                    icon: Image.asset(
                                      'assets/images/person.jpg',
                                      width: 30,
                                      height: 30,
                                    ),
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100.0,
                                  width: 100.0,
                                  child: CircleProgressBar(
                                    value: int.parse(_steps.toString()) / 8000,
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.5),
                                    strokeWidth: 10.0,
                                    animationDuration:
                                        const Duration(seconds: 5),
                                    child: Center(
                                      child: Text('$_steps'),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 7.0, right: 7.0, top: 0.0, bottom: 15.0),
                        width: 100.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.11),

                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${getTranslated(context, 'heart_rate')}'),
                                    Text(
                                      _bpm > 30 && _bpm < 150
                                          ? _bpm.toString()
                                          : "--",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  height: 100,
                                  width: 250,
                                  // margin: EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18),
                                      ),
                                      color: Colors.black),
                                  child: Chart(_data),
                                ),
                              ),

                              Transform.scale(
                                scale: _iconScale,
                                child: InkWell(
                                  onTap: () {
                                    if (_toggled) {
                                      _untoggle();
                                    } else {
                                      _toggle();
                                    }
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 80,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: _toggled
                                            ? Text(
                                                '${getTranslated(context, 'stop')}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                '${getTranslated(context, 'start')}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                      )),
                                ),
                              )

                              // IconButton(
                              //   icon: Icon(_toggled ? Icons.favorite : Icons.favorite_border,color: Colors.pink,),
                              //   onPressed: () {
                              //     if (_toggled) {
                              //       _untoggle();
                              //     } else {
                              //       _toggle();
                              //     }
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                      // Calories
                      Container(
                        padding: const EdgeInsets.only(
                            left: 7.0, right: 7.0, top: 8.0, bottom: 15.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.11),
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${getTranslated(context, 'calories')}'),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: Image.asset(
                                      'assets/images/kal.png',
                                      width: 35,
                                      height: 35,
                                    ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100.0,
                                  width: 100.0,
                                  child: CircleProgressBar(
                                    value: kal / 999,
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.5),
                                    strokeWidth: 10.0,
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    child: Center(
                                      child: Text(kal.toString()),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //Trainings
                      Container(
                        padding: const EdgeInsets.only(
                            left: 7.0, right: 7.0, top: 8.0, bottom: 15.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.11),
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${getTranslated(context, 'training')}'),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: Image.asset(
                                      'assets/images/kal.png',
                                      width: 35,
                                      height: 35,
                                    ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(trainingTime.toString()),
                                Expanded(
                                    child: Text(
                                        ' ${getTranslated(context, 'minutes')}'))
                              ],
                            )
                          ],
                        ),
                      ),
                      /*Container(
                        padding: const EdgeInsets.only(
                            left: 7.0, right: 7.0, top: 8.0, bottom: 15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Sleep'),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Image.asset(
                                        'assets/images/bed.jpg',
                                        width: 30,
                                        height: 30,
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ActivitySleepBarChart(),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text('7.5 hours'),
                            )
                          ],
                        ),
                      ),*/
                      /*Container(
                        padding: const EdgeInsets.only(
                            left: 7.0, right: 7.0, top: 8.0, bottom: 15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Distance'),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: Image.asset(
                                      'assets/images/car.jpg',
                                      width: 30,
                                      height: 30,
                                    ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('55'),
                                Expanded(child: Text('minutes'))
                              ],
                            )
                          ],
                        ),
                      ),*/
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  Future<void> _toggle() async {
    _clearData();
    await requestMicrophonePermission().then((value) {
      if (value.isNotEmpty) {
        if (value[Permission.camera]!.isGranted &&
            value[Permission.microphone]!.isGranted) {
            _initController().then((onValue) {
              Wakelock.enable();
              _animationController?.repeat(reverse: true);
              setState(() {
                _toggled = true;
              });
              // after is toggled
              _initTimer();
              _updateBPM();
            });
          }
      }
    });
  }

  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    setState(() {
      _toggled = false;
    });
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller!.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller!.setFlashMode(FlashMode.torch);
      });
      _controller!.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image!);
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now!, 255 - _avg!));
    });
  }

  void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }

  Future<void> requestMotionPermission() async {
    final serviceStatus = await Permission.sensors.isGranted;

    bool isRequestMotionPermissionOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.sensors.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      await Permission.sensors.request();
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await _showMyPermissionDialog();
    }
  }

  Future<Map<Permission, PermissionStatus>> requestMicrophonePermission() async {
    final serviceStatus = await Permission.microphone.isGranted;

    bool isRequestMicrophonePermissionOn = serviceStatus == ServiceStatus.enabled;

    Map<Permission, PermissionStatus> status = await [
      Permission.microphone,
      Permission.camera,
      //add more permission to request here.
    ].request();

    if (status[Permission.microphone]!.isPermanentlyDenied) {
      await _showMyPermissionDialog();
    } else {
      if (status[Permission.microphone]!.isDenied) {
        _toggle();
      }
    }

    if (status[Permission.camera]!.isPermanentlyDenied) {
      await _showMyPermissionDialog();
    } else {
      if (status[Permission.camera]!.isDenied) {
        _toggle();
      }
    }

    return status;

    /*if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      await Permission.microphone.request();
      await Permission.camera.request();
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await _showMyPermissionDialog();
    }*/
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
