import 'package:equatable/equatable.dart';

import '../../domain/entities/prayer_schedule.dart';

abstract class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object?> get props => [];
}

class PrayerInitial extends PrayerState {}

class PrayerLoading extends PrayerState {}

class PrayerLoaded extends PrayerState {
  final DateTime currentTime;
  final PrayerSchedule schedule;

  const PrayerLoaded({required this.currentTime, required this.schedule});

  @override
  List<Object?> get props => [currentTime, schedule];
}

class PrayerError extends PrayerState {
  final String message;

  const PrayerError(this.message);

  @override
  List<Object?> get props => [message];
}
