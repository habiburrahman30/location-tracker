import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/src/helpers/route.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  /// Request permission for a specific feature
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();

    if (status.isGranted) {
      return true; // Permission granted
    } else if (status.isDenied) {
      return false; // Permission denied, but not permanently
    } else if (status.isPermanentlyDenied) {
      // await openAppSettings(); // Open settings if permanently denied
      locationAlwaysPermitionRequiredDialog(Get.context!);
      return false;
    }
    return false; // Default to false
  }

  Future<void> requestPermissions() async {
    if (await Permission.location.isDenied ||
        await Permission.locationWhenInUse.isDenied ||
        await Permission.locationAlways.isDenied) {
      await [
        Permission.location,
        Permission.locationAlways,
        Permission.notification, // Needed for foreground service notification
      ].request();
    }
  }

  /// Check if permission is already granted
  Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    return await requestPermission(Permission.location);
  }

  /// Request location always permission
  Future<bool> requestLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();

    if (status.isGranted) {
      return true; // Permission granted
    } else if (status.isPermanentlyDenied || status.isDenied) {
      locationAlwaysPermitionRequiredDialog(Get.context!);
      return false;
    }
    return false; // Default to false
  }

  /// Request SMS permission
  Future<bool> requestSmsPermission() async {
    return await requestPermission(Permission.sms);
  }

  /// Request photo/gallery permission
  Future<bool> requestPhotoPermission() async {
    return await requestPermission(Permission.photos);
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  /// Request video permissions (camera + microphone)
  Future<bool> requestVideoPermissions() async {
    bool cameraGranted = await requestPermission(Permission.camera);
    bool microphoneGranted = await requestPermission(Permission.microphone);

    if (cameraGranted && microphoneGranted) {
      return true; // Both permissions are granted
    }
    return false; // Either or both permissions are denied
  }

  /// Request Bluetooth permission (for scanning/connecting devices)
  Future<bool> requestBluetoothPermission() async {
    return await requestPermission(Permission.bluetooth);
  }

  /// Request Bluetooth scan permission (specific for Android 12+)
  Future<bool> requestBluetoothScanPermission() async {
    return await requestPermission(Permission.bluetoothScan);
  }

  /// Request Bluetooth connect permission (specific for Android 12+)
  Future<bool> requestBluetoothConnectPermission() async {
    return await requestPermission(Permission.bluetoothConnect);
  }

  /// Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    return await requestPermission(Permission.microphone);
  }

  /// Request contacts permission
  Future<bool> requestContactsPermission() async {
    return await requestPermission(Permission.contacts);
  }

  /// Request storage permission (useful for accessing files)
  Future<bool> requestStoragePermission() async {
    return await requestPermission(Permission.storage);
  }

  /// Request calendar permission
  Future<bool> requestCalendarPermission() async {
    return await requestPermission(Permission.calendarFullAccess);
  }

  /// Request phone permission (for call logs, dialing, etc.)
  Future<bool> requestPhonePermission() async {
    return await requestPermission(Permission.phone);
  }

  /// Request notifications permission (for push notifications)
  Future<bool> requestNotificationPermission() async {
    // return await requestPermission(Permission.notification);
    final status = await Permission.notification.request();

    if (status.isGranted) {
      return true; // Permission granted
    } else if (status.isPermanentlyDenied || status.isDenied) {
      notificationPermitionRequiredDialog(Get.context!);
      return false;
    }
    return false;
  }

  /// Request access to sensors
  Future<bool> requestSensorsPermission() async {
    return await requestPermission(Permission.sensors);
  }

  /// Request access to audio (useful for playback or audio recording)
  Future<bool> requestAudioPermission() async {
    return await requestPermission(Permission.audio);
  }

  notificationPermitionRequiredDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Permission Required"),
            content: RichText(
              text: const TextSpan(
                text:
                    "Notification permission is required to provide timely updates and alerts. "
                    "Please enable it in the app settings by navigating to:\n\n",
                style: TextStyle(
                    color: Colors.black87, fontSize: 16), // Default style
                children: [
                  TextSpan(
                    text: "Settings > App Permissions > Notifications\n\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "and allow notifications to ensure you receive important updates.",
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Redirect to app settings
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
            ],
          );
        });
  }

  locationAlwaysPermitionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content: RichText(
            text: const TextSpan(
              text:
                  "Location permission is required to provide location-based services. "
                  "Please enable it in the app settings by navigating to:\n\n",
              style: TextStyle(
                  color: Colors.black87, fontSize: 16), // Default style
              children: [
                TextSpan(
                  text: "Settings > App Permissions > Location\n\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "and select ",
                ),
                TextSpan(
                  text: "\"Allow all the time\"",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " for uninterrupted access to your location.",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Redirect to app settings
                back();
                await openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }
}
