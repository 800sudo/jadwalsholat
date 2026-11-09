import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_image_helper.dart';

class MediaSliderWidget extends StatefulWidget {
  final List<Map<String, String>> slides;

  const MediaSliderWidget({
    super.key,
    this.slides = AppConstants.defaultSlides,
  });

  @override
  State<MediaSliderWidget> createState() => _MediaSliderWidgetState();
}

class _MediaSliderWidgetState extends State<MediaSliderWidget> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant MediaSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.slides.length != oldWidget.slides.length) {
      _currentIndex = 0;
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (mounted && widget.slides.isNotEmpty) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.slides.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    final safeIndex = _currentIndex < widget.slides.length ? _currentIndex : 0;
    final slide = widget.slides[safeIndex];
    final imageUrl = slide['imageUrl']?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    // Default 'fill' agar gambar langsung tampil FULL pada layout tanpa terpotong
    final fitMode = slide['imageFit'] ?? 'fill'; // 'fill', 'contain', 'cover'

    final title = slide['title']?.trim() ?? '';
    final subtitle = slide['subtitle']?.trim() ?? '';
    final badge = slide['badge']?.trim() ?? 'INFO MASJID';
    final hasText = title.isNotEmpty || subtitle.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceCardBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Layer Gambar
          if (hasImage) ...[
            if (fitMode == 'fill')
              // Mode Fill: Meregang memenuhi seluruh kotak tanpa terpotong
              Positioned.fill(
                child: AppImageHelper.buildImage(
                  imageSource: imageUrl,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              )
            else if (fitMode == 'cover')
              // Mode Cover: Zoom memenuhi kotak
              Positioned.fill(
                child: AppImageHelper.buildImage(
                  imageSource: imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              )
            else
              // Mode Default 'contain': Gambar 100% UTUH tanpa terpotong + Latar Ambient Blur
              Stack(
                fit: StackFit.expand,
                children: [
                  // Latar Ambient Blur dari warna gambar
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Opacity(
                        opacity: 0.5,
                        child: AppImageHelper.buildImage(
                          imageSource: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Gambar Utama UTUH di tengah tanpa ada bagian yang terpotong
                  Center(
                    child: AppImageHelper.buildImage(
                      imageSource: imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
          ] else ...[
            // Default Emerald Theme jika tidak ada gambar
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF072018),
                    Color(0xFF0B2C22),
                    Color(0xFF04150F),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                Icons.star_border_purple500,
                size: 240,
                color: AppColors.emeraldLight.withAlpha(15),
              ),
            ),
          ],

          // 2. Proteksi Kontras Teks (Gradasi lembut di bawah, gambar tetap terang benderang)
          if (hasText)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withAlpha(20),
                      Colors.transparent,
                      Colors.black.withAlpha(160),
                      Colors.black.withAlpha(220),
                    ],
                    stops: const [0.0, 0.35, 0.70, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

          // 3. Header: Badge & Dot Indicator
          Positioned(
            top: 16,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.goldPrimary.withAlpha(180),
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 8),
                    ],
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: AppColors.goldLight,
                    ),
                  ),
                ),
                // Page Dots
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(140),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: List.generate(widget.slides.length, (index) {
                      final isActive = index == safeIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.goldPrimary
                              : AppColors.textMuted.withAlpha(120),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Content: Judul & Hadits di bagian bawah secara rapi
          if (hasText)
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(safeIndex),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xCC04140E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.goldPrimary.withAlpha(100),
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title.isNotEmpty)
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldLight,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (title.isNotEmpty && subtitle.isNotEmpty)
                          const SizedBox(height: 4),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.35,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
