import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/repositories/settings_repository.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/usecases/get_app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/usecases/save_app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:jadwal_sholat_tv/features/settings/presentation/bloc/settings_event.dart';
import 'package:jadwal_sholat_tv/features/settings/presentation/bloc/settings_state.dart';

class MockSettingsRepo implements SettingsRepository {
  AppSettings settings = const AppSettings(
    mosqueName: 'Masjid Test',
    mosqueAddress: 'Jl. Test',
    cityName: 'Bandung',
    latitude: -6.9,
    longitude: 107.6,
    timezone: 7.0,
    ihtiyatMinutes: 2,
    runningText: 'Pesan',
    iqomahSubuhMinutes: 10,
    iqomahDzuhurMinutes: 10,
    iqomahAsharMinutes: 10,
    iqomahMaghribMinutes: 7,
    iqomahIsyaMinutes: 10,
    hijriAdjustmentDays: 0,
  );

  @override
  Future<AppSettings> getSettings() async => settings;

  @override
  Future<void> saveSettings(AppSettings newSettings) async {
    settings = newSettings;
  }
}

void main() {
  late MockSettingsRepo repo;
  late SettingsBloc bloc;

  setUp(() {
    repo = MockSettingsRepo();
    bloc = SettingsBloc(
      getAppSettings: GetAppSettings(repo),
      saveAppSettings: SaveAppSettings(repo),
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('state awal adalah SettingsInitial', () {
    expect(bloc.state, equals(SettingsInitial()));
  });

  test(
    'LoadSettingsEvent memancarkan [SettingsLoading, SettingsLoaded]',
    () async {
      final expected = [
        SettingsLoading(),
        SettingsLoaded(settings: repo.settings),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const LoadSettingsEvent());
    },
  );

  test('UpdateSettingsEvent memperbarui state ke SettingsLoaded dengan pesan sukses', () async {
    final updated = repo.settings.copyWith(mosqueName: 'Masjid Terupdate');

    final expected = [
      SettingsLoading(),
      SettingsLoaded(
        settings: updated,
        message: 'Pengaturan berhasil disimpan',
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));
    bloc.add(UpdateSettingsEvent(updated));
  });
}
