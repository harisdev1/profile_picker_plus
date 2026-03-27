import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../models/profile_picker_theme.dart';
import '../models/profile_picker_strings.dart';
import '../models/profile_picker_mode.dart';
import '../models/badge_position.dart';
import '../models/badge_layout_mode.dart';
import '../models/profile_trigger_mode.dart';
import '../models/profile_picker_controller.dart';
import '../models/profile_picker_actions.dart';
import '../models/option_type.dart';
import '../services/image_picker_service.dart';
import '../services/image_cropper_service.dart';
import '../services/permission_service.dart';
import '../utils/image_utils.dart';
import '../provider/profile_picker_theme_provider.dart';
import 'profile_display.dart';
import 'picker_bottom_sheet.dart';
import 'picker_dialog.dart';

/// Typedef for the child builder pattern.
///
/// Receives a [BuildContext] and an `open` callback to trigger the picker.
/// ```dart
/// ProfilePicker(
///   child: (context, open) => ElevatedButton(onPressed: open, child: Text('Pick')),
/// )
/// ```
typedef ProfilePickerBuilder = Widget Function(
    BuildContext context, VoidCallback open);

/// Typedef for a fully custom picker sheet/dialog content builder.
typedef ProfilePickerSheetBuilder = Widget Function(
    BuildContext context, ProfilePickerActions actions);

/// Typedef for overriding individual option tiles.
typedef ProfileOptionBuilder = Widget? Function(
    OptionType type, VoidCallback action);

/// The main profile_picker_plus widget.
///
/// Renders an avatar with an edit badge. Tapping (or using the [controller])
/// opens a source-selection UI (bottom sheet or dialog) and runs the
/// pick → crop → compress pipeline. Calls [onImageSelected] with the
/// resulting [File], or null when the photo is removed.
///
/// ## Minimal usage
/// ```dart
/// ProfilePicker(
///   fallbackInitials: 'AK',
///   onImageSelected: (file) => setState(() => _photo = file),
/// )
/// ```
///
/// ## Fully customized
/// ```dart
/// ProfilePicker(
///   radius: 60,
///   pickerMode: ProfilePickerMode.dialog,
///   cropAspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
///   allowRemove: true,
///   compressionQuality: 75,
///   fallbackInitials: 'JD',
///   badgePosition: BadgePosition.bottomRight,
///   theme: ProfilePickerTheme(primaryColor: Colors.teal, sheetBorderRadius: 24),
///   onImageSelected: (file) => _handleImage(file),
/// )
/// ```
class ProfilePicker extends StatefulWidget {
  const ProfilePicker({
    super.key,
    // Core callbacks
    required this.onImageSelected,
    this.onTap,
    this.onPermissionDenied,

    // Initial image
    this.initialImageUrl,
    this.initialImageFile,
    this.initialImageBytes,

    // Sizing & shape
    this.radius = 48.0,
    this.shape,

    // Picker config
    this.pickerMode = ProfilePickerMode.bottomSheet,
    this.cropEnabled = true,
    this.cropAspectRatio,
    this.allowGallery = true,
    this.allowCamera = true,
    this.allowRemove = false,
    this.compressionQuality = 85,
    this.maxFileSizeKB,

    // Fallback display
    this.fallbackInitials,
    this.initialsStyle,
    this.initialsBackgroundColor,
    this.placeholder,

    // Badge
    this.badgeWidget,
    this.badgePosition = BadgePosition.bottomRight,
    this.badgeAlignment,
    this.badgeOffset,
    this.badgeInside = false,
    this.badgeLayoutMode = BadgeLayoutMode.stack,
    this.badgeVisible = true,

    // Trigger
    this.triggerMode = ProfileTriggerMode.onTap,
    this.controller,
    this.child,

    // Custom builders
    this.pickerBuilder,
    this.optionBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.sheetDragHandleBuilder,
    this.dividerBuilder,

    // Theme & strings
    this.theme,
    this.pickerStrings,

    // Loading
    this.loadingWidget,

    // State
    this.enabled = true,
  });

  // ─── Callbacks ────────────────────────────────────────────────
  /// Called when the user picks and crops an image. Null when photo removed.
  final void Function(File? file) onImageSelected;

  /// Additional tap callback (e.g. for analytics).
  final VoidCallback? onTap;

