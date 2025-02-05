import 'package:json_annotation/json_annotation.dart';

part 'volume_settings.g.dart';

@JsonSerializable()
class VolumeSettings {
  final double? volume;
  final Duration? fadeDuration;
  final List<VolumeFadeStep> fadeSteps;
  final bool volumeEnforced;

  VolumeSettings({
    this.volume,
    this.fadeDuration,
    this.fadeSteps = const [],
    this.volumeEnforced = false,
  });

  factory VolumeSettings.fromJson(Map<String, dynamic> json) =>
      _$VolumeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeSettingsToJson(this);

  VolumeSettings.fixed({
    double? volume,
    bool volumeEnforced = false,
  }) : this(
          volume: volume,
          volumeEnforced: volumeEnforced,
        );

  VolumeSettings.fade({
    required Duration fadeDuration,
    double? volume,
    bool volumeEnforced = false,
  }) : this(
          volume: volume,
          fadeDuration: fadeDuration,
          volumeEnforced: volumeEnforced,
        );

  factory VolumeSettings.staircaseFade({
    required List<VolumeFadeStep> fadeSteps,
    double? volume,
    bool volumeEnforced = false,
  }) {
    assert(fadeSteps.isNotEmpty, 'fadeSteps must not be empty');
    return VolumeSettings(
      volume: volume,
      fadeSteps: fadeSteps,
      volumeEnforced: volumeEnforced,
    );
  }
}

@JsonSerializable()
class VolumeFadeStep {
  final Duration? time;
  final double? volume;

  VolumeFadeStep({
    this.time,
    this.volume,
  });

  factory VolumeFadeStep.fromJson(Map<String, dynamic> json) =>
      _$VolumeFadeStepFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeFadeStepToJson(this);
}
