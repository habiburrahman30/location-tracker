// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmSettings _$AlarmSettingsFromJson(Map<String, dynamic> json) =>
    AlarmSettings(
      id: (json['id'] as num).toInt(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      assetAudioPath: json['assetAudioPath'] as String,
      volumeSettings: VolumeSettings.fromJson(
          json['volumeSettings'] as Map<String, dynamic>),
      notificationSettings: NotificationSettings.fromJson(
          json['notificationSettings'] as Map<String, dynamic>),
      loopAudio: json['loopAudio'] as bool? ?? true,
      vibrate: json['vibrate'] as bool? ?? true,
      warningNotificationOnKill:
          json['warningNotificationOnKill'] as bool? ?? true,
      androidFullScreenIntent: json['androidFullScreenIntent'] as bool? ?? true,
      allowAlarmOverlap: json['allowAlarmOverlap'] as bool? ?? false,
      iOSBackgroundAudio: json['iOSBackgroundAudio'] as bool? ?? true,
      payload: json['payload'] as String?,
    );

Map<String, dynamic> _$AlarmSettingsToJson(AlarmSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime.toIso8601String(),
      'assetAudioPath': instance.assetAudioPath,
      'volumeSettings': instance.volumeSettings,
      'notificationSettings': instance.notificationSettings,
      'loopAudio': instance.loopAudio,
      'vibrate': instance.vibrate,
      'warningNotificationOnKill': instance.warningNotificationOnKill,
      'androidFullScreenIntent': instance.androidFullScreenIntent,
      'allowAlarmOverlap': instance.allowAlarmOverlap,
      'iOSBackgroundAudio': instance.iOSBackgroundAudio,
      'payload': instance.payload,
    };
