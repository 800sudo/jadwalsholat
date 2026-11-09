import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

import '../entities/prayer_schedule.dart';

abstract class PrayerRepository {
  PrayerSchedule calculateSchedule({
    required DateTime currentTime,
    required AppSettings settings,
  });
}
