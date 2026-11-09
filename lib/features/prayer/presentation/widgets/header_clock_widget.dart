import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/utils/hijri_calculator.dart';
import '../../../settings/domain/entities/app_settings.dart';

class HeaderClockWidget extends StatelessWidget {
  final DateTime currentTime;
  final AppSettings settings;
  final VoidCallback onOpenSettings;

  const HeaderClockWidget({
    super.key,
    required this.currentTime,
    required this.settings,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriCalculator.fromGregorian(
      currentTime,
      adjustmentDays: settings.hijriAdjustmentDays,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceCardBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Mosque Branding
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.goldLight, AppColors.goldDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldPrimary.withAlpha(80),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mosque,
                      size: 32,
                      color: AppColors.bgDarkStart,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        settings.mosqueName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          color: AppColors.goldLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 15,
                            color: AppColors.emeraldLight,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${settings.mosqueAddress} • Kota ${settings.cityName}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Center: Dates (Masehi & Hijriyah)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bgDarkStart.withAlpha(160),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.emeraldDark.withAlpha(120)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TimeFormatter.formatFullDate(currentTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hijriDate.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.goldPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Right: Large Digital Clock & Settings Button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF031E15), Color(0xFF0A3325)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.goldPrimary.withAlpha(120),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldPrimary.withAlpha(30),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      TimeFormatter.formatHHmm(currentTime),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppColors.goldLight,
                        letterSpacing: 2,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      ':${currentTime.second.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldDeep,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'WIB',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emeraldLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Settings Shortcut Button (D-Pad focusable)
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.goldPrimary),
                tooltip: 'Pengaturan (Remote OK)',
                onPressed: onOpenSettings,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bgDarkStart,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.surfaceCardBorder),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
