import 'dart:async';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' show placemarkFromCoordinates;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_tracker/src/helpers/klog.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

import '../base/base.dart';

class LocationTrackerController extends GetxController {
  Location location = Location();
  late LocationData locationData;
  StreamSubscription<LocationData>? locationSubscription;

  // late bool serviceEnabled;
  // late PermissionStatus permissionGranted;
  final isListening = RxBool(false);
  final isListening1 = RxBool(false);
  final latLngList1 = RxList<LatLng>();
  final latLngList = RxList<LatLng>();

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
    try {
      // Check if location services are enabled
      bool isServiceEnabled = await location.serviceEnabled();
      if (!isServiceEnabled) {
        // Request to enable location services
        isServiceEnabled = await location.requestService();
        if (!isServiceEnabled) {
          logError('Location service is not enabled');
          return false;
        }
      }

      // Request location permission (Always)
      final locationPermission =
          await handler.Permission.locationAlways.request();
      if (!locationPermission.isGranted) {
        logError('Location permission (Always) denied');
        await Base.permissionHandlerService.requestLocationAlwaysPermission();
        return false;
      }

      // Request notification permission
      final notificationPermission =
          await handler.Permission.notification.request();
      if (!notificationPermission.isGranted) {
        logError('Notification permission denied');
        await Base.permissionHandlerService.requestNotificationPermission();
        return false;
      }

      // If all permissions and services are granted/enabled
      logSuccess('All services and permissions granted');
      return true;
    } catch (e) {
      logError('Error in requesting permissions: $e');
      return false;
    }
  }

  Future<void> enableBackgroundMode() async {
    if (await location.hasPermission() == PermissionStatus.granted &&
        await location.serviceEnabled()) {
      logSuccess('Background mode enabled');
      await location.enableBackgroundMode(enable: true);
    } else {
      logError('Permissions not granted or location service not enabled.');
    }
  }

  Future<bool> checkBackgroundMode() async {
    return await location.isBackgroundModeEnabled();
  }

  Future<void> getLocation() async {
    try {
      final locationResult = await location.getLocation();
      klog(locationResult);
    } on PlatformException catch (err) {
      klog(err.toString());
    }
  }

  Future<void> listenLocation() async {
    changeNotificationOptions();
    // locationSubscription =
    //     location.onLocationChanged.handleError((dynamic err) {
    //   if (err is PlatformException) klog(err.code);

    //   locationSubscription?.cancel();
    //   locationSubscription = null;
    // }).listen((currentLocation) {
    //   logSuccess(currentLocation);
    //   locationData = currentLocation;
    // });
    isListening1.value = true;
    locationSubscription =
        location.onLocationChanged.listen((currentLocation) async {
      try {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          // Get address from coordinates
          final placemarks = await placemarkFromCoordinates(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          latLngList1.add(
              LatLng(currentLocation.latitude!, currentLocation.longitude!));
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            String address =
                "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
            logSuccess('Address: $address');
          }
        }
      } catch (e) {
        logError('Error getting address: $e');
      }
    }, onError: (err) {
      logError('Location error: $err');
      locationSubscription?.cancel();
      locationSubscription = null;
    });
  }

  listenOnLocationChanged() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      logSuccess(currentLocation);
      isListening.value = true;
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        locationData = currentLocation;
        latLngList
            .add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
      }
    });
  }

  Future<void> stopListen() async {
    isListening.value = false;
    isListening1.value = false;
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
    String? channelName = 'location_service',
    String? title = 'Location service',
    String? iconName = 'navigation_empty_icon',
  }) {
    location.changeNotificationOptions(
      channelName: channelName,
      title: title,
      subtitle: 'Sending location updates in the background',
      iconName: iconName,
      onTapBringToFront: true,
    );
  }
}
