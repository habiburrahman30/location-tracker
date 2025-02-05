import 'package:json_annotation/json_annotation.dart';

import 'notification_settings.dart';
import 'volume_settings.dart';

part 'alarm_settings.g.dart';

@JsonSerializable()
class AlarmSettings {
  final int id;
  final DateTime dateTime;
  final String assetAudioPath;
  final VolumeSettings volumeSettings;
  final NotificationSettings notificationSettings;
  final bool loopAudio;
  final bool vibrate;
  final bool warningNotificationOnKill;
  final bool androidFullScreenIntent;
  final bool allowAlarmOverlap;
  final bool iOSBackgroundAudio;
  final String? payload;

  AlarmSettings({
    required this.id,
    required this.dateTime,
    required this.assetAudioPath,
    required this.volumeSettings,
    required this.notificationSettings,
    this.loopAudio = true,
    this.vibrate = true,
    this.warningNotificationOnKill = true,
    this.androidFullScreenIntent = true,
    this.allowAlarmOverlap = false,
    this.iOSBackgroundAudio = true,
    this.payload,
  });

  factory AlarmSettings.fromJson(Map<String, dynamic> json) =>
      _$AlarmSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmSettingsToJson(this);
}
