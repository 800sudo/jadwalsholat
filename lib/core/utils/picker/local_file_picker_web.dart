// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

Future<String?> pickImageFileAsBase64() {
  final completer = Completer<String?>();
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((event) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((loadEvent) {
        final result = reader.result;
        if (result is String && result.isNotEmpty) {
          completer.complete(result);
        } else {
          completer.complete(null);
        }
      });
      reader.onError.listen((errorEvent) {
        completer.completeError('Gagal membaca berkas: $errorEvent');
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}
