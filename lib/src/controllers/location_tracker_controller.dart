import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:location_tracker/src/helpers/klog.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

import '../base/base.dart';

class LocationTrackerController extends GetxController {
  Location location = Location();
  // final locationData = LocationData.fromMap({
  //   'latitude': 0.0,
  //   'longitude': 0.0,
  //   'accuracy': 0.0,
  //   'altitude': 0.0,
  //   'speed': 0.0,
  //   'speed_accuracy': 0.0,
  //   'heading': 0.0,
  //   'time': 0,
  // });

  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData locationData;

  StreamSubscription<LocationData>? locationSubscription;

  Future<bool> checkService() async {
    var status = await location.serviceEnabled();
    if (status) {
      return true;
    } else {
      status = await location.requestService();
      return status;
    }
  }

  Future<bool> initServiceAndLocationPermission() async {
    var status = await location.serviceEnabled();
    var permissionss = await handler.Permission.locationAlways.request();

    if (status && permissionss.isGranted) {
      logSuccess('Service and permission granted');

      return true;
    } else {
      await location.requestService();
      await Base.permissionHandlerService.requestLocationAlwaysPermission();
      return false;
    }
  }

  Future<void> getLocation() async {
    try {
      final locationResult = await location.getLocation();
      klog(locationResult);
    } on PlatformException catch (err) {
      klog(err.toString());
    }
  }

  initBackgroundMode() async {
    await location.enableBackgroundMode();
  }

  Future<bool> checkBackgroundMode() async {
    return await location.isBackgroundModeEnabled();
  }

  Future<void> listenLocation() async {
    location.enableBackgroundMode(enable: true);
    locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        klog(err.code);
      }
      locationSubscription?.cancel();
      locationSubscription = null;
    }).listen((currentLocation) {
      logSuccess(currentLocation);
      locationData = currentLocation;
    });
  }

  listenOnLocationChanged() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      logSuccess(currentLocation);
    });
  }

  Future<void> stopListen() async {
    await locationSubscription?.cancel();
    locationSubscription = null;
  }

  //Change the settings of the location
  changeSettings({
    LocationAccuracy? accuracy,
    int? interval,
    double? distanceFilter,
  }) {
    location.changeSettings(
      accuracy: accuracy,
      interval: interval,
      distanceFilter: distanceFilter,
    );
  }

  //Change the notification options
  changeNotificationOptions({
    String? channelName = 'Location background service',
    String? title = 'Location background service running',
    String? iconName = 'circle',
  }) {
    location.changeNotificationOptions(
      channelName: channelName,
      title: title,
      iconName: iconName,
    );
  }
}
