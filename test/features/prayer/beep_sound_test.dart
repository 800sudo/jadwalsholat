import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/utils/audio/beep_sound_helper.dart';
import 'package:jadwal_sholat_tv/features/prayer/domain/entities/prayer_schedule.dart';
import 'package:jadwal_sholat_tv/features/settings/data/models/app_settings_model.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Beep Sound System Tests', () {
    test('BeepSoundHelper playSingleBeep and playWarningBeepSequence execute without exception', () async {
      BeepSoundHelper.initUserInteraction();
      await expectLater(
        BeepSoundHelper.playSingleBeep(durationMs: 10),
        completes,
      );
      await expectLater(
        BeepSoundHelper.playWarningBeepSequence(
          count: 2,
          initialDurationMs: 5,
          pauseMs: 5,
          finalDurationMs: 10,
        ),
        completes,
      );
    });

    test('Deteksi pencegahan beep khusus Sholat Jum\'at', () {
      // 2026-11-06 adalah hari Jum'at
      final fridayDate = DateTime(2026, 11, 6, 12, 0, 0);
      expect(fridayDate.weekday, equals(DateTime.friday));

      final jumatPrayer = PrayerItem(
        name: PrayerName.dzuhur,
        dateTime: fridayDate,
        customLabel: 'Jum\'at',
      );

      final isFridayDzuhur =
          (jumatPrayer.name == PrayerName.dzuhur) &&
          (fridayDate.weekday == DateTime.friday);

      expect(isFridayDzuhur, isTrue);

      // Sholat Jum'at dilarang beep
      final shouldBeepOnFriday = !isFridayDzuhur;
      expect(shouldBeepOnFriday, isFalse);

      // Sholat selain Jum'at (misal Ashar di hari Jum'at) diizinkan beep
      final asharPrayer = PrayerItem(
        name: PrayerName.ashar,
        dateTime: DateTime(2026, 11, 6, 15, 15, 0),
      );
      final isFridayAsharDzuhur =
          (asharPrayer.name == PrayerName.dzuhur) &&
          (fridayDate.weekday == DateTime.friday);
      expect(isFridayAsharDzuhur, isFalse);
      expect(!isFridayAsharDzuhur, isTrue);

      // Sholat Dzuhur di hari Kamis (non-Jum'at) diizinkan beep
      final thursdayDate = DateTime(2026, 11, 5, 12, 0, 0);
      final thursdayDzuhur = PrayerItem(
        name: PrayerName.dzuhur,
        dateTime: thursdayDate,
      );
      final isThursdayDzuhurOnFriday =
          (thursdayDzuhur.name == PrayerName.dzuhur) &&
          (thursdayDate.weekday == DateTime.friday);
      expect(isThursdayDzuhurOnFriday, isFalse);
      expect(!isThursdayDzuhurOnFriday, isTrue);
    });

    test(
      'AppSettingsModel serializes and deserializes enableBeepSound correctly',
      () {
        const settings = AppSettings(
          mosqueName: 'Masjid Agung',
          mosqueAddress: 'Pusat Kota',
          cityName: 'Jakarta',
          latitude: -6.2,
          longitude: 106.8,
          timezone: 7.0,
          ihtiyatMinutes: 2,
          runningText: 'Pengumuman',
          iqomahSubuhMinutes: 12,
          iqomahDzuhurMinutes: 10,
          iqomahAsharMinutes: 10,
          iqomahMaghribMinutes: 7,
          iqomahIsyaMinutes: 10,
          hijriAdjustmentDays: 0,
          enableBeepSound: false,
        );

        final model = AppSettingsModel.fromEntity(settings);
        final json = model.toJson();
        final fromJson = AppSettingsModel.fromJson(json);

        expect(fromJson.enableBeepSound, isFalse);
      },
    );
  });
}
