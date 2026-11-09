import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/features/settings/data/models/app_settings_model.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

void main() {
  group('AppSettingsModel', () {
    const tModel = AppSettingsModel(
      mosqueName: 'Masjid Al-Ikhlas',
      mosqueAddress: 'Jl. Merdeka No. 45',
      cityName: 'Jakarta',
      latitude: -6.2,
      longitude: 106.8,
      timezone: 7.0,
      ihtiyatMinutes: 2,
      runningText: 'Selamat Datang',
      iqomahSubuhMinutes: 12,
      iqomahDzuhurMinutes: 10,
      iqomahAsharMinutes: 10,
      iqomahMaghribMinutes: 7,
      iqomahIsyaMinutes: 10,
      hijriAdjustmentDays: 0,
      slides: [
        {
          'title': 'Kajian Indramayu',
          'subtitle': 'Kajian Akbar',
          'badge': 'AGENDA',
          'imageUrl': 'https://example.com/masjid.jpg',
        },
      ],
    );

    test('harus merupakan subclass dari AppSettings', () {
      expect(tModel, isA<AppSettings>());
    });

    test('fromJson dan toJson berhasil memetakan data dengan benar', () {
      final jsonMap = tModel.toJson();
      final fromJson = AppSettingsModel.fromJson(jsonMap);

      expect(fromJson, equals(tModel));
      expect(fromJson.mosqueName, 'Masjid Al-Ikhlas');
      expect(fromJson.latitude, -6.2);
    });
  });
}
