import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:location_tracker/src/helpers/klog.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

import '../base/base.dart';

class LocationTrackerController extends GetxController {
  //Location section
  Location location = Location();
  late LocationData locationData;
  StreamSubscription<LocationData>? locationSubscription;

  // Google map section
  GoogleMapController? mapController;
  final mapType = Rx<MapType>(MapType.normal);
  final currentLocation = Rx<LatLng>(LatLng(23.7808405, 90.419689));

  final initialCameraPosition = Rx<CameraPosition>(CameraPosition(
    bearing: 0.0,
    target: LatLng(23.7808405, 90.419689),
    tilt: 0.0,
    zoom: 17.0,
  ));

  final isBackgroundModeEnabled = RxBool(false);

  final isListening = RxBool(false);
  final latLngList = RxList<LatLng>();
  final markerList = RxList<Marker>();

  Future<bool> checkService() async {
    var status = await location.serviceEnabled();
    if (status) {
      return true;
    } else {
      status = await location.requestService();
      return status;
    }
  }

  //init location listener
  Future<bool> initLocationListener({required bool isListening}) async {
    try {
      logError('Failed to enable background mode');
      // Ensure location permissions are granted
      if (!await initServiceAndLocationPermission(isListening: isListening)) {
        logError('Location permissions denied');
        return false;
      }

      // Ensure background mode is enabled
      if (isListening) {
        if (!await location.isBackgroundModeEnabled()) {
          if (!await location.enableBackgroundMode()) {
            logError('Failed to enable background mode');
            return false;
          }
        }
      }

      logSuccess('Background mode and permissions granted');
      return true;
    } on Exception catch (e) {
      logError('Error in background mode and permissions: $e');
      return false;
    }
  }

  Future<bool> initServiceAndLocationPermission(
      {required bool isListening}) async {
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

      // // Request location permission (Always)
      // final locationPermission =
      //     await handler.Permission.locationAlways.request();
      // if (!locationPermission.isGranted) {
      //   logError('Location permission (Always) denied');
      //   await Base.permissionHandlerService.requestLocationAlwaysPermission();
      //   return false;
      // }

      // Request location permission (Always)
      if (!await requestLocationPermission(isListening: isListening)) {
        logError('Location permission (Always) denied');
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

  Future<bool> requestLocationPermission({required bool isListening}) async {
    try {
      final permission = isListening
          ? await handler.Permission.locationAlways.request()
          : await handler.Permission.location.request();

      if (permission.isGranted) {
        logSuccess(
            'Location permission granted (${isListening ? 'Always' : 'When in use'})');
        return true;
      }

      logError(
          'Location permission (${isListening ? 'Always' : 'When in use'}) denied');

      // Request again based on permission type
      if (isListening) {
        await Base.permissionHandlerService.requestLocationAlwaysPermission();
      } else {
        await Base.permissionHandlerService.requestLocationPermission();
      }

      return false;
    } catch (e) {
      logError('Error requesting location permission: $e');
      return false;
    }
  }

  Future<void> checkBackgroundStatus() async {
    bool enabled = await toggleBackgroundMode();

    isBackgroundModeEnabled.value = enabled;
  }

  //Toggle background mode
  Future<bool> toggleBackgroundMode() async {
    try {
      bool isBackgroundEnabled = await location.isBackgroundModeEnabled();

      if (await requestLocationPermission(isListening: true)) {
        bool newState = !isBackgroundEnabled; // Toggle state
        await location.enableBackgroundMode(enable: newState);

        logSuccess('Background mode ${newState ? "enabled" : "disabled"}');
        return newState;
      } else {
        logError('Permissions not granted or location service not enabled.');
        return false;
      }
    } catch (e) {
      logError('Error toggling background mode: $e');
      return false;
    }
  }

  //Check background mode is enabled or not
  Future<bool> checkBackgroundMode() async {
    return await location.isBackgroundModeEnabled();
  }

  // Fatch current location
  Future<void> fetchLocationUpdates() async {
    location.getLocation().then((value) {
      logSuccess('Location: $value');
      currentLocation.value = LatLng(
        value.latitude!,
        value.longitude!,
      );
    });
  }

  //-------------------------------------
  // **** Start working with locationn stream ****
  //-------------------------------------
  Future<void> startWork() async {
    changeNotificationOptions();

    isListening.value = true;

    LatLng? latLng = LatLng(0.0, 0.0);

    locationSubscription = location.onLocationChanged.listen((data) async {
      try {
        if (data.latitude != null && data.longitude != null) {
          final distance = calculateDistance(
            latLng!.latitude,
            latLng!.longitude,
            data.latitude!,
            data.longitude!,
          );

          if (latLng!.latitude == 0.0 || distance > 100) {
            // Update only if distance is greater than 100 meters

            logSuccess('Listening Working location: $currentLocation');

            locationData = data;

            latLng = LatLng(data.latitude!, data.longitude!);
            latLngList.add(LatLng(data.latitude!, data.longitude!));

            // Get address from coordinates
            // final placemarks = await placemarkFromCoordinates(
            //   currentLocation.latitude!,
            //   currentLocation.longitude!,
            // );

            // if (placemarks.isNotEmpty) {
            //   final place = placemarks.first;
            //   address =
            //       "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
            //   logSuccess('Address: $address');
            // }

            // Add marker to the map
            markerList.add(
              Marker(
                markerId: MarkerId('current_location_${markerList.length}'),
                position: LatLng(data.latitude!, data.longitude!),
                infoWindow: InfoWindow(
                  title: 'Location 📍',
                  snippet:
                      "🕓 ${DateFormat('dd MMM, yyyy -> hh:mm:ss a').format(DateTime.now())}",
                  onTap: () {},
                ),
                onTap: () {},
              ),
            );

            //Update first and last marker icon
            if (markerList.isNotEmpty && markerList.length > 2) {
              // Update first marker
              markerList[0] = markerList[0].copyWith(
                iconParam: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              );

              // Update last marker
              markerList[markerList.length - 1] =
                  markerList[markerList.length - 1].copyWith(
                iconParam: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              );

              // Update all other markers without first and last
              for (int i = 1; i < markerList.length - 1; i++) {
                markerList[i] = markerList[i].copyWith(
                  iconParam: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                );
              }
            }
            if (markerList.length == 1) {
              // Update the map camera position
              mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(data.latitude!, data.longitude!),
                    zoom: 17,
                  ),
                ),
              );
            } else {
              // Update the map camera bounds
              mapController?.animateCamera(
                CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                    southwest: LatLng(
                      markerList.first.position.latitude,
                      markerList.first.position.longitude,
                    ),
                    northeast: LatLng(
                      markerList.last.position.latitude,
                      markerList.last.position.longitude,
                    ),
                  ),
                  100.0,
                ),
              );
            }
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

  /// Calculates the distance in meters between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radius of Earth in meters

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in meters
  }

  /// Converts degrees to radians
  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Future<void> stopListen() async {
    isListening.value = false;
    await locationSubscription?.cancel();
    locationSubscription = null;
  }

  //Change the settings of the location
  changeSettings({
    dynamic accuracy,
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

  //Get the last known location
  Future<void> getCurrentLocation() async {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation.value,
          zoom: 17,
        ),
      ),
    );
  }
}
