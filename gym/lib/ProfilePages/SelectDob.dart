import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../local/localization/language_constants.dart';

class SelectDob extends StatefulWidget {
  final dynamic goToNextPage;
  final dynamic setDob;

  const SelectDob({required this.goToNextPage, Key? key, required this.setDob})
      : super(key: key);

  @override
  State<SelectDob> createState() => _SelectDobState();
}

class _SelectDobState extends State<SelectDob> {
  // int currentActiveContainer = 0;

  DateTime dateTime = DateTime.now();

  TextEditingController selectDate = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
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
                        '${getTranslated(context, 'choose_DOB')}',
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ))
                    ],
                  ),
                ),

                // SizedBox(height: 15,),

                Container(
                  margin: const EdgeInsets.only(top: 55.0, bottom: 20.0),
                  height: 75.0,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    border: Border.all(color: Colors.blue.shade900, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Theme(
                    data: ThemeData(
                        inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10))),
                    child: DateTimePicker(
                      controller: selectDate,
                      dateMask: 'd MMM, yyyy',
                      dateHintText: '${getTranslated(context, 'select_DOB')}',
                      initialValue: null,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                      dateLabelText: '${getTranslated(context, 'dob')}',
                      style: const TextStyle(fontSize: 22, color: Colors.blue),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blue.shade900,
                          size: 40,
                        ),
                      ),
                      onChanged: (val) => print(val),
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          widget.setDob(
                              date: selectDate.text.trim().toString());
                          widget.goToNextPage();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 50.00,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            border: Border.all(color: Colors.blue.shade50),
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
    );
  }

  Widget getIconContainer(BuildContext context, IconData icon, String text,
      {required bool isActive, required int containerIndex}) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            // showDob();
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
