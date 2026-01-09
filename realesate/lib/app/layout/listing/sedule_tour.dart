import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '/app/core/get_data.dart';

class Seduletour extends StatefulWidget {
  const Seduletour({Key? key}) : super(key: key);

  @override
  _SeduletourState createState() => _SeduletourState();
}

enum realagent { yes, no }

class _SeduletourState extends State<Seduletour> {
  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  late String email,
      name,
      subject,
      phoneno,
      comments,
      MlsNum,
      datetime,
      message,
      codecap;
  TextEditingController userEmail = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController userSubject = TextEditingController();
  TextEditingController userPhoneno = TextEditingController();
  TextEditingController userComments = TextEditingController();
  TextEditingController userDatetime = TextEditingController();
  TextEditingController codecapcha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  realagent? _select = realagent.yes;
  List<DateTime> _dates = [];
  DateTime dateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showDateTime = false;
  bool showTime = false;

  getInquiryData() async {
    return SearchResult().getSeduleUserData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    String code = "567843";
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Schedule a Tour',
                    style: TextStyle(
                        color: Color(0xFF3ee7b7),
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            color: Color(0xFF3ee7b7),
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name*',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _focusNodes[0],
                      decoration: InputDecoration(
                          hintText: ' Enter Your Full Name*',
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(width: 3, color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3ee7b7),
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.account_box_rounded,
                            color: _focusNodes[0].hasFocus
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                          ),
                          errorStyle: TextStyle(fontSize: 11)),
                      controller: userName,
                      keyboardType: TextInputType.text,
                      onSaved: (String? val) {
                        name = val!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    /*  ),*/
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Email*',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _focusNodes[1],
                      decoration: InputDecoration(
                          hintText: 'Enter Your Email*',
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(width: 3, color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3ee7b7),
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: _focusNodes[1].hasFocus
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                          ),
                          errorStyle: TextStyle(fontSize: 11)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      controller: userEmail,
                      keyboardType: TextInputType.text,
                      onSaved: (String? val) {
                        email = val!;
                      },
                    ),
                    /*),*/
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Phone no',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _focusNodes[2],
                      decoration: InputDecoration(
                          hintText: 'Enter Your Phone no',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3ee7b7),
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: _focusNodes[2].hasFocus
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                          ),
                          errorStyle: TextStyle(fontSize: 11)),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: userPhoneno,
                      onSaved: (String? val) {
                        phoneno = val!;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Subject*',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _focusNodes[3],
                      decoration: InputDecoration(
                          hintText: ' Enter Your Subject*',
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(width: 3, color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3ee7b7),
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.book_rounded,
                            color: _focusNodes[3].hasFocus
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                          ),
                          errorStyle: TextStyle(fontSize: 11)),
                      controller: userSubject,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter subject';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      onSaved: (String? val) {
                        subject = val!;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Select Date And Time*',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      //padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey.shade500, backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.grey.shade400),
                            )),
                        onPressed: () {
                          _selectDateTime(context);
                          showDateTime = true;
                        },
                        child: const Text(
                          'Select Date and Time',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    showDateTime
                        ? Center(
                            child: Text(
                            getDateTime(),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ))
                        : const SizedBox(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Are you currently working with a real estate agent ?',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Yes',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            leading: Radio<realagent>(
                              value: realagent.yes,
                              groupValue: _select,
                              onChanged: (realagent? value) {
                                setState(() {
                                  _select = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text(
                              'No',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            leading: Radio<realagent>(
                              value: realagent.no,
                              groupValue: _select,
                              onChanged: (realagent? value) {
                                setState(() {
                                  _select = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Massage',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: ' Enter Your Massage',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3ee7b7),
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 11)),
                      controller: userComments,
                      keyboardType: TextInputType.text,
                      onSaved: (String? val) {
                        message = val!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (this.mounted) {
                            setState(() {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                getInquiryData();
                                final text = 'Message send successfully';
                                userSubject.clear();
                                userPhoneno.clear();
                                userComments.clear();
                                userName.clear();
                                userDatetime.clear();
                                userEmail.clear();
                                _dates.clear();
                                final snackBar = SnackBar(content: Text(text));
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                                new Future.delayed(
                                  new Duration(seconds: 1),
                                );
                              } else {
                                //_loading = false;
                                final text =
                                    'Message does not send sucessfully';
                                final snackBar = SnackBar(content: Text(text));
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            });
                          }
                        }
                      },
                      child: Text(
                        'CONFIRM TOUR',
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Color(0xFF3ee7b7),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF3ee7b7)),
                        minimumSize:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Size(180, 25);
                          }
                          return Size(180, 25);
                        }),
                      ),
                    )),
                  ]),
            ),
          ]),
    ))));
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDateTime() {
    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd HH: ss a').format(dateTime);
    }
  }
}
