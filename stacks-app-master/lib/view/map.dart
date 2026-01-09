import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stacks/controller/home_controller.dart';

import 'package:stacks/theme/app_colors.dart';
import 'package:stacks/view/search.dart';
import 'package:stacks/view/widgets/menu/top_menu.dart';
import 'package:stacks/view/widgets/records.dart';

import 'widgets/record_card.dart';
import 'widgets/record_card_map.dart';
import 'widgets/record_card_text.dart';
import 'widgets/record_card_text_map.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  HomeController _linkMapController = Get.put(HomeController());

  late GoogleMapController _controller;
  late PageController _pageController;
  int prevPage = 0;
  bool onMarkerClick = false;
  bool onInit = false;
  bool activeBottomSheet = false;
  double latitudeFix = 0.0;
  double longitudeFix = 0.0;

  static LatLng showLocation =
      const LatLng(18.982157424131366, -99.8121066391468);

  final Set<Marker> markers = new Set();
  final LatLng _lastMapPosition = showLocation;

  @override
  void initState() {
    _getUserLocation();
    _linkMapController.getSharedText();
    _linkMapController.receiveShareIntent();
    Future.delayed(Duration.zero, () => _linkMapController.getPlacesLinks());
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    super.initState();
  }

  void _getUserLocation() async {
    Location location = new Location();
    bool serviceEnabled;
    PermissionStatus checkPermission;
    LocationData _locationData;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      _showMyCurrentLocationDialog();
      return Future.error('Location services are disabled.');
    }

    checkPermission = await location.hasPermission();
    if (checkPermission == PermissionStatus.deniedForever) {
      //await location.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (checkPermission == PermissionStatus.denied) {
      checkPermission = await location.requestPermission();
      if (checkPermission != PermissionStatus.grantedLimited &&
          checkPermission != PermissionStatus.granted) {
        return Future.error(
            'Location permissions are denied (actual value: $checkPermission).');
      }
    }
    _locationData = await location.getLocation();

    if (this.mounted) {
      setState(() {
        showLocation = LatLng(_locationData.latitude!, _locationData.longitude!);
        _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            //target: LatLng(19.990908, 73.7898023),
            target: LatLng(_locationData.latitude!, _locationData.longitude!),
            zoom: 15.0,
          ),
        ));
      });
    }
  }


  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      moveCamera();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var leyOut = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: backgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            /// Go to search page
            Get.to(SearchPage());
          },
          child: Icon(CupertinoIcons.search),
        ),
        bottomNavigationBar: BottomMenu(),
        body: _notificationListener(Stack(
          children: [
            Obx(() {
              return bindGoogleMap();
            }),
            activeBottomSheet == true ?
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                height: (leyOut == Orientation.portrait)
                    ? (MediaQuery.of(context).size.width <= 360)
                    ? MediaQuery.of(context).size.height / 2.3
                    : MediaQuery.of(context).size.height / 2.5
                    : MediaQuery.of(context).size.height / 1.5,
                padding: const EdgeInsets.only(top: 20),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _linkMapController.placesLinks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _placesLinksList(index);
                  },
                ),
              ),
            ) : SizedBox(),
            Obx((){
              return _linkMapController.loading ? loader() : SizedBox();
            }),
          ],
        ),),);
  }

  _notificationListener(Widget child) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical &&
            notification.metrics.pixels ==
                notification.metrics.maxScrollExtent &&
            notification.metrics.atEdge) {
        }
        return true;
      },
      child: child,
    );
  }

  Widget bindGoogleMap() {
    if(markers.length <= 0 && _linkMapController.placesLinks.length > 0 /*&&  !_linkMapController.loading*/){
      getMarkers();
    }
    return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: (_linkMapController.latLng.length > 0) ?  LatLng(double.parse(_linkMapController.latLng['lat']), double.parse(_linkMapController.latLng['lng'])) : _lastMapPosition,
              zoom: 14.4746,
            ),
            markers: markers.toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              onInit = true;
              if(_linkMapController.placesLinks.isNotEmpty){
                _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(double.parse(_linkMapController.latLng['lat']), double.parse(_linkMapController.latLng['lng'])),
                    zoom: 14.0,
                    bearing: 45.0,
                    tilt: 45.0)));
              }
            },
            onTap: (LatLng pos) {
              setState(() {
                activeBottomSheet = false;
                onMarkerClick = false;
              });
            },
            gestureRecognizers: Set()
              ..add(
                  Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
            onCameraMoveStarted: () {
              if(onMarkerClick == false && onInit == false){
                _controller.getVisibleRegion().then((bound) {
                  markers.clear();
                  Map<String, dynamic> boundary = {
                    "top_left": {
                      "lat": "${bound.northeast.latitude}",
                      "lon": "${bound.southwest.longitude}"
                    },
                    "bottom_right": {
                      "lat": "${bound.southwest.latitude}",
                      "lon": "${bound.northeast.longitude}"
                    },
                  };
                  if(boundary.isNotEmpty){
                    _linkMapController.getPlacesLinks(mapBound: boundary);
                  }
                });
              } else {
                onInit = false;
              }
            },
          );
  }

  _onMarkerClick() {
    var leyOut = MediaQuery.of(context).orientation;
    Future<void> future = showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: (leyOut == Orientation.portrait)
                ? (MediaQuery.of(context).size.width <= 360)
                ? MediaQuery.of(context).size.height / 1.8
                : MediaQuery.of(context).size.height / 2.5
                : MediaQuery.of(context).size.height / 1.5,
            padding: const EdgeInsets.only(top: 20),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _linkMapController.placesLinks.length,
              itemBuilder: (BuildContext context, int index) {
                return _placesLinksList(index);
              },
            ),
          );
        });
        future.then(
            (void value) => onMarkerClick = false);
  }

  _placesLinksList(index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? child) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        if (_linkMapController
            .placesLinks[index]['link']['target_url'].contains('://')) {
          if (_linkMapController
              .placesLinks[index]['link']['image_url'] == null ||
              _linkMapController
                  .placesLinks[index]['link']['image_url']?.contains(
                  "data:")) {
            return RecordCardTextMap(
              id: _linkMapController.placesLinks[index]['link']['id'],
              title: _linkMapController
                  .placesLinks[index]['link']['title'] != null
                  ? _linkMapController
                  .placesLinks[index]['link']['title']
                  : "-NA-",
              date: _linkMapController
                  .placesLinks[index]['link']['updated_at'],
              rating: _linkMapController
                  .placesLinks[index]['link']['rating'] != null
                  ? _linkMapController
                  .placesLinks[index]['link']['rating']['average_rating']
                  : 0.0,
              content: _linkMapController
                  .placesLinks[index]['link']['description'],
              link: _linkMapController
                  .placesLinks[index]['link']['target_url'],
              faviconUrl: _linkMapController
                  .placesLinks[index]['link']['favicon_url'] != null
                  ? _linkMapController
                  .placesLinks[index]['link']['favicon_url']
                  : '',
            );
          }
          return RecordCardMap(
            id: _linkMapController.placesLinks[index]['link']['id'],
            title: _linkMapController
                .placesLinks[index]['link']['title'] != null
                ? _linkMapController
                .placesLinks[index]['link']['title']
                : "-NA-",
            date: _linkMapController
                .placesLinks[index]['link']['updated_at'],
            rating: _linkMapController
                .placesLinks[index]['link']['rating'] != null
                ? _linkMapController
                .placesLinks[index]['link']['rating']['average_rating']
                : 0.0,
            link: _linkMapController
                .placesLinks[index]['link']['target_url'],
            imageUrl: _linkMapController
                .placesLinks[index]['link']['image_url'],
            faviconUrl: _linkMapController
                .placesLinks[index]['link']['favicon_url'] != null
                ? _linkMapController
                .placesLinks[index]['link']['favicon_url']
                : '',
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget bottomSheet(Map<String, dynamic> onMarkerClick) {
    return Obx(() {
      return _linkMapController.placesLinks.isNotEmpty &&
          _linkMapController.placesLinks.length > 0
          ? _linkMapController.isList
          ? CardsSliderViewSliver(links: _linkMapController.placesLinks)
          : CardsSliderViewSliver(links: _linkMapController.placesLinks)
          : SliverToBoxAdapter(child: _noData());
    });
  }

  Set<Marker> getMarkers() {
    for (var i = 0; i < _linkMapController.placesLinks.length; i++) {
      if (_linkMapController.placesLinks[i]['latitude'] != null &&
          _linkMapController.placesLinks[i]['longitude'] != null)
        markers.add(Marker(
            markerId: MarkerId(_linkMapController.placesLinks[i]['id']),
            draggable: false,
            infoWindow:
            InfoWindow(title: _linkMapController.placesLinks[i]['link']['title']),
            //position of marker
            position: LatLng(
                double.parse(_linkMapController.placesLinks[i]['latitude']),
                double.parse(_linkMapController.placesLinks[i]['longitude'])),
            onTap: () {
              onMarkerClick = true;
              setState(() {
                if(activeBottomSheet == false) {
                  activeBottomSheet = true;
                } else {
                  activeBottomSheet = false;
                }
              });

             // _onMarkerClick(i);
              Timer(const Duration(milliseconds: 100), () {
                if (_pageController.hasClients) {
                  _pageController.jumpToPage(i);
                }
              });
            }));
    }
    return markers;
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            double.parse(_linkMapController.placesLinks[_pageController.page!.toInt()]['latitude']),
            double.parse(_linkMapController.placesLinks[_pageController.page!.toInt()]['longitude'])),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  Future<void> _showMyCurrentLocationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location not available'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This feature cannot be used without knowing your current location.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: primaryColor,)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Go to Settings', style: TextStyle(color: primaryColor,),),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
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
          new SizedBox(
            height: 50.0,
            width: 50.0,
            child: CupertinoActivityIndicator(),
          ),
          new Text(
            "Loading...",
          ),
        ],
      ),
    );
  }

  Widget _noData() {
    return Center(
      child: Column(
        children: [
          Image.asset("images/stacks-gray-logo.png", height: 200, width: 100),
          Text(
            _linkMapController.loading == false
                ? "No Stacks added yet!"
                : "Loading Stacks",
            style: TextStyle(
              color: headingColor,
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
