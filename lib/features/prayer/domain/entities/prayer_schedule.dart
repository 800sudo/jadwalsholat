import 'package:equatable/equatable.dart';

enum PrayerName {
  imsak('Imsak', 'إمساك'),
  subuh('Subuh', 'الصبح'),
  terbit('Terbit', 'الشروق'),
  dzuhur('Dzuhur', 'الظهر'),
  ashar('Ashar', 'العصر'),
  maghrib('Maghrib', 'المغرب'),
  isya('Isya\'', 'العشاء');

  final String label;
  final String arabic;

  const PrayerName(this.label, this.arabic);
}

enum TVDisplayMode {
  normal, // Tampilan standar Smart TV
  adzanAlert, // Masuk waktu sholat / Adzan berkumandang
  iqomahCountdown, // Hitung mundur Iqomah (menit & detik besar)
  prayingTime, // Waktu sholat berjamaah (Lurus & rapatkan shaf)
  khutbah, // Standby Khutbah Jumat (Layar Tenang & Matikan HP)
}

class PrayerItem extends Equatable {
  final PrayerName name;
  final DateTime dateTime;
  final bool isNext;
  final bool isActive;
  final String? customLabel;
  final String? customArabic;

  const PrayerItem({
    required this.name,
    required this.dateTime,
    this.isNext = false,
    this.isActive = false,
    this.customLabel,
    this.customArabic,
  });

  String get label => customLabel ?? name.label;
  String get arabic => customArabic ?? name.arabic;

  PrayerItem copyWith({
    bool? isNext,
    bool? isActive,
    String? customLabel,
    String? customArabic,
  }) {
    return PrayerItem(
      name: name,
      dateTime: dateTime,
      isNext: isNext ?? this.isNext,
      isActive: isActive ?? this.isActive,
      customLabel: customLabel ?? this.customLabel,
      customArabic: customArabic ?? this.customArabic,
    );
  }

  @override
  List<Object?> get props => [
    name,
    dateTime,
    isNext,
    isActive,
    customLabel,
    customArabic,
  ];
}

class PrayerSchedule extends Equatable {
  final DateTime date;
  final List<PrayerItem> items;
  final PrayerItem? nextPrayer;
  final PrayerItem? activePrayer;
  final Duration timeUntilNext;
  final TVDisplayMode displayMode;
  final Duration iqomahRemaining;

  const PrayerSchedule({
    required this.date,
    required this.items,
    this.nextPrayer,
    this.activePrayer,
    this.timeUntilNext = Duration.zero,
    this.displayMode = TVDisplayMode.normal,
    this.iqomahRemaining = Duration.zero,
  });

  PrayerSchedule copyWith({
    DateTime? date,
    List<PrayerItem>? items,
    PrayerItem? nextPrayer,
    PrayerItem? activePrayer,
    Duration? timeUntilNext,
    TVDisplayMode? displayMode,
    Duration? iqomahRemaining,
  }) {
    return PrayerSchedule(
      date: date ?? this.date,
      items: items ?? this.items,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      activePrayer: activePrayer ?? this.activePrayer,
      timeUntilNext: timeUntilNext ?? this.timeUntilNext,
      displayMode: displayMode ?? this.displayMode,
      iqomahRemaining: iqomahRemaining ?? this.iqomahRemaining,
    );
  }

  @override
  List<Object?> get props => [
    date,
    items,
    nextPrayer,
    activePrayer,
    timeUntilNext,
    displayMode,
    iqomahRemaining,
  ];
}
