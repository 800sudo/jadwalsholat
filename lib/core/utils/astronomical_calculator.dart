import 'dart:math' as math;

/// Model hasil kalkulasi waktu sholat dalam DateTime lokal
class PrayerScheduleResult {
  final DateTime imsak;
  final DateTime subuh;
  final DateTime terbit;
  final DateTime dzuhur;
  final DateTime ashar;
  final DateTime maghrib;
  final DateTime isya;

  const PrayerScheduleResult({
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });
}

/// Astronomical Calculator Waktu Sholat Standar Kemenag RI
/// Menghitung jadwal sholat 100% offline berdasarkan hisab posisi matahari
class AstronomicalCalculator {
  // Sudut Kemenag RI
  static const double subuhAngle = 20.0; // 20 derajat di bawah ufuk
  static const double isyaAngle = 18.0; // 18 derajat di bawah ufuk
  static const double sunRefraction =
      0.8333; // Refraksi & radius piringan matahari

  /// Menghitung jadwal sholat untuk tanggal dan koordinat tertentu
  static PrayerScheduleResult calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    required double timezone,
    int ihtiyatMinutes = 2, // Pengaman waktu Kemenag RI
  }) {
    final double jd = _julianDate(date.year, date.month, date.day);
    final double d = jd - 2451545.0;

    // Rata-rata anomali matahari (derajat)
    final double g = _fixAngle(357.529 + 0.98560028 * d);

    // Rata-rata bujur ekliptika (derajat)
    final double q = _fixAngle(280.459 + 0.98564736 * d);

    // Bujur ekliptika semu matahari (derajat)
    final double l = _fixAngle(
      q + 1.915 * math.sin(_degToRad(g)) + 0.020 * math.sin(_degToRad(2 * g)),
    );

    // Kemiringan sumbu bumi (obliquity of the ecliptic)
    final double e = 23.439 - 0.00000036 * d;

    // Deklinasi matahari (derajat)
    final double declination = _radToDeg(
      math.asin(math.sin(_degToRad(e)) * math.sin(_degToRad(l))),
    );

    // Asensio rekta (Right Ascension) dalam jam
    double ra =
        _radToDeg(
          math.atan2(
            math.cos(_degToRad(e)) * math.sin(_degToRad(l)),
            math.cos(_degToRad(l)),
          ),
        ) /
        15.0;
    ra = _fixHour(ra);

    // Equation of Time (Perataan waktu) dalam jam
    final double eqt = q / 15.0 - ra;

    // Waktu transit matahari (Dzuhur hakiki sebelum ihtiyat) dalam jam
    final double transit = 12.0 + timezone - (longitude / 15.0) - eqt;

    // Hitung waktu sholat dalam desimal jam
    // 1. Dzuhur
    final double dzuhurHours = transit + (ihtiyatMinutes / 60.0);

    // 2. Terbit & Maghrib (altitude = -0.8333 derajat)
    final double sunHalfDay = _hourAngle(latitude, declination, -sunRefraction);
    final double terbitHours = transit - sunHalfDay;
    final double maghribHours = transit + sunHalfDay + (ihtiyatMinutes / 60.0);

    // 3. Subuh (altitude = -20 derajat)
    final double subuhHalfDay = _hourAngle(latitude, declination, -subuhAngle);
    final double subuhHours = transit - subuhHalfDay + (ihtiyatMinutes / 60.0);

    // 4. Imsak (10 menit sebelum subuh)
    final double imsakHours = subuhHours - (10.0 / 60.0);

    // 5. Ashar (Syafi'i: bayangan benda = 1 panjang benda)
    final double asharAltitude = _radToDeg(
      math.atan(
        1.0 / (1.0 + math.tan(_degToRad((latitude - declination).abs()))),
      ),
    );
    final double asharHalfDay = _hourAngle(
      latitude,
      declination,
      asharAltitude,
    );
    final double asharHours = transit + asharHalfDay + (ihtiyatMinutes / 60.0);

    // 6. Isya (altitude = -18 derajat)
    final double isyaHalfDay = _hourAngle(latitude, declination, -isyaAngle);
    final double isyaHours = transit + isyaHalfDay + (ihtiyatMinutes / 60.0);

    return PrayerScheduleResult(
      imsak: _hoursToDateTime(date, imsakHours),
      subuh: _hoursToDateTime(date, subuhHours),
      terbit: _hoursToDateTime(date, terbitHours),
      dzuhur: _hoursToDateTime(date, dzuhurHours),
      ashar: _hoursToDateTime(date, asharHours),
      maghrib: _hoursToDateTime(date, maghribHours),
      isya: _hoursToDateTime(date, isyaHours),
    );
  }

  /// Menghitung Sudut Waktu (Hour Angle) untuk ketinggian tertentu
  static double _hourAngle(double lat, double decl, double altitude) {
    final double cosHA =
        (math.sin(_degToRad(altitude)) -
            math.sin(_degToRad(lat)) * math.sin(_degToRad(decl))) /
        (math.cos(_degToRad(lat)) * math.cos(_degToRad(decl)));

    if (cosHA > 1.0) {
      return 0.0;
    } else if (cosHA < -1.0) {
      return 12.0;
    }
    return _radToDeg(math.acos(cosHA)) / 15.0;
  }

  /// Konversi desimal jam menjadi DateTime
  static DateTime _hoursToDateTime(DateTime baseDate, double hours) {
    final double normalizedHours = _fixHour(hours);
    final int hour = normalizedHours.floor();
    final double minuteDecimal = (normalizedHours - hour) * 60.0;
    final int minute = minuteDecimal.floor();
    final int second = ((minuteDecimal - minute) * 60.0).round();

    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      hour.clamp(0, 23),
      minute.clamp(0, 59),
      second.clamp(0, 59),
    );
  }

  /// Julian Date converter
  static double _julianDate(int year, int month, int day) {
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

  static double _degToRad(double degree) => degree * (math.pi / 180.0);
  static double _radToDeg(double radian) => radian * (180.0 / math.pi);

  static double _fixAngle(double angle) {
    double res = angle - 360.0 * (angle / 360.0).floor();
    if (res < 0) res += 360.0;
    return res;
  }

  static double _fixHour(double hour) {
    double res = hour - 24.0 * (hour / 24.0).floor();
    if (res < 0) res += 24.0;
    return res;
  }
}
