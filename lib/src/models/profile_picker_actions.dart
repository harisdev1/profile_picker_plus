/// Callback actions passed to [ProfilePicker.pickerBuilder] so a fully custom
/// sheet or dialog UI can still trigger the package's internal pick/crop pipeline.
class ProfilePickerActions {
  const ProfilePickerActions({
    required this.pickFromGallery,
    required this.pickFromCamera,
    required this.removeImage,
    required this.dismiss,
  });

  /// Trigger the gallery image picker + crop flow.
  final Future<void> Function() pickFromGallery;

  /// Trigger the camera capture + crop flow.
  final Future<void> Function() pickFromCamera;

  /// Clear the current image (calls [ProfilePicker.onImageSelected] with null).
  final void Function() removeImage;

  /// Dismiss the bottom sheet or dialog.
  final void Function() dismiss;
}
