// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

Future<void> downloadConfigFile(String jsonString, String filename) async {
  final bytes = utf8.encode(jsonString);
  final blob = html.Blob([bytes], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<String?> pickConfigFile() {
  final completer = Completer<String?>();
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = '.json,application/json';
  uploadInput.click();

  uploadInput.onChange.listen((event) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      reader.readAsText(file);
      reader.onLoadEnd.listen((loadEvent) {
        final result = reader.result;
        if (result is String && result.isNotEmpty) {
          completer.complete(result);
        } else {
          completer.complete(null);
        }
      });
      reader.onError.listen((errorEvent) {
        completer.completeError('Gagal membaca file konfigurasi: $errorEvent');
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}

String? getUrlConfigParameter() {
  try {
    // 1. Cek query parameter ?config=...
    final uri = Uri.parse(html.window.location.href);
    if (uri.queryParameters.containsKey('config')) {
      return uri.queryParameters['config'];
    }
    // 2. Cek hash fragment #config=... atau #/config=...
    final hash = html.window.location.hash;
    if (hash.startsWith('#config=')) {
      return hash.substring('#config='.length);
    } else if (hash.startsWith('#/config=')) {
      return hash.substring('#/config='.length);
    }
  } catch (_) {}
  return null;
}

String getBaseWebUrl() {
  try {
    return '${html.window.location.protocol}//${html.window.location.host}${html.window.location.pathname}';
  } catch (_) {
    return 'https://jadwal-sholat-ecru.vercel.app/';
  }
}
