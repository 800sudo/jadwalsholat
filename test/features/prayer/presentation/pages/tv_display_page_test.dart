import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/theme/app_theme.dart';
import 'package:jadwal_sholat_tv/features/prayer/domain/entities/prayer_schedule.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/widgets/header_clock_widget.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/widgets/next_prayer_countdown_widget.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/widgets/prayer_time_cards_widget.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/widgets/running_text_widget.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

void main() {
  const testSettings = AppSettings(
    mosqueName: 'MASJID AGUNG NURUL IMAN',
    mosqueAddress: 'Pusat Dakwah & Ibadah Umat Islam',
    cityName: 'Jakarta',
    latitude: -6.2088,
    longitude: 106.8456,
    timezone: 7.0,
    ihtiyatMinutes: 2,
    runningText: 'Lurus dan rapatkan shaf saat sholat berjamaah',
    iqomahSubuhMinutes: 12,
    iqomahDzuhurMinutes: 10,
    iqomahAsharMinutes: 10,
    iqomahMaghribMinutes: 7,
    iqomahIsyaMinutes: 10,
    hijriAdjustmentDays: 0,
  );

  testWidgets(
    'HeaderClockWidget menampilkan nama masjid dan jam dengan benar',
    (tester) async {
      // Set resolusi TV 1080p Landscape (1920 x 1080)
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime(2026, 11, 6, 14, 30, 0);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: HeaderClockWidget(
              currentTime: now,
              settings: testSettings,
              onOpenSettings: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('MASJID AGUNG NURUL IMAN'), findsOneWidget);
      expect(find.textContaining('14:30'), findsOneWidget);
      expect(find.textContaining('Jakarta'), findsOneWidget);
    },
  );

  testWidgets('PrayerTimeCardsWidget menampilkan kartu sholat secara lengkap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final now = DateTime(2026, 11, 6, 14, 30, 0);
    final items = [
      PrayerItem(
        name: PrayerName.imsak,
        dateTime: now.copyWith(hour: 4, minute: 5),
      ),
      PrayerItem(
        name: PrayerName.subuh,
        dateTime: now.copyWith(hour: 4, minute: 15),
      ),
      PrayerItem(
        name: PrayerName.terbit,
        dateTime: now.copyWith(hour: 5, minute: 30),
      ),
      PrayerItem(
        name: PrayerName.dzuhur,
        dateTime: now.copyWith(hour: 11, minute: 45),
      ),
      PrayerItem(
        name: PrayerName.ashar,
        dateTime: now.copyWith(hour: 15, minute: 5),
      ),
      PrayerItem(
        name: PrayerName.maghrib,
        dateTime: now.copyWith(hour: 17, minute: 55),
      ),
      PrayerItem(
        name: PrayerName.isya,
        dateTime: now.copyWith(hour: 19, minute: 5),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: PrayerTimeCardsWidget(
            items: items,
            activePrayer: items[3], // Dzuhur
            nextPrayer: items[4], // Ashar
          ),
        ),
      ),
    );

    expect(find.text('SUBUH'), findsOneWidget);
    expect(find.text('DZUHUR'), findsOneWidget);
    expect(find.text('ASHAR'), findsOneWidget);
    expect(find.text('MAGHRIB'), findsOneWidget);
    expect(find.text('ISYA\''), findsOneWidget);
    expect(find.text('AKTIF'), findsOneWidget);
    expect(find.text('SELANJUTNYA'), findsOneWidget);
  });

  testWidgets(
    'NextPrayerCountdownWidget menampilkan countdown ke sholat berikutnya',
    (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final next = PrayerItem(
        name: PrayerName.ashar,
        dateTime: DateTime(2026, 11, 6, 15, 5, 0),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: NextPrayerCountdownWidget(
              nextPrayer: next,
              timeUntilNext: const Duration(hours: 1, minutes: 24, seconds: 15),
            ),
          ),
        ),
      );

      expect(find.text('SHOLAT BERIKUTNYA'), findsOneWidget);
      expect(find.text('ASHAR'), findsOneWidget);
      expect(find.text('01:24:15'), findsOneWidget);
    },
  );

  testWidgets('RunningTextWidget menampilkan teks berjalan', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: RunningTextWidget(text: 'Selamat Datang di Masjid Kami'),
        ),
      ),
    );

    expect(find.text('INFORMASI'), findsOneWidget);
    expect(find.textContaining('Selamat Datang di Masjid Kami'), findsWidgets);
  });
}
