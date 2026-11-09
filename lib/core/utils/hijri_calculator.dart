class HijriDate {
  final int year;
  final int month;
  final int day;
  final String monthName;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
    required this.monthName,
  });

  static const List<String> monthNames = [
    'Muharram',
    'Safar',
    'Rabiul Awwal',
    'Rabiul Akhir',
    'Jumadil Awwal',
    'Jumadil Akhir',
    'Rajab',
    'Sya\'ban',
    'Ramadhan',
    'Syawwal',
    'Dzulqa\'dah',
    'Dzulhijjah',
  ];

  @override
  String toString() => '$day $monthName $year H';
}

/// Konversi Kalender Masehi ke Hijriyah secara Offline
class HijriCalculator {
  HijriCalculator._();

  /// Konversi DateTime ke HijriDate dengan koreksi penyesuaian hari
  static HijriDate fromGregorian(DateTime date, {int adjustmentDays = 0}) {
    final DateTime adjustedDate = date.add(Duration(days: adjustmentDays));
    final double jd = _gregorianToJulian(
      adjustedDate.year,
      adjustedDate.month,
      adjustedDate.day,
    );

    return _julianToHijri(jd);
  }

  static double _gregorianToJulian(int year, int month, int day) {
    int y = year;
    int m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final int a = (y / 100).floor();
    final int b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        b -
        1524.5;
  }

  static HijriDate _julianToHijri(double jd) {
    final int l = (jd - 1948440 + 10632).floor();
    final int n = ((l - 1) / 10631).floor();
    final int l2 = l - 10631 * n + 354;
    final int j =
        (((10985 - l2) / 5316).floor()) * (((50 * l2) / 17719).floor()) +
        ((l2 / 5670).floor()) * (((43 * l2) / 15238).floor());
    final int l3 =
        l2 -
        (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
        ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
        29;
    final int m = ((24 * l3) / 709).floor();
    final int d = l3 - ((709 * m) / 24).floor();
    final int y = 30 * n + j - 30;

    final int monthIndex = m.clamp(1, 12);
    final String monthName = HijriDate.monthNames[monthIndex - 1];

    return HijriDate(
      year: y,
      month: monthIndex,
      day: d.clamp(1, 30),
      monthName: monthName,
    );
  }
}
