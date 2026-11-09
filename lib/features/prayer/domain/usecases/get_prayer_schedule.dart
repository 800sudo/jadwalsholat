import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

import '../entities/prayer_schedule.dart';
import '../repositories/prayer_repository.dart';

class GetPrayerSchedule {
  final PrayerRepository repository;

  GetPrayerSchedule(this.repository);

  PrayerSchedule call({
    required DateTime currentTime,
    required AppSettings settings,
  }) {
    return repository.calculateSchedule(
      currentTime: currentTime,
      settings: settings,
    );
  }
}
