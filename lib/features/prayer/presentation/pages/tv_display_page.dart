import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/audio/beep_sound_helper.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../../../settings/presentation/pages/settings_dialog.dart';
import '../../domain/entities/prayer_schedule.dart';
import '../bloc/prayer_bloc.dart';
import '../bloc/prayer_event.dart';
import '../bloc/prayer_state.dart';
import '../widgets/header_clock_widget.dart';
import '../widgets/iqomah_overlay_widget.dart';
import '../widgets/media_slider_widget.dart';
import '../widgets/next_prayer_countdown_widget.dart';
import '../widgets/prayer_time_cards_widget.dart';
import '../widgets/running_text_widget.dart';

class TVDisplayPage extends StatefulWidget {
  const TVDisplayPage({super.key});

  @override
  State<TVDisplayPage> createState() => _TVDisplayPageState();
}

class _TVDisplayPageState extends State<TVDisplayPage> {
  final FocusNode _mainFocusNode = FocusNode();
  TVDisplayMode? _manualPreviewMode;
  TVDisplayMode? _lastTriggeredBeepMode;

  @override
  void initState() {
    super.initState();
    // Request initial focus for TV Remote D-Pad navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mainFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  void _openSettings(AppSettings settings) async {
    final updated = await showDialog<AppSettings>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SettingsDialog(
        currentSettings: settings,
        onPreviewMode: (mode) {
          setState(() {
            _manualPreviewMode = mode;
          });
        },
      ),
    );

