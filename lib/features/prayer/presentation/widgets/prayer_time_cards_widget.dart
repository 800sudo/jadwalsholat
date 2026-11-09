import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/prayer_schedule.dart';

class PrayerTimeCardsWidget extends StatelessWidget {
  final List<PrayerItem> items;
  final PrayerItem? activePrayer;
  final PrayerItem? nextPrayer;

  const PrayerTimeCardsWidget({
    super.key,
    required this.items,
    this.activePrayer,
    this.nextPrayer,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: items.map((item) {
            final isNext =
                nextPrayer?.name == item.name &&
                nextPrayer?.dateTime.day == item.dateTime.day;
            final isActive = activePrayer?.name == item.name;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: _buildPrayerCard(
                  item: item,
                  isNext: isNext,
                  isActive: isActive,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPrayerCard({
    required PrayerItem item,
    required bool isNext,
    required bool isActive,
  }) {
    // Styling based on state
    final Color bgColor = isActive
        ? AppColors.surfaceCardActive
        : isNext
        ? const Color(0xFF163E32)
        : AppColors.surfaceCard;

    final Color textColor = isActive ? AppColors.textDark : AppColors.textLight;
    final Color timeColor = isActive ? AppColors.textDark : AppColors.goldLight;
    final Color arabicColor = isActive
        ? AppColors.textDark.withAlpha(160)
        : AppColors.emeraldLight.withAlpha(200);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppColors.goldLight
              : isNext
              ? AppColors.goldPrimary
              : AppColors.surfaceCardBorder,
          width: isActive ? 2.5 : (isNext ? 2.0 : 1.0),
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.goldPrimary.withAlpha(120),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                const BoxShadow(
                  color: Colors.black45,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : isNext
            ? [
                BoxShadow(
                  color: AppColors.emeraldLight.withAlpha(60),
                  blurRadius: 10,
                ),
              ]
            : const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Arabic Title
          Text(
            item.arabic,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: arabicColor,
            ),
          ),
          const SizedBox(height: 2),

          // Indonesian Title
          Text(
            item.label.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),

          // Divider
          Container(
            width: 32,
            height: 2,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.textDark.withAlpha(80)
                  : AppColors.goldPrimary.withAlpha(80),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),

          // Prayer Time (HH:mm)
          Text(
            TimeFormatter.formatHHmm(item.dateTime),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: timeColor,
              letterSpacing: 1,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),

          // Status Badge (AKTIF / SELANJUTNYA / NORMAL)
          const SizedBox(height: 6),
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.textDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'AKTIF',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.goldLight,
                  letterSpacing: 0.8,
                ),
              ),
            )
          else if (isNext)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.emeraldDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'SELANJUTNYA',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textLight,
                  letterSpacing: 0.6,
                ),
              ),
            )
          else
            const SizedBox(height: 16),
        ],
      ),
    );
  }
}
