import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/utils/config/config_transfer_helper.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

void main() {
  group('ConfigTransferHelper Tests', () {
    const testSettings = AppSettings(
      mosqueName: 'Masjid Raya Al-Muhajirin',
      mosqueAddress: 'Jl. Pemuda No. 45, Indramayu',
      cityName: 'Indramayu',
      latitude: -6.3275,
      longitude: 108.3249,
      timezone: 7.0,
      ihtiyatMinutes: 3,
      runningText: 'Selamat datang jamaah sholat berjamaah.',
      iqomahSubuhMinutes: 15,
      iqomahDzuhurMinutes: 12,
      iqomahAsharMinutes: 10,
      iqomahMaghribMinutes: 8,
      iqomahIsyaMinutes: 11,
      hijriAdjustmentDays: 1,
      slides: [
        {
          'title': 'Kajian Subuh',
          'subtitle': 'Setiap Ahad Pagi bersama Ustadz Fulan',
          'badge': 'AGENDA',
        },
      ],
      fridayKhutbahMinutes: 45,
      disableFridayIqomah: true,
      fridayKhotib: 'Dr. KH. Abdullah Syakir',
      fridayImam: 'Ust. Zulkifli Al-Hafizh',
      fridayMuadzin: 'Ust. Bilal',
      fridayBilal: 'Ust. Salman',
      enableBeepSound: true,
    );

    test('exportToJson and importFromJson round-trip preserving all fields', () {
      final jsonString = ConfigTransferHelper.exportToJson(testSettings);
      expect(jsonString, isNotEmpty);
      expect(jsonString.contains('Masjid Raya Al-Muhajirin'), isTrue);

      final imported = ConfigTransferHelper.importFromJson(jsonString);
      expect(imported, isNotNull);
      expect(imported!.mosqueName, equals(testSettings.mosqueName));
      expect(imported.mosqueAddress, equals(testSettings.mosqueAddress));
      expect(imported.cityName, equals(testSettings.cityName));
      expect(imported.latitude, equals(testSettings.latitude));
      expect(imported.longitude, equals(testSettings.longitude));
      expect(imported.timezone, equals(testSettings.timezone));
      expect(imported.ihtiyatMinutes, equals(testSettings.ihtiyatMinutes));
      expect(imported.runningText, equals(testSettings.runningText));
      expect(imported.iqomahSubuhMinutes, equals(testSettings.iqomahSubuhMinutes));
      expect(imported.iqomahDzuhurMinutes, equals(testSettings.iqomahDzuhurMinutes));
      expect(imported.iqomahAsharMinutes, equals(testSettings.iqomahAsharMinutes));
      expect(imported.iqomahMaghribMinutes, equals(testSettings.iqomahMaghribMinutes));
      expect(imported.iqomahIsyaMinutes, equals(testSettings.iqomahIsyaMinutes));
      expect(imported.hijriAdjustmentDays, equals(testSettings.hijriAdjustmentDays));
      expect(imported.fridayKhutbahMinutes, equals(testSettings.fridayKhutbahMinutes));
      expect(imported.disableFridayIqomah, equals(testSettings.disableFridayIqomah));
      expect(imported.fridayKhotib, equals(testSettings.fridayKhotib));
      expect(imported.fridayImam, equals(testSettings.fridayImam));
      expect(imported.fridayMuadzin, equals(testSettings.fridayMuadzin));
      expect(imported.fridayBilal, equals(testSettings.fridayBilal));
      expect(imported.enableBeepSound, equals(testSettings.enableBeepSound));
      expect(imported.slides.length, equals(1));
      expect(imported.slides[0]['title'], equals('Kajian Subuh'));
    });

    test('importFromJson handles invalid JSON safely by returning null', () {
      expect(ConfigTransferHelper.importFromJson(''), isNull);
      expect(ConfigTransferHelper.importFromJson('{invalid_json'), isNull);
      expect(ConfigTransferHelper.importFromJson('12345'), isNull);
      expect(ConfigTransferHelper.importFromJson('["array"]'), isNull);
    });

    test('generatePermanentTvUrl produces valid URL with base64 config parameter', () {
      final url = ConfigTransferHelper.generatePermanentTvUrl(
        testSettings,
        customBaseUrl: 'https://jadwal-sholat-ecru.vercel.app/',
      );
      expect(url.startsWith('https://jadwal-sholat-ecru.vercel.app/?config='), isTrue);

      final rawBase64 = url.split('?config=')[1];
      expect(rawBase64, isNotEmpty);
    });
  });
}

