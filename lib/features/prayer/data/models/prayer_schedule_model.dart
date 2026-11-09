import '../../domain/entities/prayer_schedule.dart';

class PrayerScheduleModel extends PrayerSchedule {
  const PrayerScheduleModel({
    required super.date,
    required super.items,
    super.nextPrayer,
    super.activePrayer,
    super.timeUntilNext,
    super.displayMode,
    super.iqomahRemaining,
  });

  factory PrayerScheduleModel.fromEntity(PrayerSchedule entity) {
    return PrayerScheduleModel(
      date: entity.date,
      items: entity.items,
      nextPrayer: entity.nextPrayer,
      activePrayer: entity.activePrayer,
      timeUntilNext: entity.timeUntilNext,
      displayMode: entity.displayMode,
      iqomahRemaining: entity.iqomahRemaining,
    );
  }
}