  /// Called when camera or gallery permission is denied.
  final void Function(BuildContext context)? onPermissionDenied;

  // ─── Initial image ────────────────────────────────────────────
  final String? initialImageUrl;
  final File? initialImageFile;
  final Uint8List? initialImageBytes;

  // ─── Sizing & shape ───────────────────────────────────────────
  final double radius;
  final ShapeBorder? shape;

  // ─── Picker config ────────────────────────────────────────────
  final ProfilePickerMode pickerMode;
  final bool cropEnabled;
  final CropAspectRatio? cropAspectRatio;
  final bool allowGallery;
  final bool allowCamera;
  final bool allowRemove;
  final int compressionQuality;
  final int? maxFileSizeKB;

  // ─── Fallback display ─────────────────────────────────────────
  final String? fallbackInitials;
  final TextStyle? initialsStyle;
  final Color? initialsBackgroundColor;
  final Widget? placeholder;

  // ─── Badge ────────────────────────────────────────────────────
  final Widget? badgeWidget;
  final BadgePosition badgePosition;
  final Alignment? badgeAlignment;
  final Offset? badgeOffset;
  final bool badgeInside;
  final BadgeLayoutMode badgeLayoutMode;
  final bool badgeVisible;

  // ─── Trigger ──────────────────────────────────────────────────
  final ProfileTriggerMode triggerMode;
  final ProfilePickerController? controller;
  final ProfilePickerBuilder? child;

  // ─── Custom builders ──────────────────────────────────────────
  final ProfilePickerSheetBuilder? pickerBuilder;
  final ProfileOptionBuilder? optionBuilder;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final WidgetBuilder? sheetDragHandleBuilder;
  final WidgetBuilder? dividerBuilder;

  // ─── Theme & strings ──────────────────────────────────────────
  final ProfilePickerTheme? theme;
  final ProfilePickerStrings? pickerStrings;

  // ─── Loading ──────────────────────────────────────────────────
  final Widget? loadingWidget;

  // ─── State ────────────────────────────────────────────────────
  final bool enabled;

  @override
  State<ProfilePicker> createState() => _ProfilePickerState();
}

class _ProfilePickerState extends State<ProfilePicker> {
  final _pickerService = ImagePickerService();
  final _cropperService = ImageCropperService();
  final _permissionService = PermissionService();

  File? _currentFile;
  String? _currentUrl;
  Uint8List? _currentBytes;
  bool _loading = false;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _currentFile = widget.initialImageFile;
    _currentUrl = widget.initialImageUrl;
    _currentBytes = widget.initialImageBytes;

    widget.controller?.attach(
      openCallback: _openPicker,
      closeCallback: _closePicker,
      setImageCallback: _setImageFromController,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    widget.controller?.detach();
    super.dispose();
  }

  // ─── Controller integration ───────────────────────────────────

  void _setImageFromController(File? file) {
    setState(() => _currentFile = file);
    widget.onImageSelected(file);
    widget.controller?.notifyImageChange(file);
  }

  void _closePicker() => Navigator.of(context, rootNavigator: true).maybePop();

  // ─── Core pick flow ───────────────────────────────────────────

  Future<void> _openPicker() async {
    if (!widget.enabled) return;
    widget.onTap?.call();
    widget.controller?.notifyOpenState(true);

    final t = _resolvedTheme;
    final s = widget.pickerStrings ?? const ProfilePickerStrings();

    final actions = ProfilePickerActions(
      pickFromGallery: _pickFromGallery,
      pickFromCamera: _pickFromCamera,
      removeImage: _removeImage,
      dismiss: _closePicker,
    );

    if (widget.pickerMode == ProfilePickerMode.bottomSheet) {
      await PickerBottomSheet.show(
        context: context,
        actions: actions,
        theme: t,
        strings: s,
        allowGallery: widget.allowGallery,
        allowCamera: widget.allowCamera,
        allowRemove: widget.allowRemove && _hasImage,
        headerBuilder: widget.headerBuilder,
        footerBuilder: widget.footerBuilder,
        optionBuilder: widget.optionBuilder,
        dividerBuilder: widget.dividerBuilder,
        dragHandleBuilder: widget.sheetDragHandleBuilder,
      );
    } else {
      await PickerDialog.show(
        context: context,
        actions: actions,
        theme: t,
        strings: s,
        allowGallery: widget.allowGallery,
        allowCamera: widget.allowCamera,
        allowRemove: widget.allowRemove && _hasImage,
        headerBuilder: widget.headerBuilder,
        footerBuilder: widget.footerBuilder,
        optionBuilder: widget.optionBuilder,
        dividerBuilder: widget.dividerBuilder,
      );
    }

    widget.controller?.notifyOpenState(false);
  }

