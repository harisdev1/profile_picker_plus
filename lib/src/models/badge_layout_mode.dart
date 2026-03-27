/// Controls how the edit badge is rendered relative to the avatar.
enum BadgeLayoutMode {
  /// Badge is placed via a Stack+Positioned inside the widget (default).
  stack,

  /// Badge is rendered via Flutter Overlay, floating above all other widgets.
  /// Useful when the avatar is inside a clipping widget.
  overlay,

  /// No badge is rendered. Use a custom trigger ([ProfilePicker.child] or
  /// [ProfilePickerController.open]) to open the picker.
  none,
}
