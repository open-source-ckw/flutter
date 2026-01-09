import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '/app/contact.dart';
import '/app/core/get_data.dart';
import '/app/layout/listing/sedule_tour.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../core/global.dart' as global;

class Enquiry extends StatefulWidget {
  dynamic listingKey;
  String? mls_no = '';

  Enquiry({Key? key, required this.listingKey, this.mls_no}) : super(key: key);

  @override
  _EnquiryState createState() => _EnquiryState();
}

enum rlesagent { yes, no }

class _EnquiryState extends State<Enquiry> {
  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  final number = '9978619900';
  late String email, _name, subject, phoneno, comments, MlsNum, codecap;
  TextEditingController userEmail = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController userSubject = TextEditingController();
  TextEditingController userPhoneNo = TextEditingController();
  TextEditingController userComments = TextEditingController();
  TextEditingController codeCaptcha = TextEditingController();
  Map<String, dynamic> agentData = {};
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  List AgentData = [];
  Map EnData = {};
  String code = '657893';

  initState() {
    super.initState();
  }

  getAgentData() async {
    Map<String, dynamic> agentData = {"ListingID_MLS": "A11152827-2"};
    Map<String, dynamic> arrPost = {'filter': jsonEncode(agentData)};
    await SearchResult().getListData(arrPost).then((ageData) {
      if (this.mounted) {
        setState(() {
          AgentData = ageData['rs'];
        });
        return ageData;
      }
    });
  }

  getInquryData() async {
    Map<String, dynamic> EnquiryData = {
      "lead_first_name": _name,
      "lead_home_phone": phoneno,
      "lead_email": email,
      "lead_comment": comments,
      "mls_num": "A11152827",
    };

    return SearchResult().getInquiryUserData('user', 'inquiry', EnquiryData);
  }

