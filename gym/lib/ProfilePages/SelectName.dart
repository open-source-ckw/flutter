import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../local/localization/language_constants.dart';

class SelectName extends StatefulWidget {
  final dynamic goToNextPage;
  final dynamic setName;

  const SelectName(
      {required this.goToNextPage, Key? key, required this.setName})
      : super(key: key);

  @override
  State<SelectName> createState() => _SelectNameState();
}

class _SelectNameState extends State<SelectName> {
  // String currentMeasure = 'Kilogram';
  TextEditingController name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          '${getTranslated(context, 'enter_fullName')}',
                          style: TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))
                      ],
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
                          width: 160,
                          child: TextFormField(
                            // keyboardAppearance: Brightness.values,
                            controller: name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${getTranslated(context, 'enter_fullName')}';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                            decoration: InputDecoration(
                                hintText: 'Enter Name',
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
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            widget.setName(name: name.text.trim());

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
                ],
              ),
            )),
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
