import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../domain/entities/prayer_schedule.dart';

class IqomahOverlayWidget extends StatelessWidget {
  final TVDisplayMode displayMode;
  final PrayerItem? activePrayer;
  final Duration iqomahRemaining;
  final AppSettings? settings;

  const IqomahOverlayWidget({
    super.key,
    required this.displayMode,
    required this.activePrayer,
    required this.iqomahRemaining,
    this.settings,
  });

  @override
  Widget build(BuildContext context) {
    if (displayMode == TVDisplayMode.normal || activePrayer == null) {
      return const SizedBox.shrink();
    }

    final prayerName = activePrayer!.label.toUpperCase();
    final prayerArabic = activePrayer!.arabic;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF020B08), // Solid 100% Opaque Dark Obsidian
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.3,
          colors: [Color(0xFF08261D), Color(0xFF03140E), Color(0xFF010805)],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.goldPrimary.withAlpha(160),
                    width: 3.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldPrimary.withAlpha(40),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: displayMode == TVDisplayMode.adzanAlert
                      ? _buildAdzanAlert(
                          context,
                          prayerName,
                          prayerArabic,
                          constraints,
                        )
                      : displayMode == TVDisplayMode.iqomahCountdown
                      ? _buildIqomahCountdown(context, prayerName, constraints)
                      : displayMode == TVDisplayMode.khutbah
                      ? _buildKhutbahStandby(context, constraints)
                      : _buildPrayingTime(context, prayerName, constraints),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 1. Tampilan Layar Penuh Saat Waktu Sholat / Adzan
  Widget _buildAdzanAlert(
    BuildContext context,
    String prayerName,
    String prayerArabic,
    BoxConstraints constraints,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Top Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.alertOrange, AppColors.goldPrimary],
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.alertOrange.withAlpha(150),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.volume_up_rounded,
                size: 36,
                color: AppColors.textDark,
              ),
              SizedBox(width: 14),
              Text(
                'SAATNYA ADZAN BERKUMANDANG',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),

        // Big Arabic Calligraphy
        Text(
          prayerArabic,
          style: const TextStyle(
            fontSize: 84,
            fontWeight: FontWeight.bold,
            color: AppColors.goldLight,
            shadows: [Shadow(color: AppColors.goldPrimary, blurRadius: 25)],
          ),
        ),

        // Massive Prayer Name Title
        Column(
          children: [
            Text(
              'WAKTU SHOLAT $prayerName TELAH TIBA',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.w900,
                letterSpacing: 3.0,
                color: AppColors.textLight,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'حَيَّ عَلَى الصَّلَاةِ • حَيَّ عَلَى الْفَلَاحِ',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.emeraldLight,
                letterSpacing: 2,
              ),
            ),
          ],
        ),

        // Bottom Reminder
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.bgDarkStart,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceCardBorder),
          ),
          child: const Text(
            'Mari bersegera mengambil air wudhu dan merapatkan barisan sholat berjamaah',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  /// 2. Tampilan Layar Penuh Hitung Mundur Iqomah (Mau Sholat)
  Widget _buildIqomahCountdown(
    BuildContext context,
    String prayerName,
    BoxConstraints constraints,
  ) {
    final countdownStr = TimeFormatter.formatCountdown(iqomahRemaining);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D4734), Color(0xFF062B1F)],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.goldPrimary, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldPrimary.withAlpha(60),
                blurRadius: 20,
              ),
            ],
          ),
          child: Text(
            'HITUNG MUNDUR IQOMAH SHOLAT $prayerName',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: AppColors.goldLight,
            ),
          ),
        ),

        // Massive Center Countdown Box (Hampir Full Layar)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
          decoration: BoxDecoration(
            color: const Color(0xFF03160F),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: AppColors.goldPrimary, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldPrimary.withAlpha(120),
                blurRadius: 50,
                spreadRadius: 8,
              ),
              const BoxShadow(
                color: Colors.black,
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.hourglass_bottom_rounded,
                  size: 110,
                  color: AppColors.goldPrimary,
                ),
                const SizedBox(width: 24),
                Text(
                  countdownStr,
                  style: const TextStyle(
                    fontSize: 150,
                    fontWeight: FontWeight.w900,
                    color: AppColors.goldLight,
                    letterSpacing: 8,
                    fontFeatures: [FontFeature.tabularFigures()],
                    shadows: [
                      Shadow(color: AppColors.goldPrimary, blurRadius: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Footer Guidance
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.bgDarkStart,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceCardBorder),
          ),
          child: const Text(
            'Laksanakan Sholat Sunnah Qabliyah • Perbanyak Doa di Antara Adzan & Iqomah',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  /// 3. Tampilan Layar Penuh Saat Sholat Berjamaah (Lurus & Rapatkan Shaf)
  Widget _buildPrayingTime(
    BuildContext context,
    String prayerName,
    BoxConstraints constraints,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Giant Phone Alert Icon
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.alertOrange.withAlpha(25),
            border: Border.all(color: AppColors.alertOrange, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.alertOrange.withAlpha(90),
                blurRadius: 35,
                spreadRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.phonelink_erase_rounded,
            size: 90,
            color: AppColors.alertOrange,
          ),
        ),

        // Giant Arabic Calligraphy
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'اسْتَوُوا وَاعْتَدِلُوا وَتَرَاصُّوا',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 84,
              fontWeight: FontWeight.bold,
              color: AppColors.goldLight,
              letterSpacing: 2,
              shadows: [Shadow(color: AppColors.goldPrimary, blurRadius: 25)],
            ),
          ),
        ),

        // Giant Main Title
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'LURUS DAN RAPATKAN SHAF',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 66,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.0,
              color: AppColors.textLight,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ),

        // Massive Red Warning Box (Hampir Full Lebar)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0x33EF4444),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.alertRed, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.alertRed.withAlpha(60),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'MOHON NONAKTIFKAN ATAU HENINGKAN NADA DERING HANDPHONE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: Color(0xFFFCA5A5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 4. Tampilan Layar Penuh Saat Khutbah Jum'at Berlangsung (Standby Khutbah)
  Widget _buildKhutbahStandby(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final khotib = settings?.fridayKhotib.trim() ?? '';
    final imam = settings?.fridayImam.trim() ?? '';
    final muadzin = settings?.fridayMuadzin.trim() ?? '';
    final bilal = settings?.fridayBilal.trim() ?? '';

    final hasPetugas =
        khotib.isNotEmpty ||
        imam.isNotEmpty ||
        muadzin.isNotEmpty ||
        bilal.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Top Badge
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.emeraldPrimary, AppColors.goldPrimary],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldPrimary.withAlpha(90),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mosque, color: AppColors.textDark, size: 28),
                SizedBox(width: 12),
                Text(
                  'KHUTBAH JUM\'AT BERLANGSUNG',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Arabic Calligraphy / Adab Khutbah
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'أَنْصِتُوا وَاسْمَعُوا وَأَطِيعُوا رَحِمَكُمُ اللهُ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.goldLight,
              letterSpacing: 2,
              shadows: [Shadow(color: AppColors.goldPrimary, blurRadius: 25)],
            ),
          ),
        ),

        // Giant Main Title
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'HARAP TENANG & DENGARKAN KHUTBAH',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.0,
              color: AppColors.textLight,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ),

        // Petugas Jum'at Grid / Row (jika terisi)
        if (hasPetugas)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0x33000000),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.goldPrimary.withAlpha(100),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (khotib.isNotEmpty)
                  _buildPetugasItem('KHOTIB', khotib, Icons.record_voice_over),
                if (imam.isNotEmpty)
                  _buildPetugasItem('IMAM', imam, Icons.person),
                if (muadzin.isNotEmpty)
                  _buildPetugasItem('MUADZIN', muadzin, Icons.volume_up),
                if (bilal.isNotEmpty)
                  _buildPetugasItem('BILAL', bilal, Icons.notifications_active),
              ],
            ),
          ),

        // Hadits Adab Khutbah & Larangan HP
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0x22EF4444),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.alertRed.withAlpha(180),
              width: 1.8,
            ),
          ),
          child: const Column(
            children: [
              Text(
                '📵 NONAKTIFKAN NADA DERING HANDPHONE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Color(0xFFFCA5A5),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '"Barangsiapa berbicara saat imam berkhutbah, maka tidak ada pahala Jum\'at baginya." (HR. Ahmad)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPetugasItem(String role, String name, IconData icon) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.goldPrimary),
              const SizedBox(width: 6),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: AppColors.goldPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
