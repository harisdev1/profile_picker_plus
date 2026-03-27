/// Localizable strings used throughout profile_picker_plus UI.
///
/// Override any field to customize or translate the UI labels.
///
/// ```dart
/// ProfilePicker(
///   pickerStrings: ProfilePickerStrings(
///     galleryLabel: 'Photo Library',
///     cameraLabel: 'Take Selfie',
///   ),
/// )
/// ```
class ProfilePickerStrings {
  const ProfilePickerStrings({
    this.pickerTitle = 'Profile Photo',
    this.galleryLabel = 'Choose from Gallery',
    this.cameraLabel = 'Take a Photo',
    this.removeLabel = 'Remove Photo',
    this.cancelLabel = 'Cancel',
    this.cropTitle = 'Crop Image',
    this.permissionDeniedMessage =
        'Permission denied. Please allow access in Settings.',
    this.openSettingsLabel = 'Open Settings',
    this.fileTooLargeMessage = 'Image exceeds the maximum allowed file size.',
  });

  /// Title shown at the top of the picker sheet or dialog.
  final String pickerTitle;

  /// Label for the gallery / photo library option.
  final String galleryLabel;

  /// Label for the camera capture option.
  final String cameraLabel;

  /// Label for the remove photo option.
  final String removeLabel;

  /// Label for the cancel/dismiss button.
  final String cancelLabel;

  /// Title shown in the crop screen toolbar.
  final String cropTitle;

  /// Message shown when camera or gallery permission is denied.
  final String permissionDeniedMessage;

  /// Label for the button that opens app Settings when permission is denied.
  final String openSettingsLabel;

  /// Message shown when the selected image exceeds [ProfilePicker.maxFileSizeKB].
  final String fileTooLargeMessage;

  /// Returns a copy with any overridden fields.
  ProfilePickerStrings copyWith({
    String? pickerTitle,
    String? galleryLabel,
    String? cameraLabel,
    String? removeLabel,
    String? cancelLabel,
    String? cropTitle,
    String? permissionDeniedMessage,
    String? openSettingsLabel,
    String? fileTooLargeMessage,
  }) {
    return ProfilePickerStrings(
      pickerTitle: pickerTitle ?? this.pickerTitle,
      galleryLabel: galleryLabel ?? this.galleryLabel,
      cameraLabel: cameraLabel ?? this.cameraLabel,
      removeLabel: removeLabel ?? this.removeLabel,
      cancelLabel: cancelLabel ?? this.cancelLabel,
      cropTitle: cropTitle ?? this.cropTitle,
      permissionDeniedMessage:
          permissionDeniedMessage ?? this.permissionDeniedMessage,
      openSettingsLabel: openSettingsLabel ?? this.openSettingsLabel,
      fileTooLargeMessage: fileTooLargeMessage ?? this.fileTooLargeMessage,
    );
  }
}
