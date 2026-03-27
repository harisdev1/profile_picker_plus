import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import '../models/profile_picker_theme.dart';
import '../models/profile_picker_strings.dart';

/// Wraps [ImageCropper] (v9.x) for avatar cropping with full theming support.
///
/// image_cropper 9.x uses:
///   - [AndroidUiSettings] for Android (uCrop)
///   - [IOSUiSettings] for iOS (TOCropViewController)
///   - [WebUiSettings] for Flutter Web (cropperjs)
class ImageCropperService {
  ImageCropperService({ImageCropper? cropper})
      : _cropper = cropper ?? ImageCropper();

  final ImageCropper _cropper;

  /// Launches the native crop UI for [sourceFile].
  ///
  /// Returns the cropped [File], or null if the user cancelled.
  Future<File?> crop({
    required File sourceFile,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset> presets = const [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
      CropAspectRatioPreset.original,
    ],
    ProfilePickerTheme theme = const ProfilePickerTheme(),
    ProfilePickerStrings strings = const ProfilePickerStrings(),
    BuildContext? context,
  }) async {
    final toolbarColor =
        theme.cropToolbarColor ?? theme.primaryColor;
    final toolbarTitleColor =
        theme.cropToolbarTitleColor ?? Colors.white;
    final activeColor =
        theme.cropActiveControlsWidgetColor ?? theme.primaryColor;

    final croppedFile = await _cropper.cropImage(
      sourcePath: sourceFile.path,
      aspectRatio: aspectRatio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: strings.cropTitle,
          toolbarColor: toolbarColor,
          toolbarWidgetColor: toolbarTitleColor,
          activeControlsWidgetColor: activeColor,
          backgroundColor: Colors.black,
          dimmedLayerColor: Colors.black54,
          cropFrameColor: activeColor,
          cropGridColor: activeColor.withOpacity(0.4),
          showCropGrid: true,
          lockAspectRatio: aspectRatio != null,
          hideBottomControls: false,
          aspectRatioPresets: presets,
          initAspectRatio: aspectRatio != null
              ? CropAspectRatioPreset.square
              : CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          title: strings.cropTitle,
          cancelButtonTitle: strings.cancelLabel,
          doneButtonTitle: 'Done',
          aspectRatioLockEnabled: aspectRatio != null,
          resetAspectRatioEnabled: aspectRatio == null,
          aspectRatioPickerButtonHidden: aspectRatio != null,
          rotateButtonsHidden: false,
          rotateClockwiseButtonHidden: false,
          hidesNavigationBar: true,
          aspectRatioPresets: presets
        ),
        if (context != null)
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(width: 520, height: 520),
          ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }
}
