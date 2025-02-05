import 'package:location_tracker/src/helpers/klog.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissions {
  static Future<void> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      logInfo('Requesting notification permission...');
      final res = await Permission.notification.request();
      logInfo(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  static Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      logInfo('Requesting external storage permission...');
      final res = await Permission.storage.request();
      logInfo(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  static Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    logInfo('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      logInfo('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      logInfo(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }
}
