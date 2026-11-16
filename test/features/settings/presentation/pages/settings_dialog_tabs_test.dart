import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/constants/app_constants.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/entities/app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/repositories/settings_repository.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/usecases/get_app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/domain/usecases/save_app_settings.dart';
import 'package:jadwal_sholat_tv/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:jadwal_sholat_tv/features/settings/presentation/pages/settings_dialog.dart';

class MockSettingsRepo implements SettingsRepository {
  AppSettings currentSettings;
  MockSettingsRepo(this.currentSettings);

  @override
  Future<AppSettings> getSettings() async => currentSettings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    currentSettings = settings;
  }
}

void main() {
  testWidgets('SettingsDialog renders all 7 tabs and switches correctly',
      (tester) async {
    const settings = AppSettings(
      mosqueName: 'Masjid Agung Al-Falah',
      mosqueAddress: 'Jl. Merdeka No. 1',
      cityName: 'Indramayu',
      latitude: -6.3275,
      longitude: 108.3249,
      timezone: 7.0,
      ihtiyatMinutes: 2,
      runningText: 'Pengumuman DKM Masjid',
      iqomahSubuhMinutes: 12,
      iqomahDzuhurMinutes: 10,
      iqomahAsharMinutes: 10,
      iqomahMaghribMinutes: 7,
      iqomahIsyaMinutes: 10,
      hijriAdjustmentDays: 0,
      slides: AppConstants.defaultSlides,
      fridayKhutbahMinutes: 35,
      disableFridayIqomah: true,
      fridayKhotib: 'Ust. Khotib',
      fridayImam: 'Ust. Imam',
      fridayMuadzin: 'Ust. Muadzin',
      fridayBilal: 'Ust. Bilal',
      enableBeepSound: true,
    );

    final repo = MockSettingsRepo(settings);
    final bloc = SettingsBloc(
      getAppSettings: GetAppSettings(repo),
      saveAppSettings: SaveAppSettings(repo),
    );

    // Set screen size wide enough for TV dialog
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<SettingsBloc>.value(
            value: bloc,
            child: const SettingsDialog(currentSettings: settings),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 7 tabs are present in TabBar
    expect(find.text('Masjid'), findsOneWidget);
    expect(find.text('Waktu Jeda'), findsOneWidget);
    expect(find.text("Jum'at"), findsOneWidget);
    expect(find.text('Teks Berjalan'), findsOneWidget);
    expect(find.text('Slider'), findsOneWidget);
    expect(find.text('Uji Coba'), findsOneWidget);
    expect(find.text('Pencadangan'), findsOneWidget);

    // Initial tab is Masjid: check text
    expect(find.text('Masjid Agung Al-Falah'), findsOneWidget);

    // Tap Tab Waktu Jeda
    await tester.tap(find.text('Waktu Jeda'));
    await tester.pumpAndSettle();
    expect(find.text('Waktu Jeda Hitung Mundur Iqomah (Menit)'), findsOneWidget);

    // Tap Tab Jum'at
    await tester.tap(find.text("Jum'at"));
    await tester.pumpAndSettle();
    expect(find.text("Pengaturan Khusus Hari Jum'at"), findsOneWidget);

    // Tap Tab Teks Berjalan
    await tester.tap(find.text('Teks Berjalan'));
    await tester.pumpAndSettle();
    expect(find.text('Teks Berjalan Informasi Bawah Layar (Running Text)'),
        findsOneWidget);

    // Tap Tab Slider
    await tester.tap(find.text('Slider'));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan Konten & Gambar Slider Poster'), findsOneWidget);

    // Tap Tab Uji Coba
    await tester.tap(find.text('Uji Coba'));
    await tester.pumpAndSettle();
    expect(find.text('Simulasi & Uji Coba Tampilan Layar Penuh'), findsOneWidget);

    // Tap Tab Pencadangan
    await tester.tap(find.text('Pencadangan'));
    await tester.pumpAndSettle();
    expect(
        find.text('Pencadangan & Transfer Pengaturan (Anti-Reset di TV)'),
        findsOneWidget);
  });
}
