import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'layout/listing/filter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../app/core/global.dart' as globals;
import 'layout/listing/listing_box.dart';
import 'loader.dart';

class GMap extends StatefulWidget {
  Map<String, dynamic>? filter;
  bool isLoading;
  ValueSetter<Map<String, dynamic>> refreshData;
  List listAllData = [];

  GMap({
    Key? key,
    this.filter,
    required this.listAllData,
    required this.isLoading,
    required this.refreshData,
  }) : super(key: key);

  @override
  State<GMap> createState() => GMapState(this.filter);
}

class GMapState extends State<GMap> {
  CarouselController buttonCarouselController = CarouselController();
  GoogleMapController? mapController;
  Map<String, dynamic>? filter;
  bool zoomGesturesEnabled = true;
  bool scrollGesturesEnabled = true;
  bool showData = false;
  PageController? _pageController;

  GMapState(this.filter);

  int? _activeMarker;
  List<Marker> listMarker = [];
  Map<String, Marker> _mapMarkers = <String, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  int? prevPage;
  LatLng? currentPosition;
  double mapZoom = 20.00;
  List<LatLng> _markerList = [];
  bool goToCenter = false;
  bool sliderData = true;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(double.parse(globals.mapConfige['default_lat']),
        double.parse(globals.mapConfige['default_lang']),
    ),
    zoom: 9.00,
  );

  moveCamera(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng),
            zoom: this.mapZoom,
            bearing: 45.0,
            tilt: 45.0),
      ),
    );
  }

  var myIcon, greenCircle;

  @override
  void initState() {
    print('--------- MAP init state ------------');
    _pageController?.dispose();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/marker_orange.png')
        .then((onValue) {
      if (this.mounted) {
        setState(() {
          myIcon = onValue;
          // createMarkers();
          //MapMarker(position: LatLng(49.246292, -123.116226), id: '66');
        });
      }
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(1, 1)), 'assets/active.png')
        .then((onValue) {
      if (this.mounted) {
        setState(() {
          greenCircle = onValue;
        });
      }
    });
    // Set default sort option
    if (this.filter == null || this.filter?.containsKey('so') == false) {
      this.filter = {};
      this.filter?.addAll({'so': 'price', 'sd': 'desc'});
    }
    super.initState();
  }

  @override
  void dispose() {
    mapController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this._mapMarkers.length <= 0 && widget.listAllData.length > 0) {
      createMarkers();
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            minMaxZoomPreference: MinMaxZoomPreference(5, 100),
            initialCameraPosition: _kGooglePlex,
            zoomGesturesEnabled: zoomGesturesEnabled,
            scrollGesturesEnabled: scrollGesturesEnabled,
            markers: Set<Marker>.of(this._mapMarkers.values),
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            //markers: _markers,
            //onTap: _onMapTap,
            onCameraMoveStarted: () {
              mapController!.getVisibleRegion().then((bound) {
                if (_activeMarker == null && goToCenter == false) {
                  onCameraMS();
                }
                goToCenter = false;
              });
            },
            onCameraMove: _onCameraMove,
            /*onTap: () async {
                print('@@@@@@@@@@@');
                var icon_image = 'assets/marker_orange.png';
                if (_activeMarker != null &&
                    widget.listAllData[_activeMarker ?? 0]['PropertyType'] ==
                        'Rental' ||
                    widget.listAllData[_activeMarker ?? 0]['PropertyType'] ==
                        'ResidentialLease') {
                  icon_image = 'assets/marker_yellow.png';
                } else {
                  BitmapDescriptor.fromAssetImage(
                      ImageConfiguration(size: Size(48, 48)), icon_image);
                }
                _activeMarker = null;
                BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(size: Size(48, 48)), icon_image)
                    .then((onValue) {
                  setState(() {
                    myIcon = onValue;
                    this._mapMarkers.clear();
                    createMarkers();
                  });
                });
              },*/
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0, right: 10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final result = PersistentNavBarNavigator.pushNewScreen(
                        context,
                        withNavBar: false,
                        screen:
                            FilterScreen(filter: this.filter, onPage: 'Map'));
                    result.then((value) {
                      if (value != null) {
                        if (this.mounted) {
                          setState(() {
                            // If apply filters with new data OR didn't perform clear filter on filter page that time need to clear markers to create new markers from build.
                            if (value is Map) this._mapMarkers.clear();
                            this.filter = value;
                            refreshDataFP('refresh');
                          });
                        }
                      }
                    });
                  },
                  child: Icon(
                    Icons.filter_alt_outlined,
                    size: 32.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          (widget.isLoading == true) ? loader() : emptyBox(),
        ],
      ),
    );
  }

  void _onBottomSheetClose() {
    if (this.mounted) {
      setState(() {
        var oldActiveMarker = _activeMarker;
        _activeMarker = null;
        if (oldActiveMarker != null) activePropertyMarker(oldActiveMarker);
      });
    }
    //prevPage = null;
    // Get current map position
    //moveCamera(_lastMapPosition.latitude, _lastMapPosition.longitude);
  }

  Widget loader() {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        color: Color.fromARGB(1, 0, 0, 0),
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

  LatLngBounds getBounds(
    List<LatLng> markers,
  ) {
    var lngs =
        markers.map<double>((m) => m.longitude).toList(); // Converted to list
    var lats =
        markers.map<double>((m) => m.latitude).toList(); // Converted to list

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  _onMarkerTapped(markerId) {
    loader();
    Widget slider = buildCarousel(markerId);
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return slider;
        }).then((value) => _closeModal(value));
  }

  _closeModal(value) {
    _onBottomSheetClose();
  }

  buildCarousel(markerId) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: CarouselSlider(
        options: CarouselOptions(
          initialPage: markerId,
          autoPlay: false,
          enlargeCenterPage: true,
          onPageChanged: (int index, CarouselPageChangedReason reason) async {
            _onScroll(index);
          },
        ),
        items: Slider(widget.listAllData),
      ),
    );
  }

  Slider(data) {
    loader();
    sliderData = false;
    List<Widget> fls = <Widget>[];
    data.forEach((flSlider) {
      fls.add(ListingBox(data: flSlider));
    });
    return fls;
  }

  onCameraMS() async {
    final GoogleMapController g_controller = await _controller.future;
    var bound = await g_controller.getVisibleRegion();
    late LatLngBounds c_latLong;

    //var boundaries = '${bound.southwest.latitude}, ${bound.southwest.longitude}, ${bound.northeast.latitude}, ${bound.northeast.longitude}';
    if (this.mounted) {
      setState(() {
        _mapMarkers.clear();
        this.filter?['map'] =
            '${bound.southwest.latitude},${bound.southwest.longitude},${bound.northeast.latitude},${bound.northeast.longitude}';
        //this._mapMarkers;
        refreshDataFP('refresh');
      });
    }
    goToCenter = false;
  }

  createMarkers() async {
    print('--------- createMarkers ------------');
    print(widget.listAllData);
    _mapMarkers.clear();
    listMarker.clear();
    _markerList.clear();
    if (widget.listAllData.length > 0 && myIcon != null) {
      print(1);
      for (int i = 0; i < widget.listAllData.length; i++) {
        print(2);
        if (widget.listAllData[i]['Latitude'] != null &&
            widget.listAllData[i]['Longitude'] != null) {
          print(3);
          /*print('markerdata2');
          print(widget.listAllData[i]['PropertyType']);
          final MarkerId markerId =
          MarkerId(widget.listAllData[i]['ListingID_MLS']);
          if (widget.listAllData[i]['PropertyType'] == 'Rental' ||
              widget.listAllData[i]['PropertyType'] == 'ResidentialLease') {
            print('markerdata3');
            icon_type = await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(48, 48)),
                'assets/marker_yellow.png');
          } else {
            icon_type = myIcon;
          }*/
          String sortPrice =
              PriceFormat(double.parse(widget.listAllData[i]['ListPrice']));

          Uint8List? markerIcon = await getBytesFromCanvas(150, 80,
              '\$${sortPrice}', widget.listAllData[i]['ListingID_MLS']);

          final Marker marker =
              getSingleMarker(widget.listAllData[i], markerIcon, i);
          this._mapMarkers[widget.listAllData[i]['ListingID_MLS']] = marker;
          //final Marker marker = await getSingleMarker(widget.listAllData[i], icon_type, i);
          //this._mapMarkers[markerId] = marker;
          _markerList.add(LatLng(
              double.parse(widget.listAllData[i]['Latitude']),
              double.parse(widget.listAllData[i]['Longitude'])));
        }
      }
    }
    if (_markerList.length > 0 && this.filter?.containsKey('map') == false) {
      print(4);
      goToCenter = true;
      camcenter(_markerList);
    }

    print('--------- _markerList ------------');
    print(_markerList);
    if (this.mounted) {
      setState(() {
        _markerList;
      });
    }
  }

  refreshDataFP(String s) {
    var data = {
      'action': 'refresh',
      'filter': this.filter,
    };
    widget.refreshData(data);
    print('-------Map data---------');
    print(data);
  }

  getSingleMarker(dynamic objProp, markerIcon, index) {
    if (objProp['PropertyType'] == 'Rental' ||
        objProp['PropertyType'] == 'ResidentialLease') {
    } else {}
    return Marker(
      markerId: MarkerId(objProp['ListingID_MLS']),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: LatLng(
        double.parse(widget.listAllData[index]['Latitude']),
        double.parse(widget.listAllData[index]['Longitude']),
      ),
      /*infoWindow: InfoWindow(
        title: listprice,
      ),*/
      onTap: () async {
        _onMarkerTapped(index);
        if (_activeMarker != null) {
          int? oldActivemarker = _activeMarker;
          _activeMarker = null;

          // Set old marker as old color
          activePropertyMarker(oldActivemarker);
        }
        _activeMarker = index;

        // Set new active marker
        activePropertyMarker(index);
      },
    );
  }

  camcenter(List<LatLng> markers) {
    LatLngBounds c_latLong = getBounds(markers);

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(c_latLong, 20);
    mapController?.animateCamera(u2).then((void v) {
      check(u2, this.mapController!);
    });
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController?.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  activePropertyMarker(index) async {
    /*final marker =
    getSingleMarker(widget.listAllData[index], markerIcon, index);
    if (this.mounted) {
      setState(() {
        this._mapMarkers[MarkerId(widget.listAllData[index]['ListingID_MLS'])] =
            marker;
      });
    }*/
    String sortPrice =
        PriceFormat(double.parse(widget.listAllData[index]['ListPrice']));

    Uint8List? markerIcon = await getBytesFromCanvas(
        150, 80, '\$${sortPrice}', widget.listAllData[index]['ListingID_MLS']);

    final marker =
        getSingleMarker(widget.listAllData[index], markerIcon, index);
    if (this.mounted) {
      setState(() {
        this._mapMarkers[widget.listAllData[index]['ListingID_MLS']] = marker;
      });
    }
  }

  /*activePropertyMarkerlable(index,markerIcon) async {
    // activeMarker = index;
    String sortPrice =
    PriceFormat(double.parse(widget.listAllData[index]['ListPrice']));

    Uint8List? markerIcon = await getBytesFromCanvas(
        150, 80, '\$${sortPrice}',widget.listAllData[index]['ListingID_MLS']);

    final marker =
    getSingleMarker(widget.listAllData[index], markerIcon, index);
    if (this.mounted) {
      setState(() {
        this._mapMarkers[widget.listAllData[index]['ListingID_MLS']] = marker;
      });
    }
  }*/
  Future<Uint8List?> getBytesFromCanvas(
      int width, int height, String price, dynamic mlsMarks) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = (_activeMarker != null &&
              widget.listAllData[_activeMarker ?? 0]['ListingID_MLS'] ==
                  mlsMarks)
          ? Color(0xFFf9d436)
          : Theme.of(context).primaryColor;

    //final Radius radius = Radius.circular(20.0);
    double radius = width / 2.5;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    //canvas.drawRect(Offset(radius, radius) & Size(radius, radius), Paint());

    /*
    * Rectangle
    * */
    //radius = width/1;
    // anvas.drawRect(Offset(radius, radius) &  Size(100, 30), paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: price,
      style: TextStyle(color: Colors.black, fontSize: 26.0),
    );
    painter.layout();
    painter.paint(canvas,
        Offset(radius - painter.width / 2.1, radius - painter.height / 2));
    final img = await pictureRecorder
        .endRecording()
        .toImage(radius.toInt() * 2, radius.toInt() * 2);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  Future<Uint8List?> __getBytesFromCanvas(
      int width, int height, String price, dynamic mlsMarks) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = (_activeMarker != null &&
              widget.listAllData[_activeMarker ?? 0]['ListingID_MLS'] ==
                  mlsMarks)
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).toggleableActiveColor;
    //final Radius radius = Radius.circular(20.0);
    final double radius = width / 2.5;
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: price,
      style: TextStyle(color: Colors.white, fontSize: 26.0),
    );
    painter.layout();
    painter.paint(canvas,
        Offset(radius - painter.width / 2, radius - painter.height / 2));
    final img = await pictureRecorder
        .endRecording()
        .toImage(radius.toInt() * 2, radius.toInt() * 2);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  void _onCameraMove(CameraPosition position) {
    // Added with TEMP
    if (this.mounted) {
      setState(() {
        mapZoom = position.zoom;
      });
    }
  }

  Widget emptyBox() {
    return new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }

  void Controller() {
    var deviceOrientation = MediaQuery.of(context).orientation;
    _pageController = PageController(
        initialPage: (_activeMarker != null) ? _activeMarker ?? 0 : 0,
        viewportFraction:
            (deviceOrientation == Orientation.portrait) ? 0.8 : 0.5)
      ..addListener(_onScroll(_activeMarker!));
  }

  _onScroll(int index) async {
    if (index != prevPage &&
        (widget.listAllData.length != 0 && widget.isLoading == false)) {
      moveCamera(double.parse(widget.listAllData[index]['Latitude']),
          double.parse(widget.listAllData[index]['Longitude']));

      prevPage = index;
      /*if (_activeMarker != null) {
        int? oldActivemarker = _activeMarker;
        _activeMarker = null;
        var icon_type_n = myIcon;
        if (widget.listAllData[index]['PropertyType'] == 'Rental' ||
            widget.listAllData[index]['PropertyType'] == 'ResidentialLease') {
          icon_type_n = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(48, 48)),
              'assets/marker_yellow.png');
        }
        activePropertyMarker(oldActivemarker,icon_type_n);
      }
      _activeMarker = prevPage;
      var new_icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)), 'assets/activemarker.png');
      activePropertyMarker(prevPage,new_icon);*/
      if (_activeMarker != null) {
        // Store oldactive marker index to new variable
        int? oldActivemarker = _activeMarker;
        // Set active markers index to null becuase we need primary color for old marker
        _activeMarker = null;
        // Set old marker color as default
        activePropertyMarker(oldActivemarker);
      }
      // activeMarker = propertyList[i].MLS_NUM ;
      // Change index of new active marker
      _activeMarker = prevPage;
      // Change color of new active marker
      activePropertyMarker(prevPage);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    if (this.mounted) {
      setState(() {
        mapController = controller;
      });
    }
    var style = [
      {
        "elementType": "geometry",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {"color": "#2A2A2B"}
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {"color": "#ECEBE9"}
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {"color": "#B1BDD6"}
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#B1BDD6"}
        ]
      }
    ];
    mapController?.setMapStyle(jsonEncode(style));
    _controller.complete(controller);
  }

  PriceFormat(double nStr, [noOfDecimal]) {
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
    return tmpNo.round().toString() + tmpStr;
    /*if (tmpNo != '') {
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
    }*/
  }
}
