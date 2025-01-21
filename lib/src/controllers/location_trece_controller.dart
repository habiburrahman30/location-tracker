import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../base/base.dart';
import '../helpers/klog.dart';

class LocationTreceController extends GetxController {
  StreamSubscription<Position>? positionStream;

  final userAddress = RxString('');

  final location = Rx<LatLng>(LatLng(0.0, 0.0));
  final googleMapController = Completer<GoogleMapController>();
  final mapType = Rx<MapType>(MapType.normal);

  //
  final locationList = RxList<LatLng>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async {
    if (await Base.permissionHandlerService
        .isPermissionGranted(Permission.location)) {
      await getAddressFromLatLng();
    }
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> getAddressFromLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    //Add the current location to the location variable
    location.value = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];

    // '${place.street}, ${place.locality}, ${place.postalCode}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    userAddress.value =
        '${place.street}, ${place.locality}-${place.postalCode}, ${place.country}';
  }

  //Map default marker
  Marker defaultLocationMarker = Marker(
    markerId: MarkerId('foodgram'),
    position: LatLng(23.813275, 90.424384),
    infoWindow: InfoWindow(title: 'Food Gram Ltd'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
    ),
  );

  //Get current user location
  Future<void> getCurrentLocation() async {
    final GoogleMapController controller = await googleMapController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location.value,
          zoom: 14,
        ),
      ),
    );
  }

  void getLocationUpdates() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      klog('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    });
  }

  void stopListening() {
    positionStream?.cancel();
  }

  // Calculate the distance between two points
  void calculateDistance() {
    double startLatitude = 52.2165157;
    double startLongitude = 6.9437819;
    double endLatitude = 52.3546274;
    double endLongitude = 4.8285838;

    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

    klog('The distance between these points is $distanceInMeters meters.');
  }

  //===================================
  late Timer timer;
  final isListening = RxBool(false);

  void startListening() {
    if (isListening.value) return;

    isListening.value = true;

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getLocation();
    });
  }

  void stopListening2() {
    if (timer.isActive) {
      timer.cancel();
    }
    isListening.value = false;
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    if (locationList.contains(LatLng(position.latitude, position.longitude))) {
      klog('LatLng is in the list.');
    } else {
      klog('LatLng is not in the list.');
      locationList.add(LatLng(position.latitude, position.longitude));
    }

    klog(locationList.toJson());
  }
}
