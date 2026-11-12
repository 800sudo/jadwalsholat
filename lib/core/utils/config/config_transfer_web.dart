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
    final currentUrl = html.window.location.href;
    final uri = Uri.parse(currentUrl);

    // 1. Cek query parameter ?config=...
    if (uri.queryParameters.containsKey('config')) {
      final param = uri.queryParameters['config'];
      if (param != null && param.trim().isNotEmpty) {
        return param.trim();
      }
    }

    // 2. Cek hash fragment (#config=..., #/config=..., #/?config=...)
    final hash = html.window.location.hash;
    if (hash.isNotEmpty) {
      if (hash.startsWith('#config=')) {
        return hash.substring('#config='.length).trim();
      } else if (hash.startsWith('#/config=')) {
        return hash.substring('#/config='.length).trim();
      } else if (hash.contains('config=')) {
        final idx = hash.indexOf('config=');
        return hash.substring(idx + 'config='.length).trim();
      }
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

void openWebUrlPlatform(String url) {
  try {
    html.window.open(url, '_blank');
  } catch (_) {}
}

Future<bool> copyToClipboardPlatform(String text) async {
  try {
    if (html.window.navigator.clipboard != null) {
      await html.window.navigator.clipboard!.writeText(text);
      return true;
    }
  } catch (_) {}
  try {
    final textarea = html.TextAreaElement()
      ..value = text
      ..style.position = 'fixed'
      ..style.opacity = '0';
    html.document.body?.append(textarea);
    textarea.focus();
    textarea.select();
    final res = html.document.execCommand('copy');
    textarea.remove();
    return res;
  } catch (_) {}
  return false;
}
