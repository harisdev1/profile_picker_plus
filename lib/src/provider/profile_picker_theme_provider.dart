import 'package:flutter/material.dart';
import '../models/profile_picker_theme.dart';

/// An [InheritedWidget] that provides an [ProfilePickerTheme] to all descendant
/// profile_picker_plus widgets. Wrap your subtree (or [MaterialApp]) with this widget
/// to apply the theme globally.
///
/// ```dart
/// ProfilePickerThemeProvider(
///   theme: ProfilePickerTheme(primaryColor: Colors.indigo),
///   child: MaterialApp(home: MyHomePage()),
/// )
/// ```
class ProfilePickerThemeProvider extends InheritedWidget {
  const ProfilePickerThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  /// The theme to provide to all descendant profile_picker_plus widgets.
  final ProfilePickerTheme theme;

  /// Retrieves the nearest [ProfilePickerTheme] from the widget tree.
  /// Returns the default theme if no provider is found.
  static ProfilePickerTheme of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ProfilePickerThemeProvider>();
    return provider?.theme ?? const ProfilePickerTheme();
  }

  @override
  bool updateShouldNotify(ProfilePickerThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