  Future<void> _pickFromGallery() async {
    final granted = await _permissionService.requestGallery();
    if (!granted) {
      _handlePermissionDenied();
      return;
    }
    final file = await _pickerService.pickFromGallery();
    if (file == null) return;
    await _processFile(file);
  }

  Future<void> _pickFromCamera() async {
    final granted = await _permissionService.requestCamera();
    if (!granted) {
      _handlePermissionDenied();
      return;
    }
    final file = await _pickerService.pickFromCamera();
    if (file == null) return;
    await _processFile(file);
  }

  Future<void> _processFile(File file) async {
    setState(() => _loading = true);

    try {
      File result = file;

      // Crop
      if (widget.cropEnabled) {
        final cropped = await _cropperService.crop(
          sourceFile: result,
          aspectRatio: widget.cropAspectRatio,
          theme: _resolvedTheme,
          strings: widget.pickerStrings ?? const ProfilePickerStrings(),
          context: context,
        );
        if (cropped == null) {
          setState(() => _loading = false);
          return; // User cancelled crop
        }
        result = cropped;
      }

      // File size guard
      if (widget.maxFileSizeKB != null) {
        final tooLarge =
            await ImageUtils.exceedsMaxSize(result, widget.maxFileSizeKB!);
        if (tooLarge) {
          _showSizeError();
          setState(() => _loading = false);
          return;
        }
      }

      // Compression
      result =
          await ImageUtils.compress(result, quality: widget.compressionQuality);

      setState(() {
        _currentFile = result;
        _currentUrl = null;
        _currentBytes = null;
        _loading = false;
      });

      widget.onImageSelected(result);
      widget.controller?.notifyImageChange(result);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _removeImage() {
    setState(() {
      _currentFile = null;
      _currentUrl = null;
      _currentBytes = null;
    });
    widget.onImageSelected(null);
    widget.controller?.notifyImageChange(null);
  }

  void _handlePermissionDenied() {
    if (widget.onPermissionDenied != null) {
      widget.onPermissionDenied!(context);
    } else {
      _showDefaultPermissionDenied();
    }
  }

  void _showDefaultPermissionDenied() {
    final s = widget.pickerStrings ?? const ProfilePickerStrings();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s.permissionDeniedMessage),
        action: SnackBarAction(
          label: s.openSettingsLabel,
          onPressed: _permissionService.openSettings,
        ),
      ),
    );
  }

  void _showSizeError() {
    final s = widget.pickerStrings ?? const ProfilePickerStrings();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.fileTooLargeMessage)),
    );
  }

  // ─── Overlay badge ────────────────────────────────────────────

  void _showOverlayBadge() {
    _removeOverlay();
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final t = _resolvedTheme;
    final effectiveBadgeSize = _effectiveBadgeSize(t);

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx + size.width - effectiveBadgeSize / 2,
        top: offset.dy + size.height - effectiveBadgeSize / 2,
        child: _buildBadgeWidget(effectiveBadgeSize),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // ─── Helpers ──────────────────────────────────────────────────

  bool get _hasImage =>
      _currentFile != null || _currentUrl != null || _currentBytes != null;

  ProfilePickerTheme get _resolvedTheme =>
      widget.theme ?? ProfilePickerThemeProvider.of(context);

  // ─── Badge ────────────────────────────────────────────────────

  /// Returns a badge size that scales with the avatar radius.
  /// Always at least [ProfilePickerTheme.badgeSize] but grows with [widget.radius].
  double _effectiveBadgeSize(ProfilePickerTheme t) {
    final scaled = widget.radius * 0.45;
    return scaled > t.badgeSize ? scaled : t.badgeSize;
  }

  Widget _buildBadgeWidget([double? sizeOverride]) {
    final t = _resolvedTheme;
    final badgeSize = sizeOverride ?? _effectiveBadgeSize(t);
    final baseBadgeSize = t.badgeSize <= 0 ? 1.0 : t.badgeSize;
    final ratio = t.badgeIconSize / baseBadgeSize;
    final iconSize = badgeSize * ratio;

    final border = t.badgeBorderWidth > 0
        ? Border.all(
            color: t.badgeBorderColor ?? Colors.white,
            width: t.badgeBorderWidth,
          )
        : null;

    return widget.badgeWidget ??
        Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: t.badgeGradient == null ? t.badgeColor : null,
            gradient: t.badgeGradient,
            shape: BoxShape.circle,
            border: border,
            boxShadow: t.badgeBoxShadow,
          ),
          child: Padding(
            padding: t.badgeIconPadding,
            child: Icon(t.badgeIcon, color: t.badgeIconColor, size: iconSize),
          ),
        );
  }

  Alignment _badgeAlignment() {
    if (widget.badgeAlignment != null) return widget.badgeAlignment!;
    // 0.707 = cos(45°): places badge centre exactly on the circle border.
    const d = 0.707;
    switch (widget.badgePosition) {
      case BadgePosition.topLeft:
        return const Alignment(-d, -d);
      case BadgePosition.topRight:
        return const Alignment(d, -d);
      case BadgePosition.bottomLeft:
        return const Alignment(-d, d);
      case BadgePosition.bottomRight:
        return const Alignment(d, d);
    }
  }

  // ─── Gesture wrapping ─────────────────────────────────────────

  Widget _wrapWithGesture(Widget child) {
    void onGesture() => _openPicker();

    switch (widget.triggerMode) {
      case ProfileTriggerMode.onTap:
        return GestureDetector(onTap: onGesture, child: child);
      case ProfileTriggerMode.onLongPress:
        return GestureDetector(onLongPress: onGesture, child: child);
      case ProfileTriggerMode.onDoubleTap:
        return GestureDetector(onDoubleTap: onGesture, child: child);
      case ProfileTriggerMode.none:
        return child;
    }
  }

  // ─── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = _resolvedTheme;
    final effectiveBadgeSize = _effectiveBadgeSize(t);

    // Child builder pattern
    if (widget.child != null) {
      return widget.child!(context, _openPicker);
    }

    final display = ProfileDisplay(
      imageFile: _currentFile,
      imageUrl: _currentUrl,
      imageBytes: _currentBytes,
      radius: widget.radius,
      fallbackInitials: widget.fallbackInitials,
      initialsStyle: widget.initialsStyle,
      initialsBackgroundColor: widget.initialsBackgroundColor,
      placeholder: widget.placeholder,
      shape: widget.shape,
      theme: t,
    );

    Widget avatar = display;

    // Loading overlay
    if (_loading) {
      avatar = Stack(
        alignment: Alignment.center,
        children: [
          display,
          Container(
            width: widget.radius * 2,
            height: widget.radius * 2,
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: widget.loadingWidget ??
                const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
          ),
        ],
      );
    }

    // Badge overlay using Stack
    if (widget.badgeVisible &&
        widget.badgeLayoutMode == BadgeLayoutMode.stack &&
        !_loading) {
      final alignment = _badgeAlignment();
      final offset = widget.badgeOffset ?? Offset.zero;

      avatar = Stack(
        clipBehavior: widget.badgeInside ? Clip.hardEdge : Clip.none,
        children: [
          avatar,
          Positioned(
            left: widget.radius +
                alignment.x * widget.radius +
                offset.dx -
                effectiveBadgeSize / 2,
            top: widget.radius +
                alignment.y * widget.radius +
                offset.dy -
                effectiveBadgeSize / 2,
            child: _buildBadgeWidget(effectiveBadgeSize),
          ),
        ],
      );
    }

    // Overlay mode — handled on open
    if (widget.badgeVisible &&
        widget.badgeLayoutMode == BadgeLayoutMode.overlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlayBadge());
    }

    final sized = SizedBox(
      width: widget.radius * 2 + (widget.badgeInside ? 0 : effectiveBadgeSize),
      height: widget.radius * 2 + (widget.badgeInside ? 0 : effectiveBadgeSize),
      child: avatar,
    );

    return _wrapWithGesture(
      Opacity(opacity: widget.enabled ? 1.0 : 0.5, child: sized),
    );
  }
}
