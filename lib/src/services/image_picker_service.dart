import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Thin wrapper around [ImagePicker] for gallery and camera access.
class ImagePickerService {
  ImagePickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Opens the device gallery and returns the picked file, or null if cancelled.
  Future<File?> pickFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }

  /// Opens the device camera and returns the captured file, or null if cancelled.
  Future<File?> pickFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final xFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }
}
