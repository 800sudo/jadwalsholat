import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RunningTextWidget extends StatefulWidget {
  final String text;
  final double speed; // pixels per second

  const RunningTextWidget({super.key, required this.text, this.speed = 35.0});

  @override
  State<RunningTextWidget> createState() => _RunningTextWidgetState();
}

class _RunningTextWidgetState extends State<RunningTextWidget> {
  late final ScrollController _scrollController;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted || !_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final delta = widget.speed * (30 / 1000);

      if (currentScroll >= maxScroll) {
        _scrollController.jumpTo(0.0);
      } else {
        _scrollController.jumpTo(currentScroll + delta);
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.marqueeBg,
        border: Border.all(color: AppColors.marqueeBorder, width: 1.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Left Fixed Icon Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.goldPrimary, AppColors.goldDeep],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.campaign_rounded,
                  size: 20,
                  color: AppColors.textDark,
                ),
                SizedBox(width: 6),
                Text(
                  'INFORMASI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          // Scrolling Marquee Area
          Expanded(
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(width: 24),
                Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 80),
                Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
