/// Controls which gesture on the avatar widget opens the picker.
enum ProfileTriggerMode {
  /// Single tap opens the picker (default).
  onTap,

  /// Long press opens the picker.
  onLongPress,

  /// Double tap opens the picker.
  onDoubleTap,

  /// No gesture triggers the picker. Use [ProfilePickerController.open()] or
  /// the [ProfilePicker.child] builder to trigger it programmatically.
  none,
}
