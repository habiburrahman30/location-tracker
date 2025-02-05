import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart' as alarm;
import 'package:flutter/material.dart';
import 'package:location_tracker/src/helpers/klog.dart';

import '../../services/permission.dart';
import 'edit_alarm.dart';

import 'models/alarm_settings.dart';
import 'models/notification_settings.dart';
import 'models/volume_settings.dart';
import 'ringing_page.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<AlarmSettings> alarms = [];
  static StreamSubscription? ringSubscription;
  static StreamSubscription? updateSubscription;

  @override
  void initState() {
    AlarmPermissions.checkNotificationPermission();
    if (alarm.Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }

    ringSubscription ??=
        alarm.Alarm.ringStream.stream.listen(ringingAlarmsChanged);

    // updateSubscription ??= alarm.Alarm.updateStream.stream.listen((data) {
    //   unawaited(loadAlarms());
    // });

    super.initState();
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadAlarms() async {
    final updatedAlarms = await alarm.Alarm.getAlarms();
    updatedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);

    for (var alarm in updatedAlarms) {
      final data = AlarmSettings(
        id: alarm.id,
        dateTime: alarm.dateTime,
        assetAudioPath: alarm.assetAudioPath,
        loopAudio: alarm.loopAudio,
        vibrate: alarm.vibrate,
        // volume: alarm.volume,
        // fadeDuration: alarm.fadeDuration,
        warningNotificationOnKill: alarm.warningNotificationOnKill,
        androidFullScreenIntent: alarm.androidFullScreenIntent,
        notificationSettings: NotificationSettings(
          title: alarm.notificationSettings.title,
          body: alarm.notificationSettings.body,
          stopButton: alarm.notificationSettings.stopButton,
          icon: alarm.notificationSettings.icon,
        ),
        volumeSettings: VolumeSettings(
          volume: alarm.volume,
          volumeEnforced: alarm.volumeEnforced,
        ),
      );

      alarms.add(data);
      // setState(() {});
    }
  }

  Future<void> ringingAlarmsChanged(alarms) async {
    if (alarms == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => RingingPage(alarmSettings: alarms),
      ),
    );
    unawaited(loadAlarms());
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: AlarmEditPage(alarmSettings: settings),
        );
      },
    );

    if (res != null && res == true) unawaited(loadAlarms());
  }

  final alarmSettings = alarm.AlarmSettings(
    id: 42,
    dateTime: DateTime.now().add(const Duration(minutes: 1)),
    assetAudioPath: 'assets/audio/star_wars.mp3',
    loopAudio: true,
    vibrate: true,
    volume: 0.8,
    fadeDuration: 3.0,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    notificationSettings: const alarm.NotificationSettings(
      title: 'This is the title',
      body: 'This is the body',
      stopButton: 'Stop',
      icon: 'notification_icon',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await alarm.Alarm.set(alarmSettings: alarmSettings);
              },
              child: Text('Alarm'),
            ),
            ElevatedButton(
              onPressed: () async {
                await alarm.Alarm.stopAll();
              },
              child: Text('Stop All'),
            ),
            alarms.isNotEmpty
                ? ListView.separated(
                    itemCount: alarms.length,
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListTile(
                          title: Text(
                            TimeOfDay(
                              hour: alarms[index].dateTime.hour,
                              minute: alarms[index].dateTime.minute,
                            ).format(context),
                          ),
                          onTap: () => navigateToAlarmScreen(alarms[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              alarm.Alarm.stop(alarms[index].id)
                                  .then((_) => loadAlarms());
                            },
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No alarms set',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAlarmScreen(null),
        child: Icon(Icons.alarm_add_rounded, size: 33),
      ),
    );
  }
}
