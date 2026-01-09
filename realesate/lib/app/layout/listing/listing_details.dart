import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '/app/layout/listing/prop_des.dart';
import '/app/layout/listing/prop_feach.dart';
import '/app/layout/listing/send_request.dart';
import 'package:share_plus/share_plus.dart';
import 'Enquiry.dart';
import '../../core/get_data.dart';
import 'sedule_tour.dart';
import 'package:intl/intl.dart' as intl;
import '../../core/global.dart' as global;
import '../../core/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'similarhomes.dart';
import 'SimilarSoldHimes.dart';
import 'prop_info.dart';
import 'disclaimer.dart';

class DetailScreen extends StatefulWidget {
  dynamic listingKey;

  DetailScreen({Key? key, required this.listingKey}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

enum menuValues { share, getpre_approved, enquiry }

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic> mapData = {};
  LatLng? marker_position;
  Map<String, Marker> _markers = {};
  List<dynamic> listSimilarProperty = [];
  List<dynamic> listSoldProperty = [];
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  Map<String, dynamic>? get filter => null;

  bool get refresh => false;
  String? loan_balance, loan_principal, downPaymentAmount, sldPrice;
  String? _monthly_payment;
  int downPaymentPercent = 20;
  double downPayment = 0.0;
  int loan_year = 30;
  double loan_interest = interestRATE;
  String value = '';
  List year_options = [30, 25, 20, 15, 10];
  int currentIndex = 0;
  PageController pageController = PageController();
  final _formKey2 = GlobalKey<FormState>();
  final formatter = new intl.NumberFormat("#,##0");
  TextEditingController hPriceController = TextEditingController();
  TextEditingController downPController = TextEditingController();
  TextEditingController downPPercentController = TextEditingController();
  TextEditingController loanAmtController = TextEditingController();
  TextEditingController interestRController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController Controller = TextEditingController();

  late ScrollController _scrollController;
  Timer? _timer;
  String randomPropAdd = '';

  @override
  initState() {
    super.initState();

    getData();
    randomPropAdd = listRandomAdd[Random().nextInt(listRandomAdd.length)];
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  dispose() {
    _scrollController.dispose();
    pageController.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  getData() async {
    var filter = {'ListingID_MLS': widget.listingKey};
    await SearchResult().getDelScreen(filter).then((l_data) {
      if (mounted) {
        setState(() {
          mapData = l_data;
          var lat = double.parse(mapData['Latitude']);
          var lng = double.parse(mapData['Longitude']);
          if (marker_position == null) {
            marker_position = LatLng(lat, lng);
            addMarker(lat, lng);
            getSimilarProp();
            getSimSoldProp();
            getDetail();
            /*_timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
              if (currentIndex < mapData['PictureArr'].length) {
                currentIndex++;

                pageController.animateToPage(
                  currentIndex,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              } else {
                currentIndex = 2;
              }
            });*/
          }
        });
      }
    });
  }

  getSimilarProp() async {
    Map<String, dynamic> SimData = {
      "latitude": mapData['Latitude'],
      "longitude": mapData['Longitude'],
      "miles": 5,
      "page_size": 5,
      "start_record": 0,
    };

    Map<String, dynamic> arrPost = {'filter': jsonEncode(SimData)};
    await SearchResult().getListData(arrPost).then((similarDataReturn) {
      if (mounted) {
        setState(() {
          listSimilarProperty = similarDataReturn['rs'];
        });
        return similarDataReturn;
      }
    });
  }

  getSimSoldProp() async {
    Map<String, dynamic> SimsoldData = {
      "status": "Closed",
      "so": "price",
      "sd": "DESC",
    };

    Map<String, dynamic> arrPost = {'filter': jsonEncode(SimsoldData)};
    await SearchResult().getListData(arrPost).then((simsolddata) {
      if (this.mounted) {
        if (this.mounted) {
          setState(() {
            listSoldProperty = simsolddata['rs'];
          });
          return simsolddata;
        }
      }
    });
  }

  PageController controller = PageController();
  int _curr = 0;

  bool lastStatus = true;

  String get query => '';

  List<String> listRandomAdd = [
    '936 Kiehn Route, West Ned',
    '4059 Carling Avenue, Ottawa',
    '60 Caradon Hill, Ugglebarnby',
    '289 Mohr Heights, Aprilville',
    '15 Sellamuttu Avenue, 03, Colombo',
    'Avenida Mireia, 5, Los Verdugo de San Pedro',
    'Boulevard Ceulemans 832, Hannut',
    '3064 Schinner Village Suite 621, South Raymond',
    'Thorsten-Busse-Platz 4, Friedrichsdorf'
  ];

  _scrollListener() {
    if (isShrink != lastStatus) {
      if (this.mounted) {
        setState(() {
          lastStatus = isShrink;
        });
      }
    }
  }

  bool get isShrink {
    var mOrientation = MediaQuery.of(context).orientation;

    // Get height of app bar
    var expanded_height = (mOrientation == Orientation.portrait)
        ? MediaQuery.of(context).size.height * 0.37
        : MediaQuery.of(context).size.height / 1.35;
    return _scrollController.hasClients &&
        _scrollController.offset > (expanded_height - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (mapData.length == 0) getData();

    print(mapData);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: (mapData.length > 0)
          ? CustomScrollView(controller: _scrollController, slivers: [
              //sliverListWid()
              silverAppBarCarousel(),
              sliverListWid()
            ])
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  sliverListWid() {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(
          height: 15,
        ),
        (mapData['Address'].isNotEmpty)
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapData["Address"],
                      style:
                          TextStyle(fontSize: 24, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(height: 10),
        //DetailsScreenMap(mapData, _markers),
        mapData['Latitude'] != null && mapData['Longitude'] != null
            ? Container(
                height: MediaQuery.of(context).size.height / 3,
                child: GoogleMap(
                  // mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(mapData['Latitude']),
                        double.parse(mapData['Longitude'])),
                    zoom: 10.00,
                  ),
                  markers: _markers.values.toSet(),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  onMapCreated: (GoogleMapController controller) {},
                ),
              )
            : Container(),
        SizedBox(
          height: 15,
        ),
        PropertyInfo(mapData),
        SizedBox(
          height: 15,
        ),
        (mapData['Description'].isNotEmpty)
            ? PropDescription(mapData)
            : SizedBox(
                height: 0,
              ),
        SizedBox(
          height: 15,
        ),
        PropertyFeachers(mapData),
        SizedBox(
          height: 15,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Mortgage Calculator',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                mortgageForm(),
              ]),
        ),
        SizedBox(
          height: 15,
        ),
        SendRequst(),
        SizedBox(
          height: 20,
        ),
        mapData['Latitude'] != null && mapData['Longitude'] != null
            ? Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Similar Homes For Sale ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // color: Colors.grey.shade200,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (listSimilarProperty.length > 0)
                          ? SimilarHomes(listSimilarProperty)
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      )
                    ],),)
            : emptyBox(),
        SizedBox(
          height: 15,
        ),
        mapData['Latitude'] != null && mapData['Longitude'] != null
            ? Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Similar Sold Homes ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (listSoldProperty.length > 0)
                          ? SimilarSoldHome(listSoldProperty)
                          : emptyBox(),
                      SizedBox(
                        height: 10,
                      )
                    ],),)
            : emptyBox(),
        SizedBox(
          height: 15,
        ),
        mapData['Description'].isNotEmpty ? Disclaimer(mapData) : SizedBox(),
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
      ]),
    );
  }

  Widget silverAppBarCarousel() {
    var List_price =
        formatter.format(double.parse(mapData['ListPrice'].toString()));
    var size = MediaQuery.of(context).size;

    return SliverAppBar(
      leading: IconButton(
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          if (this.mounted) {
            Navigator.pop(context, true);
          }
        },
      ),
      floating: false,
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.50,
      backgroundColor: lastStatus
          ? Colors.grey.shade200
          : Colors.grey.shade200.withOpacity(0.3),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              //height: size.height,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: childWLT(mapData, _curr, size),
                controller: pageController,
                onPageChanged: (num) {
                  setState(() {
                    currentIndex = num;
                  });
                },
              ),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(8.0),
                /* margin: EdgeInsets.only(left: 20,right: 20),*/
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Colors.grey.withOpacity(0.23),
                      ),
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Icon(Icons.home),
                        Text(
                          mapData['PropertyType'],
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Type',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )
                      ]),
                      Column(children: [
                        Icon(Icons.account_balance_wallet),
                        (mapData['Sold_Price'] != null &&
                                mapData['Sold_Price'].isNotEmpty)
                            ? Column(children: [
                                Text(
                                  '${mapData['Sold_Price']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Sold Price',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                Text(
                                  DateFormat.yMMMd().format(DateTime.now()),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ])
                            : mapData['ListPrice'].isNotEmpty
                                ? Column(children: [
                                    Text(
                                      '$List_price',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      'List Price',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    )
                                  ])
                                : Text(
                                    '0',
                                    style: TextStyle(color: Colors.black),
                                  ),
                      ]),
                      Column(children: [
                        Icon(Icons.local_hotel),
                        Text(
                          mapData['Beds'],
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Beds',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )
                      ]),
                      Column(children: [
                        Icon(Icons.bathtub),
                        Text(
                          mapData['Baths'],
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Baths',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )
                      ]),
                    ]),
              ),
            ),
          ],
        ),
        centerTitle: true,
        collapseMode: CollapseMode.pin,
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          color: Colors.white,
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryColor,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text(
                "Share",
                style: TextStyle(color: Colors.black),
              ),
              value: menuValues.share.toString(),
            ),
            PopupMenuItem(
              child: Text("Get Pre-Approved",
                  style: TextStyle(color: Colors.black)),
              value: menuValues.getpre_approved.toString(),
            ),
            PopupMenuItem(
              value: menuValues.enquiry.toString(),
              child: Text("Enquiry", style: TextStyle(color: Colors.black)),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case "menuValues.share":
                Share.share(webUrl,
                    subject: "Data");
                break;
              case "menuValues.getpre_approved":
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Seduletour()));
                break;
              case "menuValues.enquiry":
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Enquiry(
                          listingKey: null,
                          mls_no: mapData['MLS_NUM'],
                        ),),);
                break;
            }
          },
        ),
      ],
    );
  }

  addMarker(latitude, longitude) async {
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

  Widget mortgageForm() {
    downPaymentAmount =
        downPaymentAmount?.replaceAll(RegExp(r'[^%0-9-]'), '');
    loan_principal = loan_principal?.replaceAll(RegExp(r'[^%0-9-]'), '');

    double pi = ((double.parse(downPaymentAmount!) / (loan_year * 365)) +
        (loan_interest) * loan_interest);

    double priceInt = double.parse(pi.toStringAsFixed(2));

    var mOrientation = MediaQuery.of(context).orientation;
    return Form(
        key: _formKey2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Home Value',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: hPriceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: new BorderSide(width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orangeAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.phone,
              onSaved: (String? val) {
                if (this.mounted) {
                  setState(() {
                    loan_balance = val!;
                  });
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Down Payment',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '',
                border: OutlineInputBorder(
                  borderSide: new BorderSide(width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orangeAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12)),
              ),
              controller: downPController,
              keyboardType: TextInputType.phone,
              onSaved: (String? val) {
                if (this.mounted) {
                  setState(() {
                    downPaymentAmount = val!;
                  });
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Mortgage Interest Rate',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '',
                border: OutlineInputBorder(
                  borderSide: new BorderSide(width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orangeAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12)),
              ),
              controller: interestRController,
              onSaved: (String? val) {
                if (this.mounted) {
                  setState(() {
                    loan_interest = double.parse(val!.replaceAll('%', ''));
                  });
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Loan Type',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(width: 2.0),
                ),
                labelText: '',
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orangeAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12)),
              ),
              controller: yearController,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext builder) {
                      return Container(
                        color: Colors.white,
                        height: (mOrientation == Orientation.portrait)
                            ? MediaQuery.of(context).size.height / 2.8
                            : MediaQuery.of(context).size.height / 2.8,
                        child: Column(children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Done',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    4,
                            child: CupertinoPicker(
                                itemExtent: 32.0,
                                backgroundColor: Colors.white,
                                onSelectedItemChanged: (int index) {
                                  if (this.mounted) {
                                    setState(() {
                                      yearController.text =
                                          year_options[index].toString();
                                      loan_year = year_options[index];
                                    });
                                  }
                                },
                                scrollController: FixedExtentScrollController(
                                    initialItem: year_options.indexOf(
                                        int.parse(yearController.text))),
                                children: new List<Widget>.generate(
                                    year_options.length, (int value) {
                                  return new Center(
                                    child: new Text(
                                        '${year_options[value].toString()},year'),
                                  );
                                })),
                          )
                        ]),
                      );
                    });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Property Taxes',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '',
                border: OutlineInputBorder(
                  borderSide: new BorderSide(width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orangeAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12)),
              ),
              controller: loanAmtController,
              onSaved: (String? val) {
                if (this.mounted) {
                  setState(() {
                    loan_principal = val!;
                  });
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Homeowner's Insurance",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '',
                border: OutlineInputBorder(
                  borderSide: new BorderSide(width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orangeAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12)),
              ),
              controller: loanAmtController,
              onSaved: (String? val) {
                if (this.mounted) {
                  setState(() {
                    loan_principal = val!;
                  });
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Private Mortgage Insurance(PMI)',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '',
                border: OutlineInputBorder(
                  borderSide: new BorderSide(width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orangeAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12)),
              ),
              controller: loanAmtController,
              onSaved: (String? val) {
                if (this.mounted) {
                  setState(() {
                    loan_principal = val!;
                  });
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            (mapData['HOAFee'] == null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          'HOA',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: '',
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.orangeAccent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          controller: Controller,
                          onSaved: (String? val) {
                            if (this.mounted) {
                              setState(() {
                                mapData['HOAFee'] = val!;
                              });
                            }
                          },
                        ),
                      ])
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "\$\ ${priceInt}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Principal Interest',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(16),
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        //border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            //"\$\ ${loan_principal!}",
                            "\$\ ${PriceFormat(int.parse(loan_principal!))}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Property tax',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(16),
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        //border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "\$\ ${'0'}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Home Insurance',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(16),
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        // border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "\$\ ${mapData['Tax']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Private Mortgage insurance',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(16),
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "\$\ ${mapData['HOAFee'] == "" ? 0 : mapData['HOAFee']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Hoa Dues',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Monthly Payment ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                    Container(
                        child: Text(
                      '${cCURRENCY}${_monthly_payment ?? '0'}/month',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    )),
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 50.0,
                buttonColor: Theme.of(context).primaryColor,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(250, 40),
                  ),
                  onPressed: () {
                    if (_formKey2.currentState != null) {
                      _formKey2.currentState?.save();
                      Timer(const Duration(milliseconds: 500), () {
                        Mortgage();
                      });
                    }
                  },
                  child: Text(
                    'Calculate',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ));
  }

  Mortgage([init = false]) {
    if (this.mounted) {
      setState(() {
        loan_balance = loan_balance?.replaceAll(RegExp(r'[^%0-9-]'), '');

        var loan_balance_double = double.parse(loan_balance ?? "");
        downPayment = (loan_balance_double * (downPaymentPercent / 100));
        downPaymentAmount = formatter.format(downPayment);

        if (downPaymentPercent == '')
          downPaymentPercent = 0;
        else if (downPaymentPercent > 100) downPaymentPercent = 100;

        // loan_principal =
        // formatter.format(loan_balance_double - downPayment);
        // loan_principal = Double.parseDouble(loan_balance_double - downPayment).getText().toString().replace(",", "");

        loan_principal = formatter.format(loan_balance_double - downPayment);
        var InterDiv = loan_interest;

        if (InterDiv < 0.3) {
          InterDiv = InterDiv * 100.0;
        }

        InterDiv = InterDiv / 1200;

        double radic = 1;
        double moy = 1 + InterDiv;

        var annees = loan_year.toString();

        for (int i = 0; i < int.parse(annees) * 12; i++) {
          radic = radic * moy;
        }

        var emprunte = loan_principal?.replaceAll(RegExp(r'[^%0-9-]'), '');

        int PrinEtInt =
            (int.parse(emprunte ?? "") * InterDiv / (1 - (1 / radic))).round();

        _monthly_payment = formatter.format(double.parse(PrinEtInt.toString()));

        if (init == true) {}

        loan_balance = formatter.format(loan_balance_double);
        hPriceController.text = '${cCURRENCY}${loan_balance}';

        downPController.text = '${cCURRENCY}${downPaymentAmount}';
        downPPercentController.text = '${downPaymentPercent}%';
        loanAmtController.text = '${cCURRENCY}${loan_principal ?? ''}';
        interestRController.text = '${loan_interest}%';
        yearController.text = '${loan_year}';
      });
    }
  }

  MortgageOld([init = false]) {
    loan_balance = loan_balance?.replaceAll(RegExp(r'[^%0-9-]'), '');

    var loan_balance_double = int.parse(loan_balance ?? "");
    downPayment = (loan_balance_double * (downPaymentPercent / 100));
    downPaymentAmount = downPayment.toString();

    if (downPaymentPercent == '')
      downPaymentPercent = 0;
    else if (downPaymentPercent > 100) downPaymentPercent = 100;

    // loan_principal =
    // formatter.format(loan_balance_double - downPayment);
    // loan_principal = Double.parseDouble(loan_balance_double - downPayment).getText().toString().replace(",", "");

    loan_principal = (loan_balance_double - downPayment).toString();
    var InterDiv = loan_interest;

    if (InterDiv < 0.3) {
      InterDiv = InterDiv * 100.0;
    }

    InterDiv = InterDiv / 1200;

    double radic = 1;
    double moy = 1 + InterDiv;

    var annees = loan_year.toString();

    for (int i = 0; i < int.parse(annees) * 12; i++) {
      radic = radic * moy;
    }

    var emprunte = loan_principal?.replaceAll(RegExp(r'[^%0-9-]'), '');

    int PrinEtInt =
        (int.parse(emprunte ?? "") * InterDiv / (1 - (1 / radic))).round();

    _monthly_payment = formatter.format(double.parse(PrinEtInt.toString()));

    if (init == true) {}

    loan_balance = formatter.format(loan_balance_double);
    hPriceController.text = '${cCURRENCY}${loan_balance}';

    downPController.text =
        '${cCURRENCY}${formatter.format(double.parse(downPaymentAmount ?? ''))}';
    downPPercentController.text = '${downPaymentPercent}%';
    loanAmtController.text =
        '${cCURRENCY}${formatter.format(double.parse(loan_principal ?? ''))}';
    interestRController.text = '${loan_interest}%';
    yearController.text = '${loan_year}';
  }

  getDetail() {
    if (loan_balance == null) {
      loan_balance = mapData['ListPrice'];

      Mortgage(true);
    }
  }

  childWLT(data, active, Size size) {
    List<Widget> listWIntroL = <Widget>[];
    var listPic = (data['PictureArr'] is Map &&
            data['PictureArr'].containsKey('large') == true)
        ? data['PictureArr']['large']
        : data['PictureArr'];
    if (listPic != null && listPic.length > 0) {
      for (var i = 0; i < listPic.length; i++) {
        var pImg = (listPic[i] is Map && listPic[i].containsKey('url') == true)
            ? listPic[i]['url']
            : listPic[i];
        //pImg = pImg.replaceAll('realstoria.thatsend.net', 'realstoria.com');
        pImg = pImg.replaceAll('realstoria.thatsend.app', 'realstoria.com');
        print('--- pImg ---');
        print(pImg);
        listWIntroL.add(Stack(
          children: [
            CachedNetworkImage(
              imageUrl: pImg + '/1024/768/',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.none
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)),
              errorWidget: (context, url, error) =>
                  CachedNetworkImage(
                    imageUrl: global.mapConfige['img_na_property'],
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
            ),
          ],
        ));
      }
    }
    return listWIntroL;
  }

  Widget emptyBox() {
    return new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }

  PriceFormat(int nStr, [noOfDecimal]) {
    dynamic tmpNo;
    var tmpStr;
    if (nStr > 1000000000000) {
      tmpNo = (nStr / 1000000000000);
      noOfDecimal = (noOfDecimal != null) ? noOfDecimal : 2;
      tmpStr = 'T';
    } else if (nStr >= 1000000000) {
      tmpNo = (nStr / 1000000000);
      noOfDecimal = (noOfDecimal != null) ? noOfDecimal : 2;
      tmpStr = 'B';
    } else if (nStr >= 1000000) {
      tmpNo = (nStr / 1000000);
      noOfDecimal = (noOfDecimal != null) ? noOfDecimal : 2;
      tmpStr = 'M';
    } else if (nStr >= 1000) {
      tmpNo = (nStr / 1000).round();
      tmpStr = 'K';
    }
    if (tmpNo != '') {
      if (tmpNo % (1) != 0) {
        if (noOfDecimal != null) {
          return tmpNo.toStringAsFixed(noOfDecimal).toString() + tmpStr;
        } else {
          return tmpNo.round().toString() + tmpStr;
        }
      } else {
        return tmpNo.toString() + tmpStr;
      }
    } else {
      return nStr.toString();
    }
    }
}
