import 'package:driver/constant/constant.dart';
import 'package:driver/controller/live_tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LiveTrackingController>(
      init: LiveTrackingController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            // backgroundColor: AppColors.darkModePrimary,

            title: Text("Map view".tr),
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                )),
          ),
          body: GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.terrain,
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(controller.polyLines.values),
            padding: const EdgeInsets.only(
              top: 22.0,
            ),
            markers: Set<Marker>.of(controller.markers.values),
            onMapCreated: (GoogleMapController mapController) {
              controller.mapController = mapController;
            },
            initialCameraPosition: CameraPosition(
              zoom: 15,
              target: LatLng(
                  Constant.currentLocation.value != null
                      ? Constant.currentLocation.value.latitude!.toDouble()
                      : 45.521563,
                  Constant.currentLocation != null
                      ? Constant.currentLocation.value.longitude!.toDouble()
                      : -122.677433),
            ),
          ),
        );
      },
    );
  }
}
