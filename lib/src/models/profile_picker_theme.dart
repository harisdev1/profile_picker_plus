import 'package:flutter/material.dart';

/// Unified theming class for all profile_picker_plus UI.
///
/// Pass to an individual [ProfilePicker] or [ProfileDisplay] widget via the
/// `theme` parameter, or wrap your subtree with [ProfilePickerThemeProvider]
/// for app-wide theming.
///
/// ```dart
/// ProfilePicker(
///   theme: ProfilePickerTheme(
///     primaryColor: Colors.teal,
///     sheetBorderRadius: 24,
///     badgeColor: Colors.teal,
///   ),
///   onImageSelected: (file) {},
/// )
/// ```
class ProfilePickerTheme {
  const ProfilePickerTheme({
    this.primaryColor = const Color(0xFF6C63FF),
    this.backgroundColor,
    this.titleTextStyle,
    this.optionTextStyle,
    this.galleryIcon = Icons.photo_library_outlined,
    this.cameraIcon = Icons.camera_alt_outlined,
    this.removeIcon = Icons.delete_outline,
    this.badgeIcon = Icons.edit,
    this.badgeColor = const Color(0xFF6C63FF),
    this.badgeIconColor = Colors.white,
    this.badgeSize = 28.0,
    this.badgeIconSize = 16.0,
    this.badgeBorderColor,
    this.badgeBorderWidth = 0.0,
    this.badgeIconPadding = EdgeInsets.zero,
    this.badgeGradient,
    this.badgeBoxShadow = const [
      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
    ],
    this.sheetBorderRadius = 20.0,
    this.dialogBorderRadius = 16.0,
    this.barrierColor = const Color(0x80000000),
    this.cropToolbarColor,
    this.cropToolbarTitleColor,
    this.cropActiveControlsWidgetColor,
    this.optionTileHeight = 56.0,
    this.dividerColor,
    this.cancelButtonStyle,
    this.galleryOptionColor,
    this.cameraOptionColor,
    this.removeOptionColor = Colors.red,
  });

  // ─── Global colors ───────────────────────────────────────────
  /// Primary accent color used for badges, active controls, and buttons.
  final Color primaryColor;

  /// Background color for the picker bottom sheet or dialog.
  /// Defaults to the scaffold background of the current [ThemeData].
  final Color? backgroundColor;

  // ─── Text styles ─────────────────────────────────────────────
  /// Text style for the picker title (sheet/dialog header).
  final TextStyle? titleTextStyle;

  /// Text style for gallery, camera, and remove option labels.
  final TextStyle? optionTextStyle;

  // ─── Icon overrides ──────────────────────────────────────────
  /// Icon used for the gallery option tile.
  final IconData galleryIcon;

  /// Icon used for the camera option tile.
  final IconData cameraIcon;

  /// Icon used for the remove photo option tile.
  final IconData removeIcon;

  /// Icon displayed inside the edit badge.
  final IconData badgeIcon;

  // ─── Badge appearance ────────────────────────────────────────
  /// Background color of the circular edit badge.
  final Color badgeColor;

  /// Color of the icon inside the edit badge.
  final Color badgeIconColor;

  /// Diameter of the circular badge container.
  final double badgeSize;

  /// Size of the [badgeIcon] inside the badge.
  final double badgeIconSize;

  /// Border color of the badge. Ignored when [badgeBorderWidth] is 0.
  final Color? badgeBorderColor;

  /// Border width for the badge. Set to 0 to disable border.
  final double badgeBorderWidth;

  /// Inner padding around the badge icon.
  final EdgeInsetsGeometry badgeIconPadding;

  /// Optional gradient background for the badge.
  /// When set, this takes precedence over [badgeColor].
  final Gradient? badgeGradient;

  /// Shadow for the badge container.
  final List<BoxShadow> badgeBoxShadow;

  // ─── Sheet / dialog shape ────────────────────────────────────
  /// Top corner radius for the modal bottom sheet. Default: 20.
  final double sheetBorderRadius;

  /// Corner radius for the dialog. Default: 16.
  final double dialogBorderRadius;

  /// The barrier (scrim) color behind the sheet or dialog.
  final Color barrierColor;

