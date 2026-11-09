class AppConstants {
  AppConstants._();

  static const String appTitle = 'Jadwal Sholat Smart TV';

  // Default Mosque Information
  static const String defaultMosqueName = 'MASJID AGUNG NURUL IMAN';
  static const String defaultMosqueAddress = 'Pusat Dakwah & Ibadah Umat Islam';

  // Default Running Text
  static const String defaultRunningText =
      '• Lurus dan rapatkan shaf demi kesempurnaan sholat berjamaah '
      '• Mohon menonaktifkan atau mengheningkan suara telepon genggam '
      '• "Barangsiapa membangun masjid karena Allah, maka Allah akan membangunkan untuknya rumah di surga" (HR. Bukhari & Muslim) '
      '• Salurkan infaq & sedekah terbaik Anda untuk kemakmuran masjid •';

  // Default Iqomah Durations (in minutes)
  static const int defaultIqomahSubuhMinutes = 12;
  static const int defaultIqomahDzuhurMinutes = 10;
  static const int defaultIqomahAsharMinutes = 10;
  static const int defaultIqomahMaghribMinutes = 7;
  static const int defaultIqomahIsyaMinutes = 10;

  // Sholat screen duration (in minutes during prayer)
  static const int defaultPrayingScreenDurationMinutes = 12;

  // Default Friday Settings
  static const int defaultFridayKhutbahMinutes = 40;
  static const bool defaultDisableFridayIqomah = true;
  static const String defaultFridayKhotib = 'Ustadz Ahmad Fauzi, M.Ag.';
  static const String defaultFridayImam = 'Ustadz Muhammad Ridwan, Al-Hafizh';
  static const String defaultFridayMuadzin = 'Ust. Hasan Basri';
  static const String defaultFridayBilal = 'Ust. Bilal Ramadhan';

  // Default Beep Sound Settings
  static const bool defaultEnableBeepSound = true;

  // Default Calculation Parameters (Indramayu default)
  static const String defaultCityName = 'Indramayu';
  static const double defaultLatitude = -6.3275;
  static const double defaultLongitude = 108.3249;
  static const double defaultTimezone = 7.0;
  static const int defaultIhtiyatMinutes = 2; // Kemenag standard safety buffer

  // Slide items (announcements/hadiths with offline default wallpapers)
  static const List<Map<String, String>> defaultSlides = [
    {
      'title': 'Keutamaan Sholat Berjamaah',
      'subtitle': '"Sholat berjamaah lebih utama dua puluh tujuh derajat dibanding sholat sendirian." (HR. Bukhari & Muslim)',
      'badge': 'HADITS SHAHIH',
      'imageUrl': 'assets/images/masjid_nabawi.png',
      'imageFit': 'fill',
    },
    {
      'title': 'Kajian Rutin Ba\'da Maghrib',
      'subtitle': 'Setiap Malam Kamis: Kajian Tafsir Ibnu Katsir bersama Ustadz Pengasuh Masjid.',
      'badge': 'AGENDA MASJID',
      'imageUrl': 'assets/images/masjidil_haram.png',
      'imageFit': 'fill',
    },
    {
      'title': 'Jumat Berkah Berbagi',
      'subtitle': 'Menerima penyaluran sedekah nasi bungkus dan santunan dhuafa setiap hari Jumat.',
      'badge': 'INFAQ & SEDEKAH',
      'imageUrl': 'assets/images/masjid_baiturrahman.png',
      'imageFit': 'fill',
    },
    {
      'title': 'Menjaga Kesucian Shaf',
      'subtitle': 'Rapatkan bahu dengan bahu, tumit dengan tumit, dan luruskan barisan sebelum takbir.',
      'badge': 'ADAB MASJID',
      'imageUrl': 'assets/images/kaligrafi_emas.png',
      'imageFit': 'fill',
    },
  ];

  // Storage Keys
  static const String keyMosqueName = 'pref_mosque_name';
  static const String keyMosqueAddress = 'pref_mosque_address';
  static const String keyCityName = 'pref_city_name';
  static const String keyLatitude = 'pref_latitude';
  static const String keyLongitude = 'pref_longitude';
  static const String keyTimezone = 'pref_timezone';
  static const String keyIhtiyatMinutes = 'pref_ihtiyat_minutes';
  static const String keyRunningText = 'pref_running_text';
  static const String keyIqomahSubuh = 'pref_iqomah_subuh';
  static const String keyIqomahDzuhur = 'pref_iqomah_dzuhur';
  static const String keyIqomahAshar = 'pref_iqomah_ashar';
  static const String keyIqomahMaghrib = 'pref_iqomah_maghrib';
  static const String keyIqomahIsya = 'pref_iqomah_isya';
  static const String keyHijriAdjustment = 'pref_hijri_adjustment';
  static const String keySlides = 'pref_slides';
  static const String keyFridayKhutbahMinutes = 'pref_friday_khutbah_minutes';
  static const String keyDisableFridayIqomah = 'pref_disable_friday_iqomah';
  static const String keyFridayKhotib = 'pref_friday_khotib';
  static const String keyFridayImam = 'pref_friday_imam';
  static const String keyFridayMuadzin = 'pref_friday_muadzin';
  static const String keyFridayBilal = 'pref_friday_bilal';
  static const String keyEnableBeepSound = 'pref_enable_beep_sound';
}
