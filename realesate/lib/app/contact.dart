import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'contect_map.dart';
import 'core/constant.dart';
import 'frist_contect.dart';
import 'second_contect.dart';
import 'third_contect.dart';
import 'core/get_data.dart';
import 'loader.dart';

class Contact extends StatefulWidget {
  String? onPage;

  Contact({Key? key, this.onPage}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Contact> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController massage = TextEditingController();
  TextEditingController comments = TextEditingController();

  bool _isLoading = false;
  final _Formkey = GlobalKey<FormState>();
  Map<String, dynamic> mapData = {};
  LatLng? marker_position;
  Map<String, Marker> _markers = {};
  var firstname, lastname, email_l, phoneno, massage_g, comment;

  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  initState() {
    super.initState();
  }

  postReq() async {
    Map<String, dynamic> EnquiryData = {
      "lead_first_name": fName,
      "lead_home_phone": phoneno,
      "lead_email": email,
      "lead_comment": comments,
    };
    return SearchResult().getInquiryUserData('user', 'contact', EnquiryData);
  }

  /* getData() async {
    await SearchResult().getDelScreen().then((l_data) {
      if (mounted) {
        setState(() {
          mapData = l_data;
          var lat = 22.567445456241597;
          var lng = 72.95282624366938;
          if (marker_position == null && lat != null && lng != null) {
            marker_position = LatLng(lat, lng);

          }
        });
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    //addMarker(22.567445456241597, 72.95282624366938);
    // TODO: implement build
    /* if (mapData.length == 0) getData();
    Size size = MediaQuery
        .of(context)
        .size;*/

    return widget.onPage == 'Enquiry'
        ? Scaffold(
            backgroundColor: Colors.white70,
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: contact(),
          )
        : Scaffold(
            body: contact(),
          );
  }

  contact() {
    return CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate(
        [
          Container(
              padding: EdgeInsets.only(top: 50, left: 16.0, right: 16.0),
              child: Column(children: [
                OneContect(),
                SizedBox(
                  height: 15,
                ),
                ContactMap(mapData, _markers),
                SizedBox(
                  height: 15,
                ),
                Secondcontect(),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _Formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First Name*',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: _focusNodes[1],
                          decoration: InputDecoration(
                              hintText: ' Enter Your First Name*',
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orangeAccent,
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
                                color: _focusNodes[1].hasFocus
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              errorStyle: TextStyle(fontSize: 14)),
                          controller: fName,
                          keyboardType: TextInputType.text,
                          onSaved: (String? val) {
                            firstname = val!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Last Name*',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: _focusNodes[2],
                          decoration: InputDecoration(
                              hintText: ' Enter Your Last Name*',
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orangeAccent,
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
                                color: _focusNodes[2].hasFocus
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              errorStyle: TextStyle(fontSize: 14)),
                          controller: lName,
                          keyboardType: TextInputType.text,
                          onSaved: (String? val) {
                            lastname = val!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
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
                          focusNode: _focusNodes[3],
                          decoration: InputDecoration(
                              hintText: 'Enter Your Phone NO',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orangeAccent,
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
                                color: _focusNodes[3].hasFocus
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              errorStyle: TextStyle(fontSize: 11)),
                          controller: phone,
                          keyboardType: TextInputType.text,
                          onSaved: (String? val) {
                            phoneno = val!;
                          },
                        ),
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
                          focusNode: _focusNodes[0],
                          decoration: InputDecoration(
                              hintText: 'Enter your Email*',
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orangeAccent,
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
                                Icons.email,
                                color: _focusNodes[0].hasFocus
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              errorStyle: TextStyle(fontSize: 14)),
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          onSaved: (String? val) {
                            email_l = val!;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Massage*',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: _focusNodes[5],
                          decoration: InputDecoration(
                              hintText: 'Enter your Massage',
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orangeAccent,
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
                                Icons.email,
                                color: _focusNodes[5].hasFocus
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              errorStyle: TextStyle(fontSize: 14)),
                          controller: massage,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your massage';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          onSaved: (String? val) {
                            massage_g = val!;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Comments',
                          style: TextStyle(color: Colors.black, fontSize: 18),
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
                                    color: Colors.orangeAccent,
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
                                Icons.comment,
                                color: _focusNodes[4].hasFocus
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                              ),
                              errorStyle: TextStyle(fontSize: 11)),
                          controller: comments,
                          keyboardType: TextInputType.text,
                          onSaved: (String? val) {
                            comment = val!;
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Center(
                            child: Container(
                          child: TextButton(
                            child: Text(
                              'SEND MESSAGE',
                              style: TextStyle(
                                  color: Color(0xFF2a5537),
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              (_isLoading == true) ? loader() : SizedBox();
                              if (_Formkey.currentState!.validate()) {
                                _isLoading = true;
                                if (this.mounted) {
                                  setState(() {
                                    if (_Formkey.currentState!.validate()) {
                                      _Formkey.currentState?.save();
                                      postReq();
                                      successData();
                                      new Future.delayed(
                                        new Duration(seconds: 1),
                                      );
                                    } else {
                                      errorData();
                                    }
                                  });
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              minimumSize:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Size(150, 25);
                                }
                                return Size(150, 25);
                              }),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                ThirdContent(),
                SizedBox(
                  height: 19,
                ),
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Center(
                      child: Text(
                        copyRight,
                    style: TextStyle(
                      color: Colors.grey[700],
                      //backgroundColor: Colors.grey[300]
                    ),
                  )),
                ),
              ]))
        ],
      ))
    ]);
  }

  successData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('message send successfully'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                fName.clear();
                lName.clear();
                phone.clear();
                massage.clear();
                comments.clear();
                email.clear();
              },
              child: Text('Go Back'))
        ],
      ),
    );
  }

  errorData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('message not send'),
        //content: Text('Result is $_result'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                fName.clear();
                lName.clear();
                phone.clear();
                massage.clear();
                comments.clear();
                email.clear();
              },
              child: Text('Go Back'))
        ],
      ),
    );
  }

  Widget loader() {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        color: Colors.white60,
      ),
      alignment: AlignmentDirectional.center,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Loader(),
          Text(
            "Loading...",
          ),
        ],
      ),
    );
  }

  addMarker(latitude, longitude) async {
    print('---');
    print(mapData['MLS_NUM']);
    final marker = Marker(
      markerId: MarkerId(mapData['MLS_NUM']),
      position: marker_position ?? LatLng(latitude, longitude),
      //consumeTapEvents: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
      //myIcon,

      infoWindow: InfoWindow(
        title: mapData['MLS_NUM'],
        snippet: mapData['Address'],
      ),
    );
    _markers[mapData['MLS_NUM']] = marker;
  }
}
