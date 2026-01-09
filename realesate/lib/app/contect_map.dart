import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContactMap extends StatelessWidget {
  Map<String, dynamic> mapData = {};
  Map<String, Marker> _markers = {};

  ContactMap(this.mapData, this._markers, {Key? key}) : super(key: key);

  googleMapLocation() {
    return GoogleMap(
      // mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(22.561709, 72.923040),
        zoom: 10.00,
      ),
      myLocationButtonEnabled: false,
      markers: _markers.values.toSet(),
      onMapCreated: (GoogleMapController controller) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 250,
      width: 550,
      child: googleMapLocation(),
    );
  }
}
