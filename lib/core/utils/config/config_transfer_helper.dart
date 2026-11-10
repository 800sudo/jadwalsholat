import 'dart:convert';
import '../../../features/settings/data/models/app_settings_model.dart';
import '../../../features/settings/domain/entities/app_settings.dart';

import 'config_transfer_stub.dart'
    if (dart.library.html) 'config_transfer_web.dart'
    if (dart.library.io) 'config_transfer_io.dart';

class ConfigTransferHelper {
  ConfigTransferHelper._();

  /// Mengonversi AppSettings menjadi string JSON yang rapi (pretty printed)
  static String exportToJson(AppSettings settings) {
    final model = AppSettingsModel.fromEntity(settings);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(model.toJson());
  }

  /// Mem-parsing string JSON menjadi AppSettings
  static AppSettings? importFromJson(String rawJson) {
    try {
      final trimmed = rawJson.trim();
      if (trimmed.isEmpty) return null;
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        return AppSettingsModel.fromJson(decoded);
      } else if (decoded is Map) {
        return AppSettingsModel.fromJson(
          Map<String, dynamic>.from(decoded),
        );
      }
    } catch (_) {}
    return null;
  }

  /// Mengunduh / Menyimpan file JSON konfigurasi
  static Future<void> downloadJsonFile(
    AppSettings settings, {
    String filename = 'pengaturan_jadwal_sholat.json',
  }) async {
    final jsonContent = exportToJson(settings);
    await downloadConfigFile(jsonContent, filename);
  }

  /// Membuka file explorer / file picker untuk memilih berkas JSON
  static Future<AppSettings?> pickAndLoadJsonFile() async {
    final content = await pickConfigFile();
    if (content == null || content.trim().isEmpty) return null;
    return importFromJson(content);
  }

  /// Membuat URL TV Permanen (dengan config Base64 di URL hash)
  static String generatePermanentTvUrl(
    AppSettings settings, {
    String? customBaseUrl,
  }) {
    final model = AppSettingsModel.fromEntity(settings);
    final compactJson = jsonEncode(model.toJson());
    final base64Config = base64Url.encode(utf8.encode(compactJson));
    final base = customBaseUrl ?? getBaseWebUrl();
    final cleanBase = base.split('#')[0].split('?')[0];
    return '$cleanBase#config=$base64Config';
  }

  /// Membaca konfigurasi dari parameter URL saat web pertama kali dibuka
  static AppSettings? loadSettingsFromUrl() {
    try {
      final rawParam = getUrlConfigParameter();
      if (rawParam == null || rawParam.isEmpty) return null;
      final normalized = base64Url.normalize(rawParam);
      final decodedBytes = base64Url.decode(normalized);
      final decodedString = utf8.decode(decodedBytes);
      return importFromJson(decodedString);
    } catch (_) {
      return null;
    }
  }
}

