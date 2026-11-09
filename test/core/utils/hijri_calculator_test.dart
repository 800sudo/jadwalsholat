import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/utils/hijri_calculator.dart';

void main() {
  group('HijriCalculator Offline Converter', () {
    test('konversi kalender Masehi ke Hijriyah menghasilkan nilai valid', () {
      final date = DateTime(2026, 11, 6);
      final hijri = HijriCalculator.fromGregorian(date);

      expect(hijri.year, greaterThanOrEqualTo(1447));
      expect(hijri.month, inInclusiveRange(1, 12));
      expect(hijri.day, inInclusiveRange(1, 30));
      expect(hijri.monthName.isNotEmpty, isTrue);
      expect(hijri.toString(), contains('H'));
    });

    test('penyesuaian hari koreksi kalender Hijriyah (+/- 1 hari)', () {
      final date = DateTime(2026, 11, 6);
      final hijriNormal = HijriCalculator.fromGregorian(
        date,
        adjustmentDays: 0,
      );
      final hijriPlus1 = HijriCalculator.fromGregorian(date, adjustmentDays: 1);
      final hijriMinus1 = HijriCalculator.fromGregorian(
        date,
        adjustmentDays: -1,
      );

      expect(
        hijriPlus1.day != hijriNormal.day ||
            hijriPlus1.month != hijriNormal.month,
        isTrue,
      );
      expect(
        hijriMinus1.day != hijriNormal.day ||
            hijriMinus1.month != hijriNormal.month,
        isTrue,
      );
    });
  });
}
