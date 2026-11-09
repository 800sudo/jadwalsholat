import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/app_settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettingsModel> getSettings();
  Future<void> saveSettings(AppSettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<AppSettingsModel> getSettings() async {
    List<Map<String, String>> slides = AppConstants.defaultSlides;
    final slidesJson = sharedPreferences.getString(AppConstants.keySlides);
    if (slidesJson != null && slidesJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(slidesJson);
        if (decoded is List) {
          slides = decoded.map((item) {
            if (item is Map) {
              return item.map((k, v) => MapEntry(k.toString(), v.toString()));
            }
            return <String, String>{};
          }).toList();
        }
      } catch (_) {
        slides = AppConstants.defaultSlides;
      }
    }

    return AppSettingsModel(
      mosqueName:
          sharedPreferences.getString(AppConstants.keyMosqueName) ??
          AppConstants.defaultMosqueName,
      mosqueAddress:
          sharedPreferences.getString(AppConstants.keyMosqueAddress) ??
          AppConstants.defaultMosqueAddress,
      cityName:
          sharedPreferences.getString(AppConstants.keyCityName) ??
          AppConstants.defaultCityName,
      latitude:
          sharedPreferences.getDouble(AppConstants.keyLatitude) ??
          AppConstants.defaultLatitude,
      longitude:
          sharedPreferences.getDouble(AppConstants.keyLongitude) ??
          AppConstants.defaultLongitude,
      timezone:
          sharedPreferences.getDouble(AppConstants.keyTimezone) ??
          AppConstants.defaultTimezone,
      ihtiyatMinutes:
          sharedPreferences.getInt(AppConstants.keyIhtiyatMinutes) ??
          AppConstants.defaultIhtiyatMinutes,
      runningText:
          sharedPreferences.getString(AppConstants.keyRunningText) ??
          AppConstants.defaultRunningText,
      iqomahSubuhMinutes:
          sharedPreferences.getInt(AppConstants.keyIqomahSubuh) ??
          AppConstants.defaultIqomahSubuhMinutes,
      iqomahDzuhurMinutes:
          sharedPreferences.getInt(AppConstants.keyIqomahDzuhur) ??
          AppConstants.defaultIqomahDzuhurMinutes,
      iqomahAsharMinutes:
          sharedPreferences.getInt(AppConstants.keyIqomahAshar) ??
          AppConstants.defaultIqomahAsharMinutes,
      iqomahMaghribMinutes:
          sharedPreferences.getInt(AppConstants.keyIqomahMaghrib) ??
          AppConstants.defaultIqomahMaghribMinutes,
      iqomahIsyaMinutes:
          sharedPreferences.getInt(AppConstants.keyIqomahIsya) ??
          AppConstants.defaultIqomahIsyaMinutes,
      hijriAdjustmentDays:
          sharedPreferences.getInt(AppConstants.keyHijriAdjustment) ?? 0,
      slides: slides,
      fridayKhutbahMinutes:
          sharedPreferences.getInt(AppConstants.keyFridayKhutbahMinutes) ??
          AppConstants.defaultFridayKhutbahMinutes,
      disableFridayIqomah:
          sharedPreferences.getBool(AppConstants.keyDisableFridayIqomah) ??
          AppConstants.defaultDisableFridayIqomah,
      fridayKhotib:
          sharedPreferences.getString(AppConstants.keyFridayKhotib) ??
          AppConstants.defaultFridayKhotib,
      fridayImam:
          sharedPreferences.getString(AppConstants.keyFridayImam) ??
          AppConstants.defaultFridayImam,
      fridayMuadzin:
          sharedPreferences.getString(AppConstants.keyFridayMuadzin) ??
          AppConstants.defaultFridayMuadzin,
      fridayBilal:
          sharedPreferences.getString(AppConstants.keyFridayBilal) ??
          AppConstants.defaultFridayBilal,
      enableBeepSound:
          sharedPreferences.getBool(AppConstants.keyEnableBeepSound) ??
          AppConstants.defaultEnableBeepSound,
    );
  }

  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    await sharedPreferences.setString(
      AppConstants.keyMosqueName,
      settings.mosqueName,
    );
    await sharedPreferences.setString(
      AppConstants.keyMosqueAddress,
      settings.mosqueAddress,
    );
    await sharedPreferences.setString(
      AppConstants.keyCityName,
      settings.cityName,
    );
    await sharedPreferences.setDouble(
      AppConstants.keyLatitude,
      settings.latitude,
    );
    await sharedPreferences.setDouble(
      AppConstants.keyLongitude,
      settings.longitude,
    );
    await sharedPreferences.setDouble(
      AppConstants.keyTimezone,
      settings.timezone,
    );
    await sharedPreferences.setInt(
      AppConstants.keyIhtiyatMinutes,
      settings.ihtiyatMinutes,
    );
    await sharedPreferences.setString(
      AppConstants.keyRunningText,
      settings.runningText,
    );
    await sharedPreferences.setInt(
      AppConstants.keyIqomahSubuh,
      settings.iqomahSubuhMinutes,
    );
    await sharedPreferences.setInt(
      AppConstants.keyIqomahDzuhur,
      settings.iqomahDzuhurMinutes,
    );
    await sharedPreferences.setInt(
      AppConstants.keyIqomahAshar,
      settings.iqomahAsharMinutes,
    );
    await sharedPreferences.setInt(
      AppConstants.keyIqomahMaghrib,
      settings.iqomahMaghribMinutes,
    );
    await sharedPreferences.setInt(
      AppConstants.keyIqomahIsya,
      settings.iqomahIsyaMinutes,
    );
    await sharedPreferences.setInt(
      AppConstants.keyHijriAdjustment,
      settings.hijriAdjustmentDays,
    );
    await sharedPreferences.setString(
      AppConstants.keySlides,
      jsonEncode(settings.slides),
    );
    await sharedPreferences.setInt(
      AppConstants.keyFridayKhutbahMinutes,
      settings.fridayKhutbahMinutes,
    );
    await sharedPreferences.setBool(
      AppConstants.keyDisableFridayIqomah,
      settings.disableFridayIqomah,
    );
    await sharedPreferences.setString(
      AppConstants.keyFridayKhotib,
      settings.fridayKhotib,
    );
    await sharedPreferences.setString(
      AppConstants.keyFridayImam,
      settings.fridayImam,
    );
    await sharedPreferences.setString(
      AppConstants.keyFridayMuadzin,
      settings.fridayMuadzin,
    );
    await sharedPreferences.setString(
      AppConstants.keyFridayBilal,
      settings.fridayBilal,
    );
    await sharedPreferences.setBool(
      AppConstants.keyEnableBeepSound,
      settings.enableBeepSound,
    );
  }
}
