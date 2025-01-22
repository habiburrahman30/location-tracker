import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location_tracker/src/helpers/route.dart';

import '../components/permission_required_dialog_component.dart';

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
      permitionRequiredDialog(Get.context!);
      return false;
    }
    return false; // Default to false
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
    return await requestPermission(Permission.locationAlways);
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
    return await requestPermission(Permission.notification);
  }

  /// Request access to sensors
  Future<bool> requestSensorsPermission() async {
    return await requestPermission(Permission.sensors);
  }

  /// Request access to audio (useful for playback or audio recording)
  Future<bool> requestAudioPermission() async {
    return await requestPermission(Permission.audio);
  }

  /// Request access to location (GPS, network, etc.)
  permitionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PermissionRequiredDialog(
          title: "Permission required",
          content:
              "It seems you permanently declined location permission. You can go to the app settings to grant it.",
          onGrantPermission: () async {
            await openAppSettings();
            back();
          },
        );
      },
    );
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Needed'),
        content: Text(
          'Location access is required to use this feature. Please enable location permissions in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              back();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
