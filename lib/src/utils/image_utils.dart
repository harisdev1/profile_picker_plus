import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Utility functions for image compression and file-size validation.
class ImageUtils {
  ImageUtils._();

  /// Compresses [file] to [quality] (0–100) using flutter_image_compress.
  /// Returns the compressed [File]. Falls back to the original on failure.
  static Future<File> compress(File file, {int quality = 85}) async {
    if (quality >= 100) return file;
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.parent.path}/profile_picker_plus_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (result == null) return file;
      return File(result.path);
    } catch (_) {
      return file;
    }
  }

  /// Returns the file size in kilobytes.
  static Future<double> fileSizeKB(File file) async {
    final bytes = await file.length();
    return bytes / 1024;
  }

  /// Returns true if [file] exceeds [maxKB].
  static Future<bool> exceedsMaxSize(File file, int maxKB) async {
    final kb = await fileSizeKB(file);
    return kb > maxKB;
  }
}
