import 'package:equatable/equatable.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

abstract class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object?> get props => [];
}

class InitPrayerScheduleEvent extends PrayerEvent {
  final AppSettings settings;

  const InitPrayerScheduleEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

class PrayerTickEvent extends PrayerEvent {
  final DateTime currentTime;

  const PrayerTickEvent(this.currentTime);

  @override
  List<Object?> get props => [currentTime];
}

class SettingsChangedEvent extends PrayerEvent {
  final AppSettings settings;

  const SettingsChangedEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}
