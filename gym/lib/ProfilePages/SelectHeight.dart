import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../local/localization/language_constants.dart';

class SelectHeight extends StatefulWidget {
  final dynamic goToNextPage;
  final dynamic setHeight;

  const SelectHeight(
      {required this.goToNextPage, Key? key, required this.setHeight})
      : super(key: key);

  @override
  State<SelectHeight> createState() => _SelectHeightState();
}

class _SelectHeightState extends State<SelectHeight> {
  TextEditingController heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String currentMeasure = 'Feet';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: _formKey,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          '${getTranslated(context, 'select_height')}',
                          style: TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 55.0, bottom: 25.0),
                    child: AnimatedToggleSwitch.size(
                      current: currentMeasure,
                      values: <String>['Feet', 'Centimeter'],
                      fittingMode: FittingMode.preventHorizontalOverlapping,
                      onChanged: (String value) {
                        setState(() {
                          currentMeasure = value;
                        });
                      },
                      borderColor: Colors.blue.shade900,
                      indicatorColor: Colors.blue.shade900,
                      indicatorSize: const Size(175, 50),
                      iconBuilder: (value, size) {
                        return Center(
                            child: Text(
                          '$value',
                          style: TextStyle(
                              color: currentMeasure == value
                                  ? Colors.white
                                  : Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 75,
                          width: 100,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${getTranslated(context, 'enter_some_text')}';
                              }
                              return null;
                            },
                            controller: heightController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                                hintText: '0',
                                // fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            currentMeasure == 'Feet' ? 'ft' : 'cm',
                            style: const TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            widget.setHeight(
                                height: double.parse(
                                    heightController.text.toString()),
                                heightIn:
                                    currentMeasure == 'Feet' ? 'ft' : 'cm');
                            widget.goToNextPage();
                          }
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
                            '${getTranslated(context, 'continue')}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ))
                ],
              ),
            )
            /*Stack(
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
                                  '${getTranslated(context, 'select_height')}',
                                  style: TextStyle(
                                      fontSize: 32.0, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 55.0, bottom: 25.0),
                        child: AnimatedToggleSwitch.size(
                          current: currentMeasure,
                          values: <String>['Feet', 'Centimeter'],
                          fittingMode: FittingMode.preventHorizontalOverlapping,
                          onChanged: (String value) {
                            setState(() {
                              currentMeasure = value;
                            });
                          },
                          borderColor: Colors.blue.shade900,
                          indicatorColor: Colors.blue.shade900,
                          indicatorSize: const Size(175, 50),
                          iconBuilder: (value, size) {
                            return Center(
                                child: Text(
                                  '$value',
                                  style: TextStyle(
                                      color: currentMeasure == value
                                          ? Colors.white
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75,
                              width: 100,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '${getTranslated(context, 'enter_some_text')}';
                                  }
                                  return null;
                                },
                                controller: heightController,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                    hintText: '0',
                                    // fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0))),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                currentMeasure == 'Feet' ? 'ft' : 'cm',
                                style: const TextStyle(
                                    fontSize: 30.0, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
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
                        if (_formKey.currentState!.validate()) {
                          widget.setHeight(
                              height:
                              double.parse(heightController.text.toString()),
                              heightIn: currentMeasure == 'Feet' ? 'ft' : 'cm');
                          widget.goToNextPage();
                        }
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
          ),*/
            ),
      ),
    );
  }

  Widget getIconContainer(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Container(
        height: 75.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
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
    );
  }
}
