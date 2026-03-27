import 'dart:io';
import 'package:flutter/foundation.dart';

/// A lightweight controller that drives [ProfilePicker] programmatically.
///
/// Attach via `controller:` and call [open], [close], [clearImage], or
/// [setImage] from anywhere in the widget tree.
///
/// Always call [dispose] in the parent widget's `dispose()` method.
///
/// ```dart
/// final _controller = ProfilePickerController();
///
/// ProfilePicker(
///   controller: _controller,
///   triggerMode: ProfileTriggerMode.none,
///   badgeLayoutMode: BadgeLayoutMode.none,
///   onImageSelected: (file) => _handleImage(file),
/// ),
/// ElevatedButton(
///   onPressed: () => _controller.open(),
///   child: const Text('Change Photo'),
/// ),
/// ```
class ProfilePickerController extends ChangeNotifier {
  // ─── Internal state ─────────────────────────────────────────
  bool _isOpen = false;
  File? _currentFile;
  bool _pendingOpen = false;

  // Internal callbacks set by the widget when it mounts.
  VoidCallback? _openCallback;
  VoidCallback? _closeCallback;
  void Function(File?)? _setImageCallback;

  // ─── Public API ─────────────────────────────────────────────

  /// Whether the picker sheet or dialog is currently visible.
  bool get isOpen => _isOpen;

  /// Whether an image is currently selected.
  bool get hasImage => _currentFile != null;

  /// The currently selected [File], or null.
  File? get currentFile => _currentFile;

  /// Programmatically open the picker.
  /// Safe to call before the widget is built; the open will be queued.
  void open() {
    if (_openCallback != null) {
      _openCallback!();
    } else {
      _pendingOpen = true;
    }
  }

  /// Programmatically dismiss the picker.
  void close() {
    _closeCallback?.call();
  }

  /// Remove the current image and trigger [ProfilePicker.onImageSelected](null).
  void clearImage() {
    _setImageCallback?.call(null);
  }

  /// Set an image programmatically without going through the picker UI.
  /// Triggers [ProfilePicker.onImageSelected] with the provided file.
  void setImage(File file) {
    _setImageCallback?.call(file);
  }

  // ─── Internal methods called by ProfilePicker ─────────────────

  void attach({
    required VoidCallback openCallback,
    required VoidCallback closeCallback,
    required void Function(File?) setImageCallback,
  }) {
    _openCallback = openCallback;
    _closeCallback = closeCallback;
    _setImageCallback = setImageCallback;
    if (_pendingOpen) {
      _pendingOpen = false;
      openCallback();
    }
  }

  void detach() {
    _openCallback = null;
    _closeCallback = null;
    _setImageCallback = null;
  }

  void notifyOpenState(bool isOpen) {
    _isOpen = isOpen;
    notifyListeners();
  }

  void notifyImageChange(File? file) {
    _currentFile = file;
    notifyListeners();
  }

  @override
  void dispose() {
    detach();
    super.dispose();
  }
}
