import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_app_settings.dart';
import '../../domain/usecases/save_app_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetAppSettings getAppSettings;
  final SaveAppSettings saveAppSettings;

  SettingsBloc({required this.getAppSettings, required this.saveAppSettings})
    : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final settings = await getAppSettings();
      emit(SettingsLoaded(settings: settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      await saveAppSettings(event.settings);
      emit(
        SettingsLoaded(
          settings: event.settings,
          message: 'Pengaturan berhasil disimpan',
        ),
      );
    } catch (e) {
      emit(SettingsError('Gagal menyimpan pengaturan: $e'));
    }
  }
}
