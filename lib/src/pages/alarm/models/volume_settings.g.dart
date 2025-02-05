// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolumeSettings _$VolumeSettingsFromJson(Map<String, dynamic> json) =>
    VolumeSettings(
      volume: (json['volume'] as num?)?.toDouble(),
      fadeDuration: json['fadeDuration'] == null
          ? null
          : Duration(microseconds: (json['fadeDuration'] as num).toInt()),
      fadeSteps: (json['fadeSteps'] as List<dynamic>?)
              ?.map((e) => VolumeFadeStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      volumeEnforced: json['volumeEnforced'] as bool? ?? false,
    );

Map<String, dynamic> _$VolumeSettingsToJson(VolumeSettings instance) =>
    <String, dynamic>{
      'volume': instance.volume,
      'fadeDuration': instance.fadeDuration?.inMicroseconds,
      'fadeSteps': instance.fadeSteps,
      'volumeEnforced': instance.volumeEnforced,
    };

VolumeFadeStep _$VolumeFadeStepFromJson(Map<String, dynamic> json) =>
    VolumeFadeStep(
      time: json['time'] == null
          ? null
          : Duration(microseconds: (json['time'] as num).toInt()),
      volume: (json['volume'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VolumeFadeStepToJson(VolumeFadeStep instance) =>
    <String, dynamic>{
      'time': instance.time?.inMicroseconds,
      'volume': instance.volume,
    };
