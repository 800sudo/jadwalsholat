import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.mosqueName,
    required super.mosqueAddress,
    required super.cityName,
    required super.latitude,
    required super.longitude,
    required super.timezone,
    required super.ihtiyatMinutes,
    required super.runningText,
    required super.iqomahSubuhMinutes,
    required super.iqomahDzuhurMinutes,
    required super.iqomahAsharMinutes,
    required super.iqomahMaghribMinutes,
    required super.iqomahIsyaMinutes,
    required super.hijriAdjustmentDays,
    super.slides = const [],
    super.fridayKhutbahMinutes = 40,
    super.disableFridayIqomah = true,
    super.fridayKhotib = 'Ustadz Ahmad Fauzi, M.Ag.',
    super.fridayImam = 'Ustadz Muhammad Ridwan, Al-Hafizh',
    super.fridayMuadzin = 'Ust. Hasan Basri',
    super.fridayBilal = 'Ust. Bilal Ramadhan',
    super.enableBeepSound = true,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> parsedSlides = [];
    if (json['slides'] != null && json['slides'] is List) {
      parsedSlides = (json['slides'] as List).map((item) {
        if (item is Map) {
          return item.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          );
        }
        return <String, String>{};
      }).toList();
    }

    return AppSettingsModel(
      mosqueName: json['mosqueName'] as String,
      mosqueAddress: json['mosqueAddress'] as String,
      cityName: json['cityName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: (json['timezone'] as num).toDouble(),
      ihtiyatMinutes: json['ihtiyatMinutes'] as int,
      runningText: json['runningText'] as String,
      iqomahSubuhMinutes: json['iqomahSubuhMinutes'] as int,
      iqomahDzuhurMinutes: json['iqomahDzuhurMinutes'] as int,
      iqomahAsharMinutes: json['iqomahAsharMinutes'] as int,
      iqomahMaghribMinutes: json['iqomahMaghribMinutes'] as int,
      iqomahIsyaMinutes: json['iqomahIsyaMinutes'] as int,
      hijriAdjustmentDays: json['hijriAdjustmentDays'] as int,
      slides: parsedSlides,
      fridayKhutbahMinutes: json['fridayKhutbahMinutes'] as int? ?? 40,
      disableFridayIqomah: json['disableFridayIqomah'] as bool? ?? true,
      fridayKhotib:
          json['fridayKhotib'] as String? ?? 'Ustadz Ahmad Fauzi, M.Ag.',
      fridayImam:
          json['fridayImam'] as String? ?? 'Ustadz Muhammad Ridwan, Al-Hafizh',
      fridayMuadzin: json['fridayMuadzin'] as String? ?? 'Ust. Hasan Basri',
      fridayBilal: json['fridayBilal'] as String? ?? 'Ust. Bilal Ramadhan',
      enableBeepSound: json['enableBeepSound'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mosqueName': mosqueName,
      'mosqueAddress': mosqueAddress,
      'cityName': cityName,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'ihtiyatMinutes': ihtiyatMinutes,
      'runningText': runningText,
      'iqomahSubuhMinutes': iqomahSubuhMinutes,
      'iqomahDzuhurMinutes': iqomahDzuhurMinutes,
      'iqomahAsharMinutes': iqomahAsharMinutes,
      'iqomahMaghribMinutes': iqomahMaghribMinutes,
      'iqomahIsyaMinutes': iqomahIsyaMinutes,
      'hijriAdjustmentDays': hijriAdjustmentDays,
      'slides': slides,
      'fridayKhutbahMinutes': fridayKhutbahMinutes,
      'disableFridayIqomah': disableFridayIqomah,
      'fridayKhotib': fridayKhotib,
      'fridayImam': fridayImam,
      'fridayMuadzin': fridayMuadzin,
      'fridayBilal': fridayBilal,
      'enableBeepSound': enableBeepSound,
    };
  }

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      mosqueName: entity.mosqueName,
      mosqueAddress: entity.mosqueAddress,
      cityName: entity.cityName,
      latitude: entity.latitude,
      longitude: entity.longitude,
      timezone: entity.timezone,
      ihtiyatMinutes: entity.ihtiyatMinutes,
      runningText: entity.runningText,
      iqomahSubuhMinutes: entity.iqomahSubuhMinutes,
      iqomahDzuhurMinutes: entity.iqomahDzuhurMinutes,
      iqomahAsharMinutes: entity.iqomahAsharMinutes,
      iqomahMaghribMinutes: entity.iqomahMaghribMinutes,
      iqomahIsyaMinutes: entity.iqomahIsyaMinutes,
      hijriAdjustmentDays: entity.hijriAdjustmentDays,
      slides: entity.slides,
      fridayKhutbahMinutes: entity.fridayKhutbahMinutes,
      disableFridayIqomah: entity.disableFridayIqomah,
      fridayKhotib: entity.fridayKhotib,
      fridayImam: entity.fridayImam,
      fridayMuadzin: entity.fridayMuadzin,
      fridayBilal: entity.fridayBilal,
      enableBeepSound: entity.enableBeepSound,
    );
  }
}
