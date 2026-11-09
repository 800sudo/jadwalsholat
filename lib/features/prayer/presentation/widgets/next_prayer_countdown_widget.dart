import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/prayer_schedule.dart';

class NextPrayerCountdownWidget extends StatelessWidget {
  final PrayerItem? nextPrayer;
  final Duration timeUntilNext;

  const NextPrayerCountdownWidget({
    super.key,
    required this.nextPrayer,
    required this.timeUntilNext,
  });

  @override
  Widget build(BuildContext context) {
    if (nextPrayer == null) {
      return const SizedBox.shrink();
    }

    final countdownStr = TimeFormatter.formatCountdown(timeUntilNext);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(0.6, -0.6),
          radius: 1.2,
          colors: [Color(0xFF133F31), Color(0xFF0A261D), Color(0xFF04150F)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.goldPrimary.withAlpha(150),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldPrimary.withAlpha(40),
            blurRadius: 25,
            spreadRadius: 2,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header: Tag "MENUJU WAKTU SHOLAT" & Arabic Calligraphy
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.goldPrimary, AppColors.goldDeep],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: AppColors.textDark,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'SHOLAT BERIKUTNYA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                nextPrayer!.name.arabic,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldLight.withAlpha(180),
                ),
              ),
            ],
          ),

          // Prayer Name & Target Time (Rata tengah, di bawah nama sholat, ukuran lebih besar & jelas)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    nextPrayer!.label.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      height: 1.1,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgDarkStart.withAlpha(180),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.goldPrimary.withAlpha(120),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          size: 20,
                          color: AppColors.goldPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pukul ${TimeFormatter.formatHHmm(nextPrayer!.dateTime)} WIB',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: AppColors.goldLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Big Glowing Countdown Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.bgDarkStart.withAlpha(200),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.goldPrimary.withAlpha(80),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.hourglass_top_rounded,
                  size: 32,
                  color: AppColors.goldPrimary,
                ),
                const SizedBox(width: 14),
                Text(
                  countdownStr,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: AppColors.goldLight,
                    letterSpacing: 3,
                    fontFeatures: [FontFeature.tabularFigures()],
                    shadows: [
                      Shadow(color: AppColors.goldPrimary, blurRadius: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
