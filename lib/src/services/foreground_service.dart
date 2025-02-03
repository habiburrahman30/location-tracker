import 'dart:async';
import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker/src/helpers/klog.dart';

class ForegroundService extends GetxService {
  void initForegroundService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
        playSound: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<ServiceRequestResult> startForegroundService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'stop', text: 'Stop'),
        ],
        notificationInitialRoute: '/second',
        callback: startCallback,
      );
    }
  }

  Future<ServiceRequestResult> stopForegroundService() {
    return FlutterForegroundTask.stopService();
  }

  Future<void> requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      // Use this utility only if you provide services that require long-term survival,
      // such as exact alarm service, healthcare service, or Bluetooth communication.
      //
      // This utility requires the "android.permission.SCHEDULE_EXACT_ALARM" permission.
      // Using this permission may make app distribution difficult due to Google policy.
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        // When you call this function, will be gone to the settings page.
        // So you need to explain to the user why set it.
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }
}

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  Timer? timer;
  int remainingTime = 0; // Time in seconds
  bool isRunning = false;
  DateTime? startTime;
  final int maxDuration = 9 * 3600; // 9 hours in seconds

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _calculateProgress() {
    return remainingTime / maxDuration;
  }

  String calculatePercentage() {
    double progress = _calculateProgress();
    return '${(progress * 100).toStringAsFixed(1)}%';
  }

  void startTimer() async {
    if (!isRunning) {
      isRunning = true;
      startTime = DateTime.now();

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime < maxDuration) {
          remainingTime++;
          foregroundTaskCallback();
        } else {
          stopTimer();
        }
      });
    }
  }

  void stopTimer() {
    if (isRunning) {
      isRunning = false;
      timer?.cancel();
    }
  }

  void resetTimer() {
    remainingTime = 0;
    startTime = null;
    ForegroundService().stopForegroundService();
    stopTimer();
  }

  void foregroundTaskCallback() {
    FlutterForegroundTask.updateService(
      notificationTitle: 'Timer Running',
      notificationText: 'Elapsed Time: ${formatTime(remainingTime)}',
    );
  }

  //-----------------Timer-----------------
  static const String incrementCountCommand = 'incrementCount';

  int _count = 0;

  void _incrementCount() {
    _count++;
    startTimer();
    final data = {
      'count': _count,
      'time': formatTime(remainingTime),
      'percentage': calculatePercentage(),
    };

    // Send data to main isolate.
    FlutterForegroundTask.sendDataToMain(data);
  }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    logSuccess(
        'onStart(starter: ${starter.name} timestamp: ${DateFormat('dd MMM yyyy -> hh:mm:ss a').format(timestamp)})');
    _incrementCount();
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    _incrementCount();
    klog(
        'onRepeatEvent: ${DateFormat('dd MMM yyyy -> hh:mm:ss a').format(DateTime.now())}');
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    logSuccess('onDestroy');
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    logSuccess('onReceiveData: $data');
    // if (data == incrementCountCommand) {
    //   _incrementCount();
    // }
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    logSuccess('onNotificationButtonPressed: $id');
    if (id == 'stop') {
      FlutterForegroundTask.stopService();
    }
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    logSuccess('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    logSuccess('onNotificationDismissed');
  }
}
