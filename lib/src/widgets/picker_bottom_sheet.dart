import 'package:flutter/material.dart';
import '../models/profile_picker_theme.dart';
import '../models/profile_picker_strings.dart';
import '../models/option_type.dart';
import '../models/profile_picker_actions.dart';

/// The modal bottom sheet UI for image source selection.
///
/// Used internally by [ProfilePicker]. You can also show it directly for
/// advanced integration via [PickerBottomSheet.show].
class PickerBottomSheet extends StatelessWidget {
  const PickerBottomSheet({
    super.key,
    required this.actions,
    required this.theme,
    required this.strings,
    required this.allowGallery,
    required this.allowCamera,
    required this.allowRemove,
    this.headerBuilder,
    this.footerBuilder,
    this.optionBuilder,
    this.dividerBuilder,
    this.dragHandleBuilder,
  });

  final ProfilePickerActions actions;
  final ProfilePickerTheme theme;
  final ProfilePickerStrings strings;
  final bool allowGallery;
  final bool allowCamera;
  final bool allowRemove;

  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final Widget? Function(OptionType, VoidCallback)? optionBuilder;
  final WidgetBuilder? dividerBuilder;
  final WidgetBuilder? dragHandleBuilder;

  /// Convenience method to show the bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required ProfilePickerActions actions,
    required ProfilePickerTheme theme,
    required ProfilePickerStrings strings,
    required bool allowGallery,
    required bool allowCamera,
    required bool allowRemove,
    WidgetBuilder? headerBuilder,
    WidgetBuilder? footerBuilder,
    Widget? Function(OptionType, VoidCallback)? optionBuilder,
    WidgetBuilder? dividerBuilder,
    WidgetBuilder? dragHandleBuilder,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: theme.barrierColor,
      isScrollControlled: true,
      builder: (_) => PickerBottomSheet(
        actions: actions,
        theme: theme,
        strings: strings,
        allowGallery: allowGallery,
        allowCamera: allowCamera,
        allowRemove: allowRemove,
        headerBuilder: headerBuilder,
        footerBuilder: footerBuilder,
        optionBuilder: optionBuilder,
        dividerBuilder: dividerBuilder,
        dragHandleBuilder: dragHandleBuilder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = theme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    final radius = Radius.circular(theme.sheetBorderRadius);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            if (dragHandleBuilder != null)
              dragHandleBuilder!(context)
            else
              _defaultHandle(),

            // Header
            if (headerBuilder != null)
              headerBuilder!(context)
            else
              _defaultHeader(context),

            _divider(context),

            // Gallery option
            if (allowGallery)
              _buildOption(
                context,
                type: OptionType.gallery,
                icon: theme.galleryIcon,
                iconColor: theme.galleryOptionColor ?? theme.primaryColor,
                label: strings.galleryLabel,
                action: () async {
                  actions.dismiss();
                  await actions.pickFromGallery();
                },
              ),

            if (allowGallery && allowCamera) _divider(context),

            // Camera option
            if (allowCamera)
              _buildOption(
                context,
                type: OptionType.camera,
                icon: theme.cameraIcon,
                iconColor: theme.cameraOptionColor ?? theme.primaryColor,
                label: strings.cameraLabel,
                action: () async {
                  actions.dismiss();
                  await actions.pickFromCamera();
                },
              ),

            // Remove option
            if (allowRemove) ...[
              _divider(context),
              _buildOption(
                context,
                type: OptionType.remove,
                icon: theme.removeIcon,
                iconColor: theme.removeOptionColor,
                label: strings.removeLabel,
                action: () {
                  actions.dismiss();
                  actions.removeImage();
                },
                labelColor: theme.removeOptionColor,
              ),
            ],

            // Footer
            if (footerBuilder != null) footerBuilder!(context),

            _divider(context),

            // Cancel
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: theme.cancelButtonStyle ??
                    TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                onPressed: actions.dismiss,
                child: Text(
                  strings.cancelLabel,
                  style: theme.optionTextStyle ??
                      TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _defaultHandle() => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  Widget _defaultHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          '',
          style: theme.titleTextStyle ??
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
      );

  Widget _divider(BuildContext context) =>
      dividerBuilder?.call(context) ??
      Divider(
        height: 1,
        thickness: 0.5,
        color: theme.dividerColor ?? Colors.grey.shade200,
      );

  Widget _buildOption(
    BuildContext context, {
    required OptionType type,
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback action,
    Color? labelColor,
  }) {
    final custom = optionBuilder?.call(type, action);
    if (custom != null) return custom;

    return InkWell(
      onTap: action,
      child: SizedBox(
        height: theme.optionTileHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 16),
              Text(
                label,
                style: theme.optionTextStyle?.copyWith(color: labelColor) ??
                    TextStyle(
                      fontSize: 16,
                      color: labelColor ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