    if (updated != null && mounted) {
      context.read<PrayerBloc>().add(SettingsChangedEvent(updated));
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    BeepSoundHelper.initUserInteraction();
    if (event is KeyDownEvent) {
      // Tombol Escape / Back untuk keluar dari mode peringatan
      if (event.logicalKey == LogicalKeyboardKey.escape ||
          event.logicalKey == LogicalKeyboardKey.goBack) {
        if (_manualPreviewMode != null) {
          setState(() => _manualPreviewMode = null);
          return KeyEventResult.handled;
        }
      }

      // Remote control keys: Select / Enter / Menu / D-Pad Center
      if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.gameButtonSelect ||
          event.logicalKey == LogicalKeyboardKey.contextMenu) {
        if (_manualPreviewMode != null) {
          setState(() => _manualPreviewMode = null);
          return KeyEventResult.handled;
        }
        final settingsState = context.read<SettingsBloc>().state;
        if (settingsState is SettingsLoaded) {
          _openSettings(settingsState.settings);
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  List<Map<String, String>> _resolveSlides(
    AppSettings settings,
    DateTime currentTime,
  ) {
    final baseSlides = settings.slides.isNotEmpty
        ? settings.slides
        : AppConstants.defaultSlides;

    if (currentTime.weekday == DateTime.friday) {
      final khotib = settings.fridayKhotib.trim();
      final imam = settings.fridayImam.trim();
      final muadzin = settings.fridayMuadzin.trim();
      final bilal = settings.fridayBilal.trim();

      if (khotib.isNotEmpty || imam.isNotEmpty) {
        final petugasSlide = {
          'title': 'Petugas Sholat Jum\'at',
          'subtitle':
              'Khotib: $khotib • Imam: $imam'
              '${muadzin.isNotEmpty ? ' • Muadzin: $muadzin' : ''}'
              '${bilal.isNotEmpty ? ' • Bilal: $bilal' : ''}',
          'badge': 'JUM\'AT BERKAH',
          'imageUrl': 'assets/images/masjid_nabawi.png',
          'imageFit': 'fill',
        };
        return [petugasSlide, ...baseSlides];
      }
    }
    return baseSlides;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState is! SettingsLoaded) {
          return const Scaffold(
            backgroundColor: AppColors.bgDarkStart,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.goldPrimary),
            ),
          );
        }

        final settings = settingsState.settings;

        return BlocBuilder<PrayerBloc, PrayerState>(
          builder: (context, prayerState) {
            if (prayerState is! PrayerLoaded) {
              return const Scaffold(
                backgroundColor: AppColors.bgDarkStart,
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.goldPrimary,
                  ),
                ),
              );
            }

            final schedule = prayerState.schedule;
            final currentTime = prayerState.currentTime;

            // Trigger suara beep 3 kali saat mau adzan atau mau sholat (kecuali Jum'at)
            final currentMode = schedule.displayMode;
            if (_lastTriggeredBeepMode != currentMode) {
              if (settings.enableBeepSound) {
                final isFridayDzuhur =
                    (schedule.activePrayer?.name == PrayerName.dzuhur) &&
                    (currentTime.weekday == DateTime.friday);

                if (currentMode == TVDisplayMode.adzanAlert) {
                  if (!isFridayDzuhur) {
                    BeepSoundHelper.playTripleBeep();
                  }
                } else if (currentMode == TVDisplayMode.prayingTime) {
                  if (!isFridayDzuhur) {
                    BeepSoundHelper.playTripleBeep();
                  }
                }
              }
              _lastTriggeredBeepMode = currentMode;
            }

            return Focus(
              focusNode: _mainFocusNode,
              autofocus: true,
              onKeyEvent: _handleKeyEvent,
              child: Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.bgDarkStart,
                        AppColors.bgDarkMid,
                        AppColors.bgDarkEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Subtle Background Mosque Pattern Watermark
                      Positioned(
                        left: -50,
                        top: -50,
                        child: Icon(
                          Icons.mosque,
                          size: 380,
                          color: AppColors.goldPrimary.withAlpha(8),
                        ),
                      ),
                      Positioned(
                        right: -50,
                        bottom: 0,
                        child: Icon(
                          Icons.auto_awesome,
                          size: 320,
                          color: AppColors.emeraldLight.withAlpha(8),
                        ),
                      ),

                      // Main UI Content in 16:9 Landscape Safe Area
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 1. Header (Mosque Name, Date, Clock)
                              HeaderClockWidget(
                                currentTime: currentTime,
                                settings: settings,
                                onOpenSettings: () => _openSettings(settings),
                              ),
                              const SizedBox(height: 14),

                              // 2. Middle Section (Slide Info & Next Prayer Countdown, rasio 6:4)
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    // Left: Announcement / Hadith Slider (Flex 6)
                                    Expanded(
                                      flex: 6,
                                      child: MediaSliderWidget(
                                        slides: _resolveSlides(
                                          settings,
                                          currentTime,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Right: Next Prayer Countdown (Flex 4)
                                    Expanded(
                                      flex: 4,
                                      child: NextPrayerCountdownWidget(
                                        nextPrayer: schedule.nextPrayer,
                                        timeUntilNext: schedule.timeUntilNext,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // 3. Bottom Prayer Times Cards Row
                              PrayerTimeCardsWidget(
                                items: schedule.items,
                                activePrayer: schedule.activePrayer,
                                nextPrayer: schedule.nextPrayer,
                              ),
                              const SizedBox(height: 12),

                              // 4. Running Text Marquee
                              RunningTextWidget(text: settings.runningText),
                            ],
                          ),
                        ),
                      ),

                      // 5. Adzan / Iqomah / Sholat Overlay (if active or previewed)
                      if ((_manualPreviewMode ?? schedule.displayMode) !=
                          TVDisplayMode.normal)
                        Positioned.fill(
                          child: Stack(
                            children: [
                              IqomahOverlayWidget(
                                displayMode:
                                    _manualPreviewMode ?? schedule.displayMode,
                                activePrayer:
                                    schedule.activePrayer ?? schedule.items[3],
                                iqomahRemaining:
                                    schedule.iqomahRemaining > Duration.zero
                                    ? schedule.iqomahRemaining
                                    : const Duration(minutes: 8, seconds: 45),
                                settings: settings,
                              ),
                              // Close / Dismiss button
                              Positioned(
                                top: 20,
                                right: 24,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _manualPreviewMode = null;
                                    });
                                  },
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text(
                                    'Tutup / Kembali ke Jadwal',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.alertRed
                                        .withAlpha(220),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
