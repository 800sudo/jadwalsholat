import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jadwal_sholat_tv/core/utils/app_image_helper.dart';

void main() {
  group('AppImageHelper', () {
    test('isBase64 mendeteksi format data URI dan base64 dengan benar', () {
      expect(
        AppImageHelper.isBase64('data:image/png;base64,iVBORw0KGgoAAA'),
        isTrue,
      );
      expect(AppImageHelper.isBase64('base64:iVBORw0KGgoAAA'), isTrue);
      expect(
        AppImageHelper.isBase64('https://example.com/masjid.png'),
        isFalse,
      );
    });

    test('isNetworkUrl mendeteksi protokol http dan https', () {
      expect(
        AppImageHelper.isNetworkUrl('https://example.com/masjid.png'),
        isTrue,
      );
      expect(
        AppImageHelper.isNetworkUrl('http://192.168.1.10/foto.jpg'),
        isTrue,
      );
      expect(AppImageHelper.isNetworkUrl('data:image/png;base64,123'), isFalse);
    });

    test('buildImage mendukung asset lokal', () {
      final widget = AppImageHelper.buildImage(
        imageSource: 'assets/images/masjid_nabawi.png',
      );
      expect(widget, isA<Image>());
    });

    test('decodeBase64 berhasil menguraikan bytes dari string', () {
      const rawText = 'Antigravity TV';
      final base64Str =
          'data:image/png;base64,${base64Encode(utf8.encode(rawText))}';
      final bytes = AppImageHelper.decodeBase64(base64Str);

      expect(bytes, isNotNull);
      expect(utf8.decode(bytes!), equals(rawText));
    });
  });
}
