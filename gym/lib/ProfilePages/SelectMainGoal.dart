import 'package:flutter/material.dart';

import '../local/localization/language_constants.dart';

class SelectMainGoal extends StatefulWidget {
  final dynamic goToNextPage;
  final dynamic setMainGoal;

  const SelectMainGoal(
      {required this.goToNextPage, Key? key, required this.setMainGoal})
      : super(key: key);

  @override
  State<SelectMainGoal> createState() => _SelectMainGoalState();
}

class _SelectMainGoalState extends State<SelectMainGoal> {
  int currentActiveContainer = 1;

  @override
  Widget build(BuildContext context) {
    List<String> mainGoalOptions = [
      '${getTranslated(context, 'lose_weight')}',
      '${getTranslated(context, 'keep_fit')}',
      '${getTranslated(context, 'get_stronger')}',
      '${getTranslated(context, 'get_mus_mas')}'
    ];

    return Container(
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          '${getTranslated(context, 'main_goal')}',
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
                        getIconContainer(context, Icons.monitor_weight,
                            '${getTranslated(context, 'lose_weight')}',
                            isActive: currentActiveContainer == 1,
                            containerIndex: 1),
                        getIconContainer(context, Icons.energy_savings_leaf,
                            '${getTranslated(context, 'keep_fit')}',
                            isActive: currentActiveContainer == 2,
                            containerIndex: 2),
                        getIconContainer(context, Icons.sports_handball,
                            '${getTranslated(context, 'get_stronger')}',
                            isActive: currentActiveContainer == 3,
                            containerIndex: 3),
                        getIconContainer(context, Icons.sports_gymnastics,
                            '${getTranslated(context, 'get_mus_mas')}',
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
                    widget.setMainGoal(
                        goal: mainGoalOptions
                            .elementAt(currentActiveContainer - 1));
                    widget.goToNextPage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 50.00,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[900],
                        // boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(1,1),spreadRadius: 2.0,blurRadius: 2.0)],
                        borderRadius: BorderRadius.circular(40.0)),
                    child: Text(
                      '${getTranslated(context, 'continue')}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget getIconContainer(BuildContext context, IconData icon, String text,
      {required bool isActive, required int containerIndex}) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentActiveContainer = containerIndex;
          });
        },
        child: Container(
          height: 75.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isActive ? Colors.blue : Colors.grey.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
