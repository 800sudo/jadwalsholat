import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AppSettings> getSettings() async {
    return await localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final model = AppSettingsModel.fromEntity(settings);
    await localDataSource.saveSettings(model);
  }
}