  // ─── Cropper theming ─────────────────────────────────────────
  /// Toolbar background color in the native crop screen.
  final Color? cropToolbarColor;

  /// Toolbar title/icon color in the native crop screen.
  final Color? cropToolbarTitleColor;

  /// Active controls widget color (Android uCrop).
  final Color? cropActiveControlsWidgetColor;

  // ─── Option tile sizing ──────────────────────────────────────
  /// Height of each option tile inside the picker. Default: 56.
  final double optionTileHeight;

  /// Color of the divider between option tiles.
  final Color? dividerColor;

  /// Style for the Cancel button.
  final ButtonStyle? cancelButtonStyle;

  /// Leading icon color for the gallery tile (null = [primaryColor]).
  final Color? galleryOptionColor;

  /// Leading icon color for the camera tile (null = [primaryColor]).
  final Color? cameraOptionColor;

  /// Leading icon color for the remove tile. Default: red.
  final Color removeOptionColor;

  // ─── Convenience ─────────────────────────────────────────────
  /// Returns a copy with the given fields overridden.
  ProfilePickerTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? optionTextStyle,
    IconData? galleryIcon,
    IconData? cameraIcon,
    IconData? removeIcon,
    IconData? badgeIcon,
    Color? badgeColor,
    Color? badgeIconColor,
    double? badgeSize,
    double? badgeIconSize,
    Color? badgeBorderColor,
    double? badgeBorderWidth,
    EdgeInsetsGeometry? badgeIconPadding,
    Gradient? badgeGradient,
    List<BoxShadow>? badgeBoxShadow,
    double? sheetBorderRadius,
    double? dialogBorderRadius,
    Color? barrierColor,
    Color? cropToolbarColor,
    Color? cropToolbarTitleColor,
    Color? cropActiveControlsWidgetColor,
    double? optionTileHeight,
    Color? dividerColor,
    ButtonStyle? cancelButtonStyle,
    Color? galleryOptionColor,
    Color? cameraOptionColor,
    Color? removeOptionColor,
  }) {
    return ProfilePickerTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      optionTextStyle: optionTextStyle ?? this.optionTextStyle,
      galleryIcon: galleryIcon ?? this.galleryIcon,
      cameraIcon: cameraIcon ?? this.cameraIcon,
      removeIcon: removeIcon ?? this.removeIcon,
      badgeIcon: badgeIcon ?? this.badgeIcon,
      badgeColor: badgeColor ?? this.badgeColor,
      badgeIconColor: badgeIconColor ?? this.badgeIconColor,
      badgeSize: badgeSize ?? this.badgeSize,
      badgeIconSize: badgeIconSize ?? this.badgeIconSize,
      badgeBorderColor: badgeBorderColor ?? this.badgeBorderColor,
      badgeBorderWidth: badgeBorderWidth ?? this.badgeBorderWidth,
      badgeIconPadding: badgeIconPadding ?? this.badgeIconPadding,
      badgeGradient: badgeGradient ?? this.badgeGradient,
      badgeBoxShadow: badgeBoxShadow ?? this.badgeBoxShadow,
      sheetBorderRadius: sheetBorderRadius ?? this.sheetBorderRadius,
      dialogBorderRadius: dialogBorderRadius ?? this.dialogBorderRadius,
      barrierColor: barrierColor ?? this.barrierColor,
      cropToolbarColor: cropToolbarColor ?? this.cropToolbarColor,
      cropToolbarTitleColor:
          cropToolbarTitleColor ?? this.cropToolbarTitleColor,
      cropActiveControlsWidgetColor:
          cropActiveControlsWidgetColor ?? this.cropActiveControlsWidgetColor,
      optionTileHeight: optionTileHeight ?? this.optionTileHeight,
      dividerColor: dividerColor ?? this.dividerColor,
      cancelButtonStyle: cancelButtonStyle ?? this.cancelButtonStyle,
      galleryOptionColor: galleryOptionColor ?? this.galleryOptionColor,
      cameraOptionColor: cameraOptionColor ?? this.cameraOptionColor,
      removeOptionColor: removeOptionColor ?? this.removeOptionColor,
    );
  }
}
