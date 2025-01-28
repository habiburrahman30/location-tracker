import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/base.dart';

class GoogleMapComponent extends StatefulWidget {
  const GoogleMapComponent({super.key});

  @override
  State<GoogleMapComponent> createState() => GoogleMapComponentState();
}

class GoogleMapComponentState extends State<GoogleMapComponent> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          GoogleMap(
            mapType: Base.locationTrackerController.mapType.value,
            myLocationEnabled: true,
            // myLocationButtonEnabled: false,

            // tiltGesturesEnabled: true,
            // compassEnabled: true,
            // scrollGesturesEnabled: true,
            // zoomGesturesEnabled: true,
            zoomControlsEnabled: false,

            initialCameraPosition: CameraPosition(
              target: Base.locationTrackerController.currentLocation.value,
              zoom: 17,
            ),

            // cameraTargetBounds: CameraTargetBounds.unbounded,
            onMapCreated: (controller) {
              Base.locationTrackerController.mapController = controller;
            },

            markers: Set<Marker>.of(Base.locationTrackerController.markerList),
            // markers: markers,

            onTap: (_) {},
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              onPressed: () {
                Base.locationTrackerController.getCurrentLocation();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              icon: Icon(Icons.my_location_rounded),
            ),
          ),
          Positioned(
            right: 10,
            top: 60,
            child: IconButton(
              onPressed: () {
                showMenu(
                  context: context,
                  color: Colors.white,
                  position: RelativeRect.fromDirectional(
                    textDirection: TextDirection.ltr,
                    start: 0,
                    top: 210,
                    end: -200,
                    bottom: 50,
                  ),
                  items: [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Normal"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("Satellite"),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text("Hybrid"),
                    ),
                  ],
                ).then((value) {
                  if (value != null) {
                    switch (value) {
                      case 0:
                        Base.locationTrackerController.mapType.value =
                            MapType.normal;
                        break;
                      case 1:
                        Base.locationTrackerController.mapType.value =
                            MapType.satellite;
                        break;
                      case 2:
                        Base.locationTrackerController.mapType.value =
                            MapType.hybrid;
                        break;
                      default:
                        Base.locationTrackerController.mapType.value =
                            MapType.normal;
                    }
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              icon: Icon(Icons.map),
            ),
          ),
        ],
      ),
    );
  }

  Set<Circle> circles = <Circle>{
    Circle(
      circleId: CircleId('user'),
      center: LatLng(23.813275, 90.424384),
      radius: 100,
      fillColor: Colors.blue.withValues(alpha: 0.1),
      strokeWidth: 0,
    )
  };
  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Base.locationTreceController.currentLocation.value.latitude !=
                  0.0
              ? LatLng(
                  Base.locationTreceController.currentLocation.value.latitude,
                  Base.locationTreceController.currentLocation.value.longitude,
                )
              : LatLng(23.813275, 90.424384),
          zoom: 18,
        ),
      ),
    );
  }

  //=======================

  Marker userMarker = Marker(
    markerId: MarkerId('user'),
    position: LatLng(23.813275, 90.424384),
    infoWindow: InfoWindow(title: 'User'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    ),
  );
  Marker riderMarker = Marker(
    markerId: MarkerId('rider'),
    position: LatLng(23.813275, 90.424384),
    infoWindow: InfoWindow(title: 'Rider'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    ),
  );
}
