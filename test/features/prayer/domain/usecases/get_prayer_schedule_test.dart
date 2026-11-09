import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/features/prayer/data/datasources/prayer_local_datasource.dart';
import 'package:jadwal_sholat_tv/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:jadwal_sholat_tv/features/prayer/domain/entities/prayer_schedule.dart';
import 'package:jadwal_sholat_tv/features/prayer/domain/usecases/get_prayer_schedule.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

void main() {
  late GetPrayerSchedule useCase;
  late AppSettings testSettings;

  setUp(() {
    final ds = PrayerLocalDataSourceImpl();
    final repo = PrayerRepositoryImpl(localDataSource: ds);
    useCase = GetPrayerSchedule(repo);

    testSettings = const AppSettings(
      mosqueName: 'Masjid Agung',
      mosqueAddress: 'Pusat Kota',
      cityName: 'Jakarta',
      latitude: -6.2088,
      longitude: 106.8456,
      timezone: 7.0,
      ihtiyatMinutes: 2,
      runningText: 'Pengumuman',
      iqomahSubuhMinutes: 12,
      iqomahDzuhurMinutes: 10,
      iqomahAsharMinutes: 10,
      iqomahMaghribMinutes: 7,
      iqomahIsyaMinutes: 10,
      hijriAdjustmentDays: 0,
    );
  });

  test('menghasilkan jadwal sholat lengkap 7 waktu', () {
    final now = DateTime(2026, 11, 6, 10, 0, 0); // Jam 10:00 pagi
    final schedule = useCase(currentTime: now, settings: testSettings);

    expect(schedule.items.length, equals(7));
    expect(schedule.nextPrayer, isNotNull);
    expect(schedule.nextPrayer!.name, equals(PrayerName.dzuhur));
    expect(schedule.timeUntilNext.inMinutes, greaterThan(0));
  });

  test('menentukan sholat berikutnya ke Subuh esok hari jika setelah Isya', () {
    final lateNight = DateTime(2026, 11, 6, 23, 30, 0); // Jam 23:30 malam
    final schedule = useCase(currentTime: lateNight, settings: testSettings);

    expect(schedule.nextPrayer, isNotNull);
    expect(schedule.nextPrayer!.name, equals(PrayerName.subuh));
    expect(schedule.nextPrayer!.dateTime.day, equals(7)); // Hari berikutnya
  });
}
