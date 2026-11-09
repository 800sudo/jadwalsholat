import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/utils/astronomical_calculator.dart';

void main() {
  group('AstronomicalCalculator Offline Engine', () {
    test('menghitung waktu sholat Jakarta secara akurat dan berurutan', () {
      final testDate = DateTime(2026, 11, 6);
      final result = AstronomicalCalculator.calculate(
        date: testDate,
        latitude: -6.2088,
        longitude: 106.8456,
        timezone: 7.0,
        ihtiyatMinutes: 2,
      );

      // Verifikasi urutan waktu sholat logis
      expect(result.imsak.isBefore(result.subuh), isTrue);
      expect(result.subuh.isBefore(result.terbit), isTrue);
      expect(result.terbit.isBefore(result.dzuhur), isTrue);
      expect(result.dzuhur.isBefore(result.ashar), isTrue);
      expect(result.ashar.isBefore(result.maghrib), isTrue);
      expect(result.maghrib.isBefore(result.isya), isTrue);

      // Range wajar untuk wilayah Jakarta (WIB)
      expect(result.subuh.hour, equals(4)); // sekitar 04:00 - 04:59
      expect(result.terbit.hour, equals(5)); // sekitar 05:00 - 05:59
      expect(result.dzuhur.hour, isIn([11, 12])); // sekitar 11:30 - 12:15
      expect(
        result.ashar.hour,
        isIn([14, 15]),
      ); // sekitar 14:50 - 15:30 tergantung musim
      expect(result.maghrib.hour, equals(17)); // sekitar 17:40 - 18:15
      expect(result.isya.hour, isIn([18, 19])); // sekitar 18:50 - 19:30
    });

    test('menghitung waktu sholat Indramayu (Jawa Barat)', () {
      final testDate = DateTime(2026, 11, 6);
      final result = AstronomicalCalculator.calculate(
        date: testDate,
        latitude: -6.3275,
        longitude: 108.3249,
        timezone: 7.0,
        ihtiyatMinutes: 2,
      );

      expect(result.imsak.isBefore(result.subuh), isTrue);
      expect(result.subuh.isBefore(result.terbit), isTrue);
      expect(result.terbit.isBefore(result.dzuhur), isTrue);
      expect(result.dzuhur.isBefore(result.ashar), isTrue);
      expect(result.ashar.isBefore(result.maghrib), isTrue);
      expect(result.maghrib.isBefore(result.isya), isTrue);

      expect(result.subuh.hour, equals(4)); // sekitar 04:00
      expect(result.dzuhur.hour, isIn([11, 12])); // sekitar 11:35
      expect(result.maghrib.hour, equals(17)); // sekitar 17:45
    });

    test('menghitung waktu sholat Surabaya (Jawa Timur)', () {
      final testDate = DateTime(2026, 3, 15); // Sekitar bulan Ramadhan
      final result = AstronomicalCalculator.calculate(
        date: testDate,
        latitude: -7.2575,
        longitude: 112.7521,
        timezone: 7.0,
        ihtiyatMinutes: 2,
      );

      expect(result.subuh.isBefore(result.dzuhur), isTrue);
      expect(result.dzuhur.isBefore(result.ashar), isTrue);
      expect(result.ashar.isBefore(result.maghrib), isTrue);
      expect(result.maghrib.isBefore(result.isya), isTrue);
      expect(result.imsak.difference(result.subuh).inMinutes, equals(-10));
    });

    test('menghitung waktu sholat WITA (Makassar UTC+8)', () {
      final testDate = DateTime(2026, 6, 21); // Summer solstice
      final result = AstronomicalCalculator.calculate(
        date: testDate,
        latitude: -5.1477,
        longitude: 119.4327,
        timezone: 8.0,
        ihtiyatMinutes: 2,
      );

      expect(result.subuh.hour, equals(4));
      expect(result.dzuhur.hour, equals(12));
      expect(result.ashar.hour, equals(15));
      expect(result.maghrib.hour, equals(18));
      expect(result.isya.hour, equals(19));
    });
  });
}
