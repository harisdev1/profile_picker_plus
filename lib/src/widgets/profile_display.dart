import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/profile_picker_theme.dart';
import '../provider/profile_picker_theme_provider.dart';
import '../utils/initials_utils.dart';

/// A read-only avatar display widget.
///
/// Supports network URL, local [File], asset path, and raw [Uint8List] bytes
/// as image sources. Falls back to initials or a placeholder widget when no
/// image is available.
///
/// ```dart
/// ProfileDisplay(
///   imageUrl: 'https://example.com/avatar.jpg',
///   radius: 36,
///   fallbackInitials: 'JD',
/// )
/// ```
class ProfileDisplay extends StatelessWidget {
  const ProfileDisplay({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.imageBytes,
    this.imageAsset,
    this.radius = 48.0,
    this.fallbackInitials,
    this.initialsStyle,
    this.initialsBackgroundColor,
    this.placeholder,
    this.errorWidget,
    this.shape,
    this.border,
    this.theme,
    this.semanticsLabel,
  });

  /// Remote image URL (uses [CachedNetworkImage]).
  final String? imageUrl;

  /// Local file image.
  final File? imageFile;

  /// Raw bytes image.
  final Uint8List? imageBytes;

  /// Asset path image (e.g. 'assets/avatar.png').
  final String? imageAsset;

  /// Radius of the avatar circle. Default: 48.
  final double radius;

  /// Initials shown when no image source is provided. E.g. 'JD'.
  /// Also accepts a full name — up to 2 initials will be derived automatically.
  final String? fallbackInitials;

  /// Text style for the initials. Defaults to white, bold, sized relative to [radius].
  final TextStyle? initialsStyle;

  /// Background color for the initials circle.
  final Color? initialsBackgroundColor;

  /// Widget shown when no image and no initials are set, or during loading.
  final Widget? placeholder;

  /// Widget shown when image loading fails.
  final Widget? errorWidget;

  /// Custom shape for the avatar clip. Defaults to [CircleBorder].
  final ShapeBorder? shape;

  /// Optional border drawn around the avatar.
  final BoxBorder? border;

  /// Theme override for this widget.
  final ProfilePickerTheme? theme;

  /// Semantics label for accessibility.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedTheme = theme ?? ProfilePickerThemeProvider.of(context);

    Widget content;

    if (imageFile != null) {
      content = _buildFileImage(imageFile!);
    } else if (imageBytes != null) {
      content = _buildBytesImage(imageBytes!);
    } else if (imageAsset != null) {
      content = _buildAssetImage(imageAsset!);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = _buildNetworkImage(imageUrl!, resolvedTheme);
    } else {
      content = _buildFallback(context, resolvedTheme);
    }

    final diameter = radius * 2;
    final shapeBorder = shape ?? const CircleBorder();

    Widget avatar = ClipPath(
      clipper: ShapeBorderClipper(shape: shapeBorder),
      child: SizedBox.square(dimension: diameter, child: content),
    );

    if (border != null) {
      avatar = Container(
        width: diameter,
        height: diameter,
        decoration: ShapeDecoration(shape: shapeBorder, shadows: []),
        child: Stack(
          children: [
            avatar,
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: border,
                  shape: shape is CircleBorder
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Semantics(
      label: semanticsLabel ?? fallbackInitials ?? 'Avatar',
      image: true,
      child: avatar,
    );
  }

  Widget _buildFileImage(File file) => Image.file(
        file,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );

  Widget _buildBytesImage(Uint8List bytes) => Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );

  Widget _buildAssetImage(String asset) => Image.asset(
        asset,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );

  Widget _buildNetworkImage(String url, ProfilePickerTheme t) =>
      CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        placeholder: (_, __) =>
            placeholder ?? _loadingIndicator(t),
        errorWidget: (_, __, ___) =>
            errorWidget ?? _buildFallback(null, t),
      );

  Widget _buildFallback(BuildContext? context, ProfilePickerTheme t) {
    final initials = fallbackInitials != null
        ? InitialsUtils.derive(fallbackInitials!)
        : null;

    if (initials != null && initials.isNotEmpty) {
      final fontSize = radius * 0.6;
      final bgColor = initialsBackgroundColor ?? t.primaryColor;
      final style = initialsStyle ??
          TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          );
      return Container(
        color: bgColor,
        alignment: Alignment.center,
        child: Text(initials, style: style),
      );
    }

    return placeholder ??
        Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(
            Icons.person,
            size: radius * 0.8,
            color: Colors.grey.shade400,
          ),
        );
  }

  Widget _loadingIndicator(ProfilePickerTheme t) => Container(
        color: Colors.grey.shade100,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(t.primaryColor),
        ),
      );
}
