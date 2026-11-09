import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/features/prayer/data/datasources/prayer_local_datasource.dart';
import 'package:jadwal_sholat_tv/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:jadwal_sholat_tv/features/prayer/domain/usecases/get_prayer_schedule.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/bloc/prayer_event.dart';
import 'package:jadwal_sholat_tv/features/prayer/presentation/bloc/prayer_state.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';

void main() {
  late PrayerBloc bloc;
  late AppSettings settings;

  setUp(() {
    final ds = PrayerLocalDataSourceImpl();
    final repo = PrayerRepositoryImpl(localDataSource: ds);
    final useCase = GetPrayerSchedule(repo);

    bloc = PrayerBloc(getPrayerSchedule: useCase);

    settings = const AppSettings(
      mosqueName: 'Masjid',
      mosqueAddress: 'Alamat',
      cityName: 'Jakarta',
      latitude: -6.2,
      longitude: 106.8,
      timezone: 7.0,
      ihtiyatMinutes: 2,
      runningText: 'Text',
      iqomahSubuhMinutes: 10,
      iqomahDzuhurMinutes: 10,
      iqomahAsharMinutes: 10,
      iqomahMaghribMinutes: 7,
      iqomahIsyaMinutes: 10,
      hijriAdjustmentDays: 0,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('state awal adalah PrayerInitial', () {
    expect(bloc.state, equals(PrayerInitial()));
  });

  test(
    'InitPrayerScheduleEvent memancarkan PrayerLoaded dengan jadwal valid',
    () async {
      bloc.add(InitPrayerScheduleEvent(settings));

      await expectLater(
        bloc.stream,
        emits(
          isA<PrayerLoaded>().having(
            (state) => state.schedule.items.length,
            'jumlah waktu sholat',
            7,
          ),
        ),
      );
    },
  );
}
