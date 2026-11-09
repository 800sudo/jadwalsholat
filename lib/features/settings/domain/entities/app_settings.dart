import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String mosqueName;
  final String mosqueAddress;
  final String cityName;
  final double latitude;
  final double longitude;
  final double timezone;
  final int ihtiyatMinutes;
  final String runningText;
  final int iqomahSubuhMinutes;
  final int iqomahDzuhurMinutes;
  final int iqomahAsharMinutes;
  final int iqomahMaghribMinutes;
  final int iqomahIsyaMinutes;
  final int hijriAdjustmentDays;
  final List<Map<String, String>> slides;
  final int fridayKhutbahMinutes;
  final bool disableFridayIqomah;
  final String fridayKhotib;
  final String fridayImam;
  final String fridayMuadzin;
  final String fridayBilal;
  final bool enableBeepSound;

  const AppSettings({
    required this.mosqueName,
    required this.mosqueAddress,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.ihtiyatMinutes,
    required this.runningText,
    required this.iqomahSubuhMinutes,
    required this.iqomahDzuhurMinutes,
    required this.iqomahAsharMinutes,
    required this.iqomahMaghribMinutes,
    required this.iqomahIsyaMinutes,
    required this.hijriAdjustmentDays,
    this.slides = const [],
    this.fridayKhutbahMinutes = 40,
    this.disableFridayIqomah = true,
    this.fridayKhotib = 'Ustadz Ahmad Fauzi, M.Ag.',
    this.fridayImam = 'Ustadz Muhammad Ridwan, Al-Hafizh',
    this.fridayMuadzin = 'Ust. Hasan Basri',
    this.fridayBilal = 'Ust. Bilal Ramadhan',
    this.enableBeepSound = true,
  });

  AppSettings copyWith({
    String? mosqueName,
    String? mosqueAddress,
    String? cityName,
    double? latitude,
    double? longitude,
    double? timezone,
    int? ihtiyatMinutes,
    String? runningText,
    int? iqomahSubuhMinutes,
    int? iqomahDzuhurMinutes,
    int? iqomahAsharMinutes,
    int? iqomahMaghribMinutes,
    int? iqomahIsyaMinutes,
    int? hijriAdjustmentDays,
    List<Map<String, String>>? slides,
    int? fridayKhutbahMinutes,
    bool? disableFridayIqomah,
    String? fridayKhotib,
    String? fridayImam,
    String? fridayMuadzin,
    String? fridayBilal,
    bool? enableBeepSound,
  }) {
    return AppSettings(
      mosqueName: mosqueName ?? this.mosqueName,
      mosqueAddress: mosqueAddress ?? this.mosqueAddress,
      cityName: cityName ?? this.cityName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      ihtiyatMinutes: ihtiyatMinutes ?? this.ihtiyatMinutes,
      runningText: runningText ?? this.runningText,
      iqomahSubuhMinutes: iqomahSubuhMinutes ?? this.iqomahSubuhMinutes,
      iqomahDzuhurMinutes: iqomahDzuhurMinutes ?? this.iqomahDzuhurMinutes,
      iqomahAsharMinutes: iqomahAsharMinutes ?? this.iqomahAsharMinutes,
      iqomahMaghribMinutes: iqomahMaghribMinutes ?? this.iqomahMaghribMinutes,
      iqomahIsyaMinutes: iqomahIsyaMinutes ?? this.iqomahIsyaMinutes,
      hijriAdjustmentDays: hijriAdjustmentDays ?? this.hijriAdjustmentDays,
      slides: slides ?? this.slides,
      fridayKhutbahMinutes: fridayKhutbahMinutes ?? this.fridayKhutbahMinutes,
      disableFridayIqomah: disableFridayIqomah ?? this.disableFridayIqomah,
      fridayKhotib: fridayKhotib ?? this.fridayKhotib,
      fridayImam: fridayImam ?? this.fridayImam,
      fridayMuadzin: fridayMuadzin ?? this.fridayMuadzin,
      fridayBilal: fridayBilal ?? this.fridayBilal,
      enableBeepSound: enableBeepSound ?? this.enableBeepSound,
    );
  }

  @override
  List<Object?> get props => [
    mosqueName,
    mosqueAddress,
    cityName,
    latitude,
    longitude,
    timezone,
    ihtiyatMinutes,
    runningText,
    iqomahSubuhMinutes,
    iqomahDzuhurMinutes,
    iqomahAsharMinutes,
    iqomahMaghribMinutes,
    iqomahIsyaMinutes,
    hijriAdjustmentDays,
    slides,
    fridayKhutbahMinutes,
    disableFridayIqomah,
    fridayKhotib,
    fridayImam,
    fridayMuadzin,
    fridayBilal,
    enableBeepSound,
  ];
}
