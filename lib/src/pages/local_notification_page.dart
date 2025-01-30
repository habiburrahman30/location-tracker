import 'package:flutter/material.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

import '../components/notification_action_button.dart';
import '../services/notification/notifications_service.dart';

class LocalNotificationPage extends StatefulWidget {
  const LocalNotificationPage({super.key});

  @override
  State<LocalNotificationPage> createState() => _LocalNotificationPageState();
}

class _LocalNotificationPageState extends State<LocalNotificationPage> {
  final service = NotificationsServices();

  @override
  void initState() {
    requestExactAlarmPermission();
    super.initState();
  }

  Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      openAppSettings(); // Opens settings to manually enable permission
    }
    service.initializeNotification();
  }

  @override
  void dispose() {
    service.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notification'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NotificationButton(
              text: 'Send Notification',
              onPressed: () {
                service.showSimpleNotification(
                  title: 'This is notification title',
                  body: 'Hi i am habibur rahman ......',
                );
              },
            ),
            SizedBox(height: 5),
            NotificationButton(
              text: 'Notification With Actions',
              onPressed: () {
                service.showSimpleNotificationWithActions(
                  title: 'This is schedule notification title',
                  body: 'Hi i am habibur rahman ......',
                  payload: 'This is payload',
                );
              },
            ),
            SizedBox(height: 5),
            NotificationButton(
              text: 'Notification With BigImage',
              onPressed: () {
                service.sendNotificationWithBigImage(
                  id: 0,
                  title: 'Big image notification',
                  body:
                      'This is (big image & large icon) with payload notification',
                  usl:
                      'https://images.unsplash.com/photo-1737176424046-c0c755317477?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  payload: "This is payload",
                );
              },
            ),
            SizedBox(height: 5),
            NotificationButton(
              text: 'Periodically Notification',
              onPressed: () {
                service.showPeriodicallyNotification(
                  title: 'Periodically notification',
                  body: 'This is periodically notification',
                  payload: "This is payload",
                );
              },
            ),
            SizedBox(height: 5),
            NotificationButton(
              text: 'Schedule Notification',
              onPressed: () async {
                await requestExactAlarmPermission();

                service.showScheduleNotification(
                  title: 'Schedule notification',
                  body: 'This is schedule notification',
                  payload: "This is payload",
                );
              },
            ),
            SizedBox(height: 5),
            NotificationButton(
              text: 'Stop Notification',
              onPressed: () {
                // service.stopNotification()
              },
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
