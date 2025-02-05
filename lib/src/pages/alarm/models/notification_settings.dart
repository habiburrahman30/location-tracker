import 'package:json_annotation/json_annotation.dart';

part 'notification_settings.g.dart';

@JsonSerializable()
class NotificationSettings {
  final String title;
  final String body;
  final String? stopButton;
  final String? icon;

  NotificationSettings({
    required this.title,
    required this.body,
    this.stopButton,
    this.icon,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
}
