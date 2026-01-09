import '../local/localization/language_constants.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';

class CreateTrainingPlan extends StatelessWidget {
  final dynamic goToNextPage;

  const CreateTrainingPlan({required this.goToNextPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, bottom: 75.0, left: 25.0, right: 25.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              '${getTranslated(context, 'create_training_plan')}',
                              style: TextStyle(
                                  fontSize: 32.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 55.0, bottom: 25.0),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: CircleProgressBar(
                          value: 0.75,
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.grey.shade100,
                          strokeWidth: 20.0,
                          animationDuration: Duration(seconds: 5),
                          child: Center(
                            child: Text(
                              '75%',
                              style: TextStyle(
                                  fontSize: 40.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              '${getTranslated(context, 'create_workout_according_demographic')},',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: InkWell(
                    onTap: () {
                      goToNextPage();
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
                        '${getTranslated(context, 'start_training')}',
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
      ),
    );
  }
}