  @override
  Widget build(BuildContext context) {
    final customCacheManager = CacheManager(
        Config('customCacheKey', stalePeriod: const Duration(days: 3)));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 16, top: 20),
              child: Text(
                "MLS # A22503457",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                )),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 32.0),
                          margin: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                              /*border: Border.all(width: 2,color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(0),*/
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 5,
                                )
                              ]),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  '\$\ ${'74,800,000'}',
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'The Ved and Dev Group At CRR & Dream Home  \n Dream Home Level Agent',
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 16)),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await FlutterPhoneDirectCaller.callNumber(
                                        number);
                                  },
                                  child: Container(
                                    //padding: EdgeInsets.symmetric(horizontal: 40.0,),
                                    //margin:EdgeInsets.only(left: 170),
                                    child: Row(
                                      children: [
                                        Icon(Icons.call),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(number,
                                            style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 40.0,),
                                  //margin:EdgeInsets.only(left: 170),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Dreamhomes@icloud.com',
                                          style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, spreadRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(90.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  width: 70,
                                  height: 70,
                                  imageUrl:
                                      global.mapConfige['img_splash_screen_1'],
                                  key: UniqueKey(),
                                  cacheManager: customCacheManager,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
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
                                'Email*',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                focusNode: _focusNodes[0],
                                decoration: InputDecoration(
                                    hintText: 'Enter your Email*',
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.red),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF3ee7b7),
                                          width: 3.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: _focusNodes[0].hasFocus
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.grey,
                                    ),
                                    errorStyle: TextStyle(fontSize: 14)),
                                controller: userEmail,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
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
                                'Name*',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                focusNode: _focusNodes[1],
                                decoration: InputDecoration(
                                    hintText: ' Enter Your Name*',
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.red),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF3ee7b7),
                                          width: 3.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                      color: _focusNodes[1].hasFocus
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.grey,
                                    ),
                                    errorStyle: TextStyle(fontSize: 14)),
                                controller: userName,
                                keyboardType: TextInputType.text,
                                onSaved: (String? val) {
                                  _name = val!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Subject*',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                focusNode: _focusNodes[2],
                                decoration: InputDecoration(
                                    hintText: 'Enter Your Subject*',
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.red),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF3ee7b7),
                                          width: 3.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                      color: _focusNodes[2].hasFocus
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.grey,
                                    ),
                                    errorStyle: TextStyle(fontSize: 14)),
                                controller: userSubject,
                                keyboardType: TextInputType.text,
                                onSaved: (String? val) {
                                  subject = val!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter subject';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Phone no',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                focusNode: _focusNodes[3],
                                decoration: InputDecoration(
                                    hintText: 'Enter Your Phone NO',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF3ee7b7),
                                          width: 3.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                      color: _focusNodes[3].hasFocus
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.grey,
                                    ),
                                    errorStyle: TextStyle(fontSize: 11)),
                                controller: userPhoneNo,
                                keyboardType: TextInputType.text,
                                onSaved: (String? val) {
                                  phoneno = val!;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Comments',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                focusNode: _focusNodes[4],
                                decoration: InputDecoration(
                                    hintText: 'Enter Comments',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF3ee7b7),
                                          width: 3.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.comment,
                                      color: _focusNodes[4].hasFocus
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.grey,
                                    ),
                                    errorStyle: TextStyle(fontSize: 11)),
                                controller: userComments,
                                keyboardType: TextInputType.text,
                                onSaved: (String? val) {
                                  comments = val!;
                                },
                              ),
                            ])),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        if (code == codeCaptcha) {
                          if (_formKey.currentState!.validate()) {
                            if (this.mounted) {
                              setState(() {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState?.save();
                                  getInquryData();
                                  sucessData();
                                  new Future.delayed(
                                    new Duration(seconds: 1),
                                  );
                                } else {
                                  //_loading = false;
                                  errorData();
                                }
                              });
                            }
                          }
                        } else {
                          print('code does not match');
                        }
                      },
                      child: Text(
                        'CHECK AVAILABITY',
                        style: TextStyle(
                            color: Color(0xFF2a5537),
                            backgroundColor: Color(0xFF3ee7b7),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF3ee7b7)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 25)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            withNavBar: false, screen: Seduletour());
                        if (_formKey.currentState!.validate()) {
                          if (this.mounted) {
                            setState(() {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                sucessData();
                                new Future.delayed(
                                  new Duration(seconds: 1),
                                );
                              } else {
                                _loading = false;
                                errorData();
                              }
                            });
                          }
                        }
                      },
                      child: Text(
                        'SCHEDULE TOUR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[700]),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 25)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            withNavBar: false,
                            screen: Contact(
                              onPage: 'Enquiry',
                            ));
                        if (_formKey.currentState!.validate()) {
                          if (this.mounted) {
                            setState(() {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                sucessData();
                                new Future.delayed(
                                  new Duration(seconds: 1),
                                );
                              } else {
                                _loading = false;
                                errorData();
                              }
                            });
                          }
                        }
                      },
                      child: const Text(
                        'CONTACT US',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlue[900]),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 25)),
                      ),
                    ),
                  ],
                ),),),);
  }

  sucessData() {
    TextButton(
      onPressed: () {
        final text = 'data upload sucessful';
        final snackBar = SnackBar(content: Text(text));
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackBar);
      },
      style: TextButton.styleFrom(backgroundColor: Colors.green),
      child: Text('submit'),
    );
  }

  errorData() {
    TextButton(
      onPressed: () {
        final text = 'data not uploaded';
        final snackBar = SnackBar(content: Text(text));
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackBar);
      },
      style: TextButton.styleFrom(backgroundColor: Colors.red),
      child: Text('Error'),
    );
  }

  String validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.length == 0) {
      return "Please enter email address";
    } else if (!regex.hasMatch(value))
      return 'Please enter valid email address';
    else
      return '';
  }

  String validateComments(String value) {
    if (value.length < 3)
      return 'Comment need to be at least 10 characters long';
    else
      return '';
  }

  String validatePhone(String value) {
    if (value.length < 3 && value.length > 10)
      return 'Comment need to be at least 10 characters long';
    else
      return '';
  }

  showError(msg) {
    if (this.mounted) {
      this.setState(() {
        _loading = false;
      });
    }
  }
}
