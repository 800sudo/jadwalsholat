import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/injection_container.dart';
import 'features/prayer/presentation/bloc/prayer_bloc.dart';
import 'features/prayer/presentation/bloc/prayer_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci orientasi ke landscape untuk Smart TV (16:9 1080p)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Mode Fullscreen Immersive untuk Digital Signage TV
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Inisialisasi Dependency Injection & Local Storage
  await initDependencies();

  runApp(const SmartTVPrayerApp());
}

class SmartTVPrayerApp extends StatelessWidget {
  const SmartTVPrayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) =>
              sl<SettingsBloc>()..add(const LoadSettingsEvent()),
        ),
        BlocProvider<PrayerBloc>(create: (context) => sl<PrayerBloc>()),
      ],
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            context.read<PrayerBloc>().add(
              InitPrayerScheduleEvent(state.settings),
            );
          }
        },
        child: MaterialApp.router(
          title: 'Jadwal Sholat Smart TV',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
