import 'package:jadwal_sholat_tv/core/utils/astronomical_calculator.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

import '../../domain/entities/prayer_schedule.dart';
import '../models/prayer_schedule_model.dart';

abstract class PrayerLocalDataSource {
  PrayerScheduleModel calculateSchedule({
    required DateTime currentTime,
    required AppSettings settings,
  });
}

class PrayerLocalDataSourceImpl implements PrayerLocalDataSource {
  @override
  PrayerScheduleModel calculateSchedule({
    required DateTime currentTime,
    required AppSettings settings,
  }) {
    // 1. Kalkulasi jadwal hari ini
    final todayResult = AstronomicalCalculator.calculate(
      date: currentTime,
      latitude: settings.latitude,
      longitude: settings.longitude,
      timezone: settings.timezone,
      ihtiyatMinutes: settings.ihtiyatMinutes,
    );

    // 2. Kalkulasi jadwal esok hari (untuk antisipasi setelah waktu Isya lewat)
    final tomorrow = currentTime.add(const Duration(days: 1));
    final tomorrowResult = AstronomicalCalculator.calculate(
      date: tomorrow,
      latitude: settings.latitude,
      longitude: settings.longitude,
      timezone: settings.timezone,
      ihtiyatMinutes: settings.ihtiyatMinutes,
    );

    final isTodayFriday = currentTime.weekday == DateTime.friday;

    final List<PrayerItem> rawItems = [
      PrayerItem(name: PrayerName.imsak, dateTime: todayResult.imsak),
      PrayerItem(name: PrayerName.subuh, dateTime: todayResult.subuh),
      PrayerItem(name: PrayerName.terbit, dateTime: todayResult.terbit),
      PrayerItem(
        name: PrayerName.dzuhur,
        dateTime: todayResult.dzuhur,
        customLabel: isTodayFriday ? 'Jum\'at' : null,
        customArabic: isTodayFriday ? 'الجمعة' : null,
      ),
      PrayerItem(name: PrayerName.ashar, dateTime: todayResult.ashar),
      PrayerItem(name: PrayerName.maghrib, dateTime: todayResult.maghrib),
      PrayerItem(name: PrayerName.isya, dateTime: todayResult.isya),
    ];

    // 3. Tentukan Next Prayer & Time Until Next
    PrayerItem? nextPrayer;
    Duration timeUntilNext = Duration.zero;

    // Filter sholat wajib yang memiliki countdown
    final mainPrayers = [
      rawItems[1], // Subuh
      rawItems[3], // Dzuhur
      rawItems[4], // Ashar
      rawItems[5], // Maghrib
      rawItems[6], // Isya
    ];

    for (final prayer in mainPrayers) {
      if (currentTime.isBefore(prayer.dateTime)) {
        nextPrayer = prayer;
        timeUntilNext = prayer.dateTime.difference(currentTime);
        break;
      }
    }

    // Jika semua sholat hari ini telah lewat, sholat berikutnya adalah Subuh besok
    if (nextPrayer == null) {
      nextPrayer = PrayerItem(
        name: PrayerName.subuh,
        dateTime: tomorrowResult.subuh,
        isNext: true,
      );
      timeUntilNext = tomorrowResult.subuh.difference(currentTime);
    }

    // 4. Tentukan Sholat yang Sedang Aktif
    PrayerItem? activePrayer;
    if (currentTime.isAfter(todayResult.subuh) &&
        currentTime.isBefore(todayResult.terbit)) {
      activePrayer = rawItems[1]; // Subuh
    } else if (currentTime.isAfter(todayResult.terbit) &&
        currentTime.isBefore(todayResult.dzuhur)) {
      activePrayer = rawItems[2]; // Terbit / Dhuha
    } else if (currentTime.isAfter(todayResult.dzuhur) &&
        currentTime.isBefore(todayResult.ashar)) {
      activePrayer = rawItems[3]; // Dzuhur
    } else if (currentTime.isAfter(todayResult.ashar) &&
        currentTime.isBefore(todayResult.maghrib)) {
      activePrayer = rawItems[4]; // Ashar
    } else if (currentTime.isAfter(todayResult.maghrib) &&
        currentTime.isBefore(todayResult.isya)) {
      activePrayer = rawItems[5]; // Maghrib
    } else if (currentTime.isAfter(todayResult.isya) ||
        currentTime.isBefore(todayResult.subuh)) {
      activePrayer = rawItems[6]; // Isya
    }

    // Tandai status pada item list
    final updatedItems = rawItems.map((item) {
      final isNext =
          nextPrayer?.name == item.name &&
          nextPrayer?.dateTime.day == item.dateTime.day;
      final isActive = activePrayer?.name == item.name;
      return item.copyWith(isNext: isNext, isActive: isActive);
    }).toList();

    // 5. Tentukan Status Tampilan Smart TV (Normal, Adzan, Iqomah, atau Sholat)
    TVDisplayMode displayMode = TVDisplayMode.normal;
    Duration iqomahRemaining = Duration.zero;

    // Cek masing-masing 5 waktu sholat fardhu
    final prayerConfigs = [
      {'prayer': rawItems[1], 'iqomah': settings.iqomahSubuhMinutes},
      {'prayer': rawItems[3], 'iqomah': settings.iqomahDzuhurMinutes},
      {'prayer': rawItems[4], 'iqomah': settings.iqomahAsharMinutes},
      {'prayer': rawItems[5], 'iqomah': settings.iqomahMaghribMinutes},
      {'prayer': rawItems[6], 'iqomah': settings.iqomahIsyaMinutes},
    ];

    const int adzanAlertMinutes = 2; // Durasi banner adzan
    const int prayingDurationMinutes = 12; // Durasi layar sholat

    for (final config in prayerConfigs) {
      final prayer = config['prayer'] as PrayerItem;
      final iqomahMin = config['iqomah'] as int;

      final isFridayDzuhur =
          prayer.name == PrayerName.dzuhur &&
          prayer.dateTime.weekday == DateTime.friday;

      if (isFridayDzuhur && settings.disableFridayIqomah) {
        final adzanEnd = prayer.dateTime.add(
          const Duration(minutes: adzanAlertMinutes),
        );
        final khutbahEnd = adzanEnd.add(
          Duration(minutes: settings.fridayKhutbahMinutes),
        );
        final prayingEnd = khutbahEnd.add(
          const Duration(minutes: prayingDurationMinutes),
        );

        if (currentTime.isAfter(prayer.dateTime) &&
            currentTime.isBefore(adzanEnd)) {
          displayMode = TVDisplayMode.adzanAlert;
          activePrayer = prayer;
          break;
        } else if (currentTime.isAfter(adzanEnd) &&
            currentTime.isBefore(khutbahEnd)) {
          displayMode = TVDisplayMode.khutbah;
          iqomahRemaining = khutbahEnd.difference(currentTime);
          activePrayer = prayer;
          break;
        } else if (currentTime.isAfter(khutbahEnd) &&
            currentTime.isBefore(prayingEnd)) {
          displayMode = TVDisplayMode.prayingTime;
          activePrayer = prayer;
          break;
        }
      } else {
        final adzanEnd = prayer.dateTime.add(
          const Duration(minutes: adzanAlertMinutes),
        );
        final iqomahEnd = adzanEnd.add(Duration(minutes: iqomahMin));
        final prayingEnd = iqomahEnd.add(
          const Duration(minutes: prayingDurationMinutes),
        );

        if (currentTime.isAfter(prayer.dateTime) &&
            currentTime.isBefore(adzanEnd)) {
          displayMode = TVDisplayMode.adzanAlert;
          activePrayer = prayer;
          break;
        } else if (currentTime.isAfter(adzanEnd) &&
            currentTime.isBefore(iqomahEnd)) {
          displayMode = TVDisplayMode.iqomahCountdown;
          iqomahRemaining = iqomahEnd.difference(currentTime);
          activePrayer = prayer;
          break;
        } else if (currentTime.isAfter(iqomahEnd) &&
            currentTime.isBefore(prayingEnd)) {
          displayMode = TVDisplayMode.prayingTime;
          activePrayer = prayer;
          break;
        }
      }
    }

    return PrayerScheduleModel(
      date: currentTime,
      items: updatedItems,
      nextPrayer: nextPrayer,
      activePrayer: activePrayer,
      timeUntilNext: timeUntilNext,
      displayMode: displayMode,
      iqomahRemaining: iqomahRemaining,
    );
  }
}
