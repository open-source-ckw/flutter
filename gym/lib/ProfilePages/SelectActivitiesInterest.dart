import 'package:flutter/material.dart';

import '../local/localization/language_constants.dart';

class SelectActivitiesInterest extends StatefulWidget {
  final dynamic goToNextPage;
  final dynamic setTrainingGoal;

  const SelectActivitiesInterest(
      {required this.goToNextPage, Key? key, this.setTrainingGoal})
      : super(key: key);

  @override
  State<SelectActivitiesInterest> createState() =>
      _SelectActivitiesInterestState();
}

class _SelectActivitiesInterestState extends State<SelectActivitiesInterest> {
  List<int> selectedInterests = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> trainingGoalOptions = [
      "${getTranslated(context, 'cardio')}",
      "${getTranslated(context, 'power_training')}",
      "${getTranslated(context, 'stretch')}",
      "${getTranslated(context, 'dancing')}",
      "${getTranslated(context, 'yoga')}",
    ];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 75.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "${getTranslated(context, 'choose_training_goal')}",
                            style: TextStyle(
                                fontSize: 32.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 25.0),
                      child: Column(
                        children: [
                          getActivitiesInterest(
                              context,
                              heading: "${getTranslated(context, 'cardio')}",
                              'I want to start training',
                              isActive: selectedInterests.contains(0),
                              containerIndex: 0),
                          getActivitiesInterest(
                              context,
                              heading:
                                  '${getTranslated(context, 'power_training')},',
                              'I train 1-2 times a week',
                              isActive: selectedInterests.contains(1),
                              containerIndex: 1),
                          getActivitiesInterest(
                              context,
                              heading: '${getTranslated(context, 'stretch')},',
                              'I train 3-5 times a week',
                              isActive: selectedInterests.contains(2),
                              containerIndex: 2),
                          getActivitiesInterest(
                              context,
                              heading: '${getTranslated(context, 'dancing')},',
                              'I train more than 5 times a week',
                              isActive: selectedInterests.contains(3),
                              containerIndex: 3),
                          getActivitiesInterest(
                              context,
                              heading: '${getTranslated(context, 'yoga')},',
                              'I train more than 5 times a week',
                              isActive: selectedInterests.contains(4),
                              containerIndex: 4)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: InkWell(
                  onTap: () {
                    String selectedTrainings = "";

                    for (var element in selectedInterests) {
                      if (selectedTrainings.trim() == "") {
                        selectedTrainings = trainingGoalOptions[element];
                      } else {
                        selectedTrainings =
                            '$selectedTrainings|${trainingGoalOptions[element]}';
                      }
                    }

                    widget.setTrainingGoal(trainingGoal: selectedTrainings);
                    widget.goToNextPage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 50.00,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[900],
                        // border: Border.all(),
                        borderRadius: BorderRadius.circular(40.0)),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getActivitiesInterest(
    BuildContext context,
    String subText, {
    required bool isActive,
    required int containerIndex,
    required String heading,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selectedInterests.contains(containerIndex)) {
              selectedInterests.remove(containerIndex);
            } else {
              selectedInterests.add(containerIndex);
            }
          });
        },
        child: Container(
          height: 75.0,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: isActive
                      ? Colors.blue.shade400
                      : Colors.grey.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 15.0),
                child: const ImageIcon(
                  AssetImage(
                      'assets/images/active-woman-being-full-energy-jumps-high-air-wears-sportsclothes-prepares-sport-competitions.png'),
                  size: 40.0,
                ),
              ),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              isActive
                  ? Container(
                      padding: const EdgeInsets.all(0.5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isActive
                                ? Colors.blue.shade400
                                : Colors.grey.withOpacity(0.4)),
                        shape: BoxShape.circle,
                        color: Colors.blue.shade400,
                      ),
                      child: isActive
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : Container(),
                    )
                  : Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue.shade900)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
