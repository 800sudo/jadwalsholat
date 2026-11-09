import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/features/prayer/data/datasources/prayer_local_datasource.dart';
import 'package:jadwal_sholat_tv/features/prayer/domain/entities/prayer_schedule.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/widgets/iqomah_overlay_widget.dart';
import 'package:jadwal_sholat_tv/features/settings/data/models/app_settings_model.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

void main() {
  group('Pengaturan & Fitur Hari Jum\'at Tests', () {
    late PrayerLocalDataSourceImpl dataSource;
    late AppSettings testSettings;

    setUp(() {
      dataSource = PrayerLocalDataSourceImpl();
      testSettings = const AppSettings(
        mosqueName: 'Masjid Raya Al-Muhajirin',
        mosqueAddress: 'Jl. Merdeka No. 1',
        cityName: 'Jakarta',
        latitude: -6.2088,
        longitude: 106.8456,
        timezone: 7.0,
        ihtiyatMinutes: 2,
        runningText: 'Selamat Datang',
        iqomahSubuhMinutes: 12,
        iqomahDzuhurMinutes: 10,
        iqomahAsharMinutes: 10,
        iqomahMaghribMinutes: 7,
        iqomahIsyaMinutes: 10,
        hijriAdjustmentDays: 0,
        fridayKhutbahMinutes: 35,
        disableFridayIqomah: true,
        fridayKhotib: 'Dr. KH. Abdullah Syakir, MA',
        fridayImam: 'Ustadz Zulkifli, SQ',
        fridayMuadzin: 'Ust. Bilal Ramadhan',
        fridayBilal: 'Ust. Hasan',
      );
    });

    test('Deteksi otomatis Hari Jum\'at: label Dzuhur berganti menjadi Jum\'at & الجمعة', () {
      // 2026-11-06 adalah hari Jum'at (Friday)
      final fridayTime = DateTime(2026, 11, 6, 9, 0, 0);
      expect(fridayTime.weekday, equals(DateTime.friday));

      final schedule = dataSource.calculateSchedule(
        currentTime: fridayTime,
        settings: testSettings,
      );

      final dzuhurOrJumat = schedule.items.firstWhere(
        (item) => item.name == PrayerName.dzuhur,
      );

      expect(dzuhurOrJumat.label, equals('Jum\'at'));
      expect(dzuhurOrJumat.arabic, equals('الجمعة'));
    });

    test('Hari biasa (Kamis): label Dzuhur tetap "Dzuhur" & "الظهر"', () {
      // 2026-11-05 adalah hari Kamis (Thursday)
      final thursdayTime = DateTime(2026, 11, 5, 9, 0, 0);
      expect(thursdayTime.weekday, equals(DateTime.thursday));

      final schedule = dataSource.calculateSchedule(
        currentTime: thursdayTime,
        settings: testSettings,
      );

      final dzuhur = schedule.items.firstWhere(
        (item) => item.name == PrayerName.dzuhur,
      );

      expect(dzuhur.label, equals('Dzuhur'));
      expect(dzuhur.arabic, equals('الظهر'));
    });

    test('Hari Jum\'at saat adzan selesai & disableFridayIqomah aktif: masuk TVDisplayMode.khutbah', () {
      final fridayTime = DateTime(2026, 11, 6, 9, 0, 0);
      final initialSchedule = dataSource.calculateSchedule(
        currentTime: fridayTime,
        settings: testSettings,
      );

      final dzuhurTime = initialSchedule.items
          .firstWhere((item) => item.name == PrayerName.dzuhur)
          .dateTime;

      // 5 menit setelah waktu sholat masuk (adzan selesai, khutbah sedang berlangsung)
      final duringKhutbahTime = dzuhurTime.add(const Duration(minutes: 5));

      final activeSchedule = dataSource.calculateSchedule(
        currentTime: duringKhutbahTime,
        settings: testSettings,
      );

      expect(activeSchedule.displayMode, equals(TVDisplayMode.khutbah));
      expect(activeSchedule.activePrayer?.label, equals('Jum\'at'));
      expect(activeSchedule.iqomahRemaining.inMinutes, greaterThan(0));
    });

    test('Hari Jum\'at jika disableFridayIqomah dinonaktifkan (false): masuk TVDisplayMode.iqomahCountdown', () {
      final fridayTime = DateTime(2026, 11, 6, 9, 0, 0);
      final initialSchedule = dataSource.calculateSchedule(
        currentTime: fridayTime,
        settings: testSettings,
      );

      final dzuhurTime = initialSchedule.items
          .firstWhere((item) => item.name == PrayerName.dzuhur)
          .dateTime;

      // 3 menit setelah adzan (dalam rentang iqomah Dzuhur normal)
      final duringIqomahTime = dzuhurTime.add(const Duration(minutes: 4));

      final normalIqomahSettings = testSettings.copyWith(
        disableFridayIqomah: false,
      );

      final activeSchedule = dataSource.calculateSchedule(
        currentTime: duringIqomahTime,
        settings: normalIqomahSettings,
      );

      expect(activeSchedule.displayMode, equals(TVDisplayMode.iqomahCountdown));
    });

    test(
      'AppSettingsModel serializes and deserializes Friday settings correctly',
      () {
        final model = AppSettingsModel.fromEntity(testSettings);
        final json = model.toJson();
        final fromJson = AppSettingsModel.fromJson(json);

        expect(fromJson.fridayKhutbahMinutes, equals(35));
        expect(fromJson.disableFridayIqomah, isTrue);
        expect(fromJson.fridayKhotib, equals('Dr. KH. Abdullah Syakir, MA'));
        expect(fromJson.fridayImam, equals('Ustadz Zulkifli, SQ'));
        expect(fromJson.fridayMuadzin, equals('Ust. Bilal Ramadhan'));
        expect(fromJson.fridayBilal, equals('Ust. Hasan'));
      },
    );

    testWidgets(
      'IqomahOverlayWidget menampilkan layar standby khutbah dan nama petugas Jum\'at',
      (tester) async {
        final fridayPrayer = PrayerItem(
          name: PrayerName.dzuhur,
          dateTime: DateTime(2026, 11, 6, 11, 45),
          customLabel: 'Jum\'at',
          customArabic: 'الجمعة',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IqomahOverlayWidget(
                displayMode: TVDisplayMode.khutbah,
                activePrayer: fridayPrayer,
                iqomahRemaining: const Duration(minutes: 30),
                settings: testSettings,
              ),
            ),
          ),
        );

        expect(find.text('KHUTBAH JUM\'AT BERLANGSUNG'), findsOneWidget);
        expect(find.text('HARAP TENANG & DENGARKAN KHUTBAH'), findsOneWidget);
        expect(find.text('Dr. KH. Abdullah Syakir, MA'), findsOneWidget);
        expect(find.text('Ustadz Zulkifli, SQ'), findsOneWidget);
        expect(find.text('Ust. Bilal Ramadhan'), findsOneWidget);
        expect(find.text('Ust. Hasan'), findsOneWidget);
        expect(
          find.textContaining('NONAKTIFKAN NADA DERING HANDPHONE'),
          findsOneWidget,
        );
      },
    );
  });
}
