import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

import '../../domain/usecases/get_prayer_schedule.dart';
import 'prayer_event.dart';
import 'prayer_state.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final GetPrayerSchedule getPrayerSchedule;
  Timer? _timer;
  AppSettings? _currentSettings;

  PrayerBloc({required this.getPrayerSchedule}) : super(PrayerInitial()) {
    on<InitPrayerScheduleEvent>(_onInitPrayerSchedule);
    on<PrayerTickEvent>(_onPrayerTick);
    on<SettingsChangedEvent>(_onSettingsChanged);
  }

  void _onInitPrayerSchedule(
    InitPrayerScheduleEvent event,
    Emitter<PrayerState> emit,
  ) {
    _currentSettings = event.settings;
    _startTimer();

    final now = DateTime.now();
    final schedule = getPrayerSchedule(
      currentTime: now,
      settings: event.settings,
    );

    emit(PrayerLoaded(currentTime: now, schedule: schedule));
  }

  void _onPrayerTick(PrayerTickEvent event, Emitter<PrayerState> emit) {
    if (_currentSettings == null) return;

    final schedule = getPrayerSchedule(
      currentTime: event.currentTime,
      settings: _currentSettings!,
    );

    emit(PrayerLoaded(currentTime: event.currentTime, schedule: schedule));
  }

  void _onSettingsChanged(
    SettingsChangedEvent event,
    Emitter<PrayerState> emit,
  ) {
    _currentSettings = event.settings;
    final now = DateTime.now();
    final schedule = getPrayerSchedule(
      currentTime: now,
      settings: event.settings,
    );

    emit(PrayerLoaded(currentTime: now, schedule: schedule));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(PrayerTickEvent(DateTime.now()));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
