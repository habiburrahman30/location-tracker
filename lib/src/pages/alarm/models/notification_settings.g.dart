// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettings _$NotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    NotificationSettings(
      title: json['title'] as String,
      body: json['body'] as String,
      stopButton: json['stopButton'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$NotificationSettingsToJson(
        NotificationSettings instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'stopButton': instance.stopButton,
      'icon': instance.icon,
    };
