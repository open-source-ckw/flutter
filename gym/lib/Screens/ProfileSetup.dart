import 'package:flutter/material.dart';
import '../ProfilePages/SelectName.dart';
import '../Screens/SignInScreen.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ProfilePages/CreateTrainingPlan.dart';
import '../ProfilePages/SelectActivitiesInterest.dart';
import '../ProfilePages/SelectDob.dart';
import '../ProfilePages/SelectGender.dart';
import '../ProfilePages/SelectGoalWeight.dart';
import '../ProfilePages/SelectHeight.dart';
import '../ProfilePages/SelectMainGoal.dart';
import '../ProfilePages/SelectTrainingLevel.dart';
import '../ProfilePages/SelectWeight.dart';
import '../local/localization/language_constants.dart';
import 'HomeScreen.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  // static const route = '/';
  static const route = 'profileSetup';

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  int pageIndex = 0;

  UserMaster? user;

  UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null && user!.um_name != false) {
        context.loaderOverlay.show();
      }
    });
  }

  Future<void> loadUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print(sharedPreferences);
    // print(Constants.faUUID);
    String? uuid = sharedPreferences.getString(Constants.faUUID);
    print(uuid);
    if (uuid != null) {
      UserMaster tempUser = await userRepository.getUserFromId(uid: uuid);
      // print(tempUser);
      if (tempUser != false && tempUser!.um_name != false) {
        setState(() {
          user = tempUser;
          if (mounted && context.loaderOverlay.visible) {
            context.loaderOverlay.hide();
          }
        });
      }
    }
    return;
  }

  PageController controller = PageController();

  void goToNextPage() {
    setState(() {
      // user!.um_name == false ?
      pageIndex = (pageIndex + 1) % 10;
    });
    controller.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 100),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  Future<void> setCompletion() async {
    if (user != null) {
      await userRepository.update(user: user!).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green.shade500,
            content: Text('${getTranslated(context, 'profile_update')}')));
      });
    }
  }

  void setGender({required String gender}) {
    // loadUser();
    user!.um_gender = gender;
  }

  void setDob({required String date}) {
    // loadUser();
    user!.um_dob = date;
  }

  void setName({required String name}) {
    // loadUser();
    user!.um_name = name;
  }

  void setMainGoal({required String goal}) {
    // loadUser();
    user!.um_maingoal = goal;
  }

  void setTrainingLevel({required String trainingLevel}) {
    // loadUser();
    user!.um_traininglevel = trainingLevel;
  }

  void setWeight({required double weight, required String weightIn}) {
    // loadUser();
    user!.um_weight = weight;
    setWeightIn(weightIn: weightIn);
  }

  void setWeightIn({required String weightIn}) {
    // loadUser();
    user!.um_weightin = weightIn;
  }

  void setGoalWeight(
      {required double goalWeight, required String goalWeightIn}) {
    // loadUser();
    user!.um_goalweight = goalWeight;
    setGoalWeightIn(goalWeightIn: goalWeightIn);
  }

  void setGoalWeightIn({required String goalWeightIn}) {
    // loadUser();;
    user!.um_goalweightin = goalWeightIn;
  }

  void setHeight({required double height, required String heightIn}) {
    // loadUser();
    user!.um_height = height;
    setHeightIn(heightIn: heightIn);
  }

  void setHeightIn({required String heightIn}) {
    // loadUser();
    user!.um_heightin = heightIn;
  }

  void setTrainingGoal({required String trainingGoal}) {
    // loadUser();
    user!.um_traininglevel = trainingGoal;
    setCompletion();
  }

  void goToHomeScreen() {
    // FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pushReplacementNamed(context, HomeScreen.route);
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            toolbarHeight: 100.0,
            // backgroundColor: Colors.white,
            iconTheme: const IconThemeData(size: 35.0),
            // foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              '${getTranslated(context, 'step')} ${pageIndex + 1} ${getTranslated(context, 'of_9')}',
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).textTheme.headline5!.color),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.route, (route) => false);
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                        fontSize: 18.0, color: Colors.black.withOpacity(0.4)),
                  ),
              )
            ],
          ),
          body: PageView(
            controller: controller,
            // physics: NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                pageIndex = page;
              });
            },
            children: [
              if (user != null && user!.um_name == false)
                SelectName(goToNextPage: goToNextPage, setName: setName),
              SelectDob(goToNextPage: goToNextPage, setDob: setDob),
              SelectGender(goToNextPage: goToNextPage, setGender: setGender),
              SelectMainGoal(
                  goToNextPage: goToNextPage, setMainGoal: setMainGoal),
              SelectHeight(goToNextPage: goToNextPage, setHeight: setHeight),
              SelectWeight(goToNextPage: goToNextPage, setWeight: setWeight),
              SelectGoalWeight(
                  goToNextPage: goToNextPage, setGoalWeight: setGoalWeight),
              SelectTrainingLevel(
                  goToNextPage: goToNextPage,
                  setTrainingLevel: setTrainingLevel),
              SelectActivitiesInterest(
                  goToNextPage: goToNextPage, setTrainingGoal: setTrainingGoal),
              CreateTrainingPlan(goToNextPage: goToHomeScreen)
            ],
          )),
    );
  }
}
