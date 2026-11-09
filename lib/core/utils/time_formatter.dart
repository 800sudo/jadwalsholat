import 'package:intl/intl.dart';

class TimeFormatter {
  TimeFormatter._();

  static const List<String> dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jum\'at',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  /// Format jam 24 jam HH:mm (contoh: 04:32)
  static String formatHHmm(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format jam 24 jam HH:mm:ss (contoh: 04:32:15)
  static String formatHHmmss(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  /// Format tanggal Masehi Indonesia: "Jum'at, 6 November 2026"
  static String formatFullDate(DateTime dateTime) {
    final String day = dayNames[dateTime.weekday - 1];
    final String month = monthNames[dateTime.month - 1];
    return '$day, ${dateTime.day} $month ${dateTime.year}';
  }

  /// Format durasi hitung mundur (countdown): "02:45:10" atau "08:30"
  static String formatCountdown(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    final String mStr = minutes.toString().padLeft(2, '0');
    final String sStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final String hStr = hours.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    }
    return '$mStr:$sStr';
  }
}
