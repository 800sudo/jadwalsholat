import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/constants/indonesia_cities_data.dart';

void main() {
  group('IndonesiaCitiesData Database & Search Engine Test', () {
    test('database memuat 514 kabupaten/kota dan 38 provinsi di Indonesia', () {
      expect(IndonesiaCitiesData.allCities.length, equals(514));
      expect(IndonesiaCitiesData.allProvinces.length, equals(38));
    });

    test(
      'pencarian awalan "IN" memprioritaskan Indramayu dan kota berawalan IN',
      () {
        final results = IndonesiaCitiesData.searchCities('IN');
        expect(results, isNotEmpty);

        // Pastikan hasil-hasil teratas diawali dengan 'in'
        final topResults = results
            .take(4)
            .map((c) => c.name.toLowerCase())
            .toList();
        expect(topResults, contains('indramayu'));

        // Indramayu berada di Jawa Barat dengan zona WIB (7.0)
        final indramayu = results.firstWhere(
          (c) => c.name.toLowerCase() == 'indramayu',
        );
        expect(indramayu.province, equals('Jawa Barat'));
        expect(indramayu.timezone, equals(7.0));
        expect(indramayu.latitude, closeTo(-6.3275, 0.001));
        expect(indramayu.longitude, closeTo(108.3249, 0.001));
      },
    );

    test(
      'filter provinsi Jawa Barat membatasi pencarian hanya di Jawa Barat',
      () {
        final results = IndonesiaCitiesData.searchCities(
          '',
          provinceFilter: 'Jawa Barat',
        );
        expect(results, isNotEmpty);
        for (final city in results) {
          expect(city.province, equals('Jawa Barat'));
        }
        expect(results.any((c) => c.name == 'Indramayu'), isTrue);
        expect(results.any((c) => c.name == 'Bandung'), isTrue);
      },
    );

    test('pencarian case-insensitive', () {
      final resLower = IndonesiaCitiesData.searchCities('indramayu');
      final resUpper = IndonesiaCitiesData.searchCities('INDRAMAYU');
      expect(resLower.length, equals(resUpper.length));
      expect(resLower.first.name, equals(resUpper.first.name));
    });
  });
}
