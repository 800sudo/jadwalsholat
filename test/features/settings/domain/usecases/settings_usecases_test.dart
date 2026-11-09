import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/repositories/settings_repository.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/usecases/get_app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/usecases/save_app_settings.dart';

class FakeSettingsRepository implements SettingsRepository {
  AppSettings _settings = const AppSettings(
    mosqueName: 'Masjid Raya',
    mosqueAddress: 'Alamat',
    cityName: 'Jakarta',
    latitude: -6.2,
    longitude: 106.8,
    timezone: 7.0,
    ihtiyatMinutes: 2,
    runningText: 'Running Text',
    iqomahSubuhMinutes: 12,
    iqomahDzuhurMinutes: 10,
    iqomahAsharMinutes: 10,
    iqomahMaghribMinutes: 7,
    iqomahIsyaMinutes: 10,
    hijriAdjustmentDays: 0,
  );

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
  }
}

void main() {
  late FakeSettingsRepository fakeRepo;
  late GetAppSettings getAppSettings;
  late SaveAppSettings saveAppSettings;

  setUp(() {
    fakeRepo = FakeSettingsRepository();
    getAppSettings = GetAppSettings(fakeRepo);
    saveAppSettings = SaveAppSettings(fakeRepo);
  });

  test('GetAppSettings mengembalikan data pengaturan tersimpan', () async {
    final result = await getAppSettings();
    expect(result.mosqueName, equals('Masjid Raya'));
  });

  test('SaveAppSettings memperbarui data pengaturan', () async {
    final current = await getAppSettings();
    final updated = current.copyWith(mosqueName: 'Masjid Nabawi Baru');

    await saveAppSettings(updated);
    final result = await getAppSettings();

    expect(result.mosqueName, equals('Masjid Nabawi Baru'));
  });
}
