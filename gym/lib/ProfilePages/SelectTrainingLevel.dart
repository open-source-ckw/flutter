import 'package:flutter/material.dart';

import '../local/localization/language_constants.dart';

class SelectTrainingLevel extends StatefulWidget {
  final dynamic goToNextPage;
  final dynamic setTrainingLevel;

  const SelectTrainingLevel(
      {required this.goToNextPage, Key? key, required this.setTrainingLevel})
      : super(key: key);

  @override
  State<SelectTrainingLevel> createState() => _SelectTrainingLevelState();
}

class _SelectTrainingLevelState extends State<SelectTrainingLevel> {
  int currentActiveContainer = 1;

  @override
  Widget build(BuildContext context) {
    List<String> trainingLevelOptions = [
      '${getTranslated(context, 'beginner_start_straining')}',
      '${getTranslated(context, 'irregular_week')}',
      '${getTranslated(context, 'medium_week')}',
      '${getTranslated(context, 'advanced_week')}',
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
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            '${getTranslated(context, 'choose_training_level')}',
                            style: TextStyle(
                                fontSize: 32.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                      child: Column(
                        children: [
                          getTrainingContainer(context,
                              heading: '${getTranslated(context, 'beginner')}',
                              subText:
                                  '${getTranslated(context, 'beginner_start_straining')}',
                              isActive: currentActiveContainer == 1,
                              containerIndex: 1),
                          getTrainingContainer(context,
                              heading:
                                  '${getTranslated(context, 'irregular_training')}',
                              subText:
                                  '${getTranslated(context, 'irregular_week')}',
                              isActive: currentActiveContainer == 2,
                              containerIndex: 2),
                          getTrainingContainer(context,
                              heading: '${getTranslated(context, 'medium')}',
                              subText:
                                  '${getTranslated(context, 'medium_week')}',
                              isActive: currentActiveContainer == 3,
                              containerIndex: 3),
                          getTrainingContainer(context,
                              heading: '${getTranslated(context, 'advance')}',
                              subText:
                                  '${getTranslated(context, 'advanced_week')}',
                              isActive: currentActiveContainer == 4,
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
                    widget.setTrainingLevel(
                        trainingLevel: trainingLevelOptions
                            .elementAt(currentActiveContainer - 1));
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
                    child: Text(
                      "${getTranslated(context, 'continue')}",
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

  Widget getTrainingContainer(
    BuildContext context, {
    required bool isActive,
    required int containerIndex,
    required String heading,
    required String subText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentActiveContainer = containerIndex;
          });
        },
        child: Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isActive ? Colors.blue : Colors.grey.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(5.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  children: [
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        subText,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
