import 'dart:async';
import 'dart:io';

Future<void> downloadConfigFile(String jsonString, String filename) async {
  // Coba simpan ke direktori Download atau Documents
  try {
    final candidateDirs = [
      Directory('/storage/emulated/0/Download'),
      Directory('/storage/emulated/0/Documents'),
      Directory('.'),
    ];
    for (final dir in candidateDirs) {
      if (await dir.exists()) {
        final file = File('${dir.path}/$filename');
        await file.writeAsString(jsonString);
        return;
      }
    }
  } catch (_) {}
}

Future<String?> pickConfigFile() async {
  try {
    final candidates = [
      '/storage/emulated/0/Download/pengaturan_jadwal_sholat.json',
      '/storage/emulated/0/pengaturan_jadwal_sholat.json',
      '/storage/emulated/0/Download/jadwal_sholat_config.json',
      '/storage/emulated/0/jadwal_sholat_config.json',
      'pengaturan_jadwal_sholat.json',
    ];
    for (final path in candidates) {
      final f = File(path);
      if (await f.exists()) {
        return await f.readAsString();
      }
    }
  } catch (_) {}
  return null;
}

String? getUrlConfigParameter() => null;

String getBaseWebUrl() => 'https://jadwal-sholat-ecru.vercel.app/';

