import 'package:flutter/material.dart';
import '../models/profile_picker_theme.dart';
import '../models/profile_picker_strings.dart';
import '../models/option_type.dart';
import '../models/profile_picker_actions.dart';

/// The dialog UI for image source selection.
///
/// Used internally by [ProfilePicker] when [pickerMode] is [ProfilePickerMode.dialog].
/// Can also be shown directly via [PickerDialog.show].
class PickerDialog extends StatelessWidget {
  const PickerDialog({
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
  }) async {
    await showDialog<void>(
      context: context,
      barrierColor: theme.barrierColor,
      builder: (_) => PickerDialog(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = theme.backgroundColor ??
        Theme.of(context).dialogBackgroundColor;

    return Dialog(
      backgroundColor: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.dialogBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            if (headerBuilder != null)
              headerBuilder!(context)
            else
              _defaultHeader(context),

            _divider(context),

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

            if (footerBuilder != null) footerBuilder!(context),

            _divider(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: theme.cancelButtonStyle,
                    onPressed: actions.dismiss,
                    child: Text(strings.cancelLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Row(
          children: [
            Text(
              strings.pickerTitle,
              style: theme.titleTextStyle ??
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
            ),
          ],
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
