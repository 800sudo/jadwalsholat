import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

import '../../domain/entities/prayer_schedule.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_local_datasource.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerLocalDataSource localDataSource;

  PrayerRepositoryImpl({required this.localDataSource});

  @override
  PrayerSchedule calculateSchedule({
    required DateTime currentTime,
    required AppSettings settings,
  }) {
    return localDataSource.calculateSchedule(
      currentTime: currentTime,
      settings: settings,
    );
  }
}
