import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/settings/data/datasources/settings_local_datasource.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/domain/usecases/get_app_settings.dart';
import '../features/settings/domain/usecases/save_app_settings.dart';
import '../features/settings/presentation/bloc/settings_bloc.dart';

import '../features/prayer/data/datasources/prayer_local_datasource.dart';
import '../features/prayer/data/repositories/prayer_repository_impl.dart';
import '../features/prayer/domain/repositories/prayer_repository.dart';
import '../features/prayer/domain/usecases/get_prayer_schedule.dart';
import '../features/prayer/presentation/bloc/prayer_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Settings Feature
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetAppSettings(sl()));
  sl.registerLazySingleton(() => SaveAppSettings(sl()));
  sl.registerFactory(
    () => SettingsBloc(getAppSettings: sl(), saveAppSettings: sl()),
  );

  // Prayer Feature
  sl.registerLazySingleton<PrayerLocalDataSource>(
    () => PrayerLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<PrayerRepository>(
    () => PrayerRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetPrayerSchedule(sl()));
  sl.registerFactory(() => PrayerBloc(getPrayerSchedule: sl()));
}
