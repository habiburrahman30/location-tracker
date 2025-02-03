import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker/src/helpers/klog.dart';

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  //-------------  Timer Section  ------------------
  Timer? timer;
  int remainingTime = 0; // Time in seconds
  bool isRunning = false;
  DateTime? startTime;
  final int maxDuration = 9 * 3600; // 9 hours in seconds

  //-------------  Location Section  ------------------
  // Location location = Location();
  // late LocationData locationData;
  // StreamSubscription<LocationData>? locationSubscription;

  //=================END===================

  void startTimer() async {
    if (!isRunning) {
      // Request permissions before starting the timer
      // await requestPermissions();

      isRunning = true;
      startTime = DateTime.now();

      // _startForegroundTask();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingTime < maxDuration) {
          remainingTime++;
          foregroundTaskCallback(); // Update notification

          final data = {
            'startTime': DateFormat('hh:mm:ss a').format(startTime!),
            'remainingTime': formatTime(remainingTime),
            'progress': calculateProgress(),
            'percentage': calculatePercentage(),
          };

          FlutterForegroundTask.sendDataToMain(data);
        } else {
          stopTimer();
        }
      });
    }
  }

  void foregroundTaskCallback() {
    FlutterForegroundTask.updateService(
      notificationTitle: 'Timer Running $_count',
      notificationText:
          'Started at: (${DateFormat('hh:mm:ss a').format(startTime!)}) Elapsed Time: (${formatTime(remainingTime)}) Progress: (${calculatePercentage()})',
    );
  }

  void stopForegroundTask() async {
    await FlutterForegroundTask.stopService();
  }

  void stopTimer() {
    if (isRunning) {
      isRunning = false;

      timer?.cancel();
      stopForegroundTask();
    }
  }

  void resetTimer() {
    remainingTime = 0;
    startTime = null;

    stopTimer();
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double calculateProgress() {
    return remainingTime / maxDuration;
  }

  String calculatePercentage() {
    double progress = calculateProgress();
    return '${(progress * 100).toStringAsFixed(1)}%';
  }

  //-------------  TaskHandler  -------------

  static const String incrementCountCommand = 'incrementCount';

  int _count = 0;

  void _incrementCount() {
    _count++;

    // Update notification content.
    // FlutterForegroundTask.updateService(
    //   notificationTitle: 'Hello MyTaskHandler :)',
    //   notificationText: 'count: $_count',
    // );

    // Send data to main isolate.
    // FlutterForegroundTask.sendDataToMain(_count);
  }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    klog('onStart(starter: ${starter.name})');
    _incrementCount();
    startTimer();
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    _incrementCount();
    startTimer();
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    klog('onDestroy');
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    klog('onReceiveData: $data');
    if (data == incrementCountCommand) {
      _incrementCount();
    }
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    klog('onNotificationButtonPressed: $id');

    if (id == 'stop_work') {
      stopTimer();
    }
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    klog('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    klog('onNotificationDismissed');
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<StatefulWidget> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool isOfficeMode = true;
  final ValueNotifier<Map?> _taskDataListenable = ValueNotifier(null);

  Future<void> _requestPermissions() async {
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

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
        priority: NotificationPriority.HIGH,
        channelImportance: NotificationChannelImportance.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<ServiceRequestResult> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'stop_work', text: 'Stop Work'),
        ],
        notificationInitialRoute: '/second',
        callback: startCallback,
      );
    }
  }

  Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }

  void _onReceiveTaskData(Object data) {
    klog('onReceiveTaskData: $data');
    _taskDataListenable.value = data as Map;
  }

  void incrementCount() {
    FlutterForegroundTask.sendDataToTask(MyTaskHandler.incrementCountCommand);
  }

  @override
  void initState() {
    super.initState();
    // Add a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request permissions and initialize the service.
      _requestPermissions();
      _initService();
    });
  }

  @override
  void dispose() {
    // Remove a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    _taskDataListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendance"),
          centerTitle: true,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {},
          // ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
            ),
          ],
        ),
        // body: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: ValueListenableBuilder(
        //       valueListenable: _taskDataListenable,
        //       builder: (context, data, _) {
        //         return Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Container(
        //               padding: const EdgeInsets.symmetric(
        //                   vertical: 8, horizontal: 16),
        //               decoration: BoxDecoration(
        //                 color: Colors.blue.shade100,
        //                 borderRadius: BorderRadius.circular(12),
        //               ),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text("Choose your remote mode"),
        //                   ToggleButtons(
        //                     isSelected: [!isOfficeMode, isOfficeMode],
        //                     borderRadius: BorderRadius.circular(12),
        //                     onPressed: (index) {
        //                       setState(() {
        //                         isOfficeMode = index == 1;
        //                       });
        //                     },
        //                     children: const [
        //                       Padding(
        //                         padding: EdgeInsets.symmetric(horizontal: 16),
        //                         child: Row(
        //                           children: [
        //                             Icon(Icons.home),
        //                             SizedBox(width: 5),
        //                             Text("Home"),
        //                           ],
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: EdgeInsets.symmetric(horizontal: 16),
        //                         child: Row(
        //                           children: [
        //                             Icon(Icons.business),
        //                             SizedBox(width: 5),
        //                             Text("Office"),
        //                           ],
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             const SizedBox(height: 20),
        //             Text(
        //               "AM 00 : 13 : 48",
        //               style:
        //                   TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        //             ),
        //             Text(
        //               "Sunday, February 2, 2025",
        //               style:
        //                   TextStyle(fontSize: 18, color: Colors.grey.shade700),
        //             ),
        //             const SizedBox(height: 20),
        //             GestureDetector(
        //               onTap: () async {
        //                 if (await FlutterForegroundTask.isRunningService) {
        //                   stopService();
        //                 } else {
        //                   startService();
        //                 }
        //               },
        //               child: Container(
        //                 width: 150,
        //                 height: 150,
        //                 decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   color: Colors.blue,
        //                 ),
        //                 child: const Center(
        //                   child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       Icon(Icons.touch_app_rounded,
        //                           size: 50, color: Colors.white),
        //                       SizedBox(height: 5),
        //                       Text("Check In",
        //                           style: TextStyle(color: Colors.white)),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(height: 20),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: [
        //                 Column(
        //                   children: [
        //                     Icon(Icons.access_time, color: Colors.blue),
        //                     Text(data.isNotEmpty
        //                         ? "${data['startTime']}"
        //                         : "--:--"),
        //                     Text("Check In"),
        //                   ],
        //                 ),
        //                 Column(
        //                   children: [
        //                     Icon(Icons.access_time, color: Colors.blue),
        //                     Text("--:--"),
        //                     Text("Check Out"),
        //                   ],
        //                 ),
        //                 Column(
        //                   children: [
        //                     Icon(Icons.update, color: Colors.blue),
        //                     Text(data != null
        //                         ? "${data['remainingTime']}"
        //                         : "--:--"),
        //                     Text("Working Hr's"),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //             const SizedBox(height: 20),
        //             Align(
        //               alignment: Alignment.centerLeft,
        //               child: Text(
        //                 "Daily Report",
        //                 style: TextStyle(
        //                     fontSize: 18, fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             const SizedBox(height: 10),
        //             Container(
        //               padding: EdgeInsets.all(12),
        //               decoration: BoxDecoration(
        //                 color: Colors.grey.shade200,
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text("Office", style: TextStyle(fontSize: 16)),
        //                   Text("IN",
        //                       style: TextStyle(fontWeight: FontWeight.bold)),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         );
        //       }),
        // ),

        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: ValueListenableBuilder(
                  valueListenable: _taskDataListenable,
                  builder: (context, data, _) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'You received data from TaskHandler:',
                            style: TextStyle(fontSize: 18),
                          ),
                          // Text(
                          //   '$data',
                          // ),
                          SizedBox(height: 20),
                          if (data != null)
                            Card(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(Icons.access_time,
                                                color: Colors.blue),
                                            Text(
                                              data != null
                                                  ? "${data['startTime']}"
                                                  : "--:--",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("Check In"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.access_time,
                                                color: Colors.blue),
                                            Text(
                                              "--:--",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("Check Out"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.update,
                                                color: Colors.blue),
                                            Text(
                                              data != null
                                                  ? "${data['remainingTime']}"
                                                  : "--:--",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("Working Hr's"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      // width: 300,
                                      // height: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Stack(
                                          children: [
                                            LinearProgressIndicator(
                                              // value: 0.003271604938271605,
                                              value: data['progress'],
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                              backgroundColor: Colors.grey[300],
                                              semanticsLabel:
                                                  'Linear progress indicator',
                                              minHeight: 15,
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "${data['percentage']}",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: startService,
                      child: Text('Start'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: stopService,
                      child: Text('Stop'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
