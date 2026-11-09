import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppImageHelper {
  AppImageHelper._();

  /// Menentukan apakah string merupakan Base64 Data URI
  static bool isBase64(String source) {
    return source.startsWith('data:image') || source.startsWith('base64:');
  }

  /// Menentukan apakah string merupakan URL Web
  static bool isNetworkUrl(String source) {
    return source.startsWith('http://') || source.startsWith('https://');
  }

  /// Decode Base64 string ke Uint8List bytes
  static Uint8List? decodeBase64(String source) {
    try {
      String base64String = source;
      if (source.contains(',')) {
        base64String = source.split(',').last;
      } else if (source.startsWith('base64:')) {
        base64String = source.substring(7);
      }
      return base64Decode(base64String.trim());
    } catch (_) {
      return null;
    }
  }

  /// Widget cerdas yang dapat menampilkan gambar dari URL, Base64 (Local File), atau Memory
  static Widget buildImage({
    required String imageSource,
    BoxFit fit = BoxFit.cover,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  }) {
    final cleanSource = imageSource.trim();
    if (cleanSource.isEmpty) {
      return const SizedBox.shrink();
    }

    if (cleanSource.startsWith('assets/')) {
      return Image.asset(
        cleanSource,
        fit: fit,
        errorBuilder:
            errorBuilder ??
            (context, error, stackTrace) => const SizedBox.shrink(),
      );
    }

    if (isBase64(cleanSource)) {
      final bytes = decodeBase64(cleanSource);
      if (bytes != null && bytes.isNotEmpty) {
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder:
              errorBuilder ??
              (context, error, stackTrace) => const SizedBox.shrink(),
        );
      }
    }

    if (isNetworkUrl(cleanSource)) {
      return Image.network(
        cleanSource,
        fit: fit,
        errorBuilder:
            errorBuilder ??
            (context, error, stackTrace) => const SizedBox.shrink(),
      );
    }

    return const SizedBox.shrink();
  }
}
