import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

class ThemingDemo extends StatefulWidget {
  const ThemingDemo({super.key});

  @override
  State<ThemingDemo> createState() => _ThemingDemoState();
}

class _ThemingDemoState extends State<ThemingDemo> {
  int _selectedTheme = 0;

  static const _themes = [
    _ThemePreset(
      'Violet (Default)',
      Color(0xFF6C63FF),
      ProfilePickerTheme(primaryColor: Color(0xFF6C63FF), badgeColor: Color(0xFF6C63FF)),
    ),
    _ThemePreset(
      'Teal',
      Colors.teal,
      ProfilePickerTheme(
        primaryColor: Colors.teal,
        badgeColor: Colors.teal,
        sheetBorderRadius: 28,
      ),
    ),
    _ThemePreset(
      'Rose Gold',
      Color(0xFFE8918A),
      ProfilePickerTheme(
        primaryColor: Color(0xFFE8918A),
        badgeColor: Color(0xFFE8918A),
        badgeIcon: Icons.camera_alt,
        sheetBorderRadius: 32,
      ),
    ),
    _ThemePreset(
      'Dark Minimal',
      Color(0xFF2D2D2D),
      ProfilePickerTheme(
        primaryColor: Color(0xFF00D4B8),
        badgeColor: Color(0xFF00D4B8),
        badgeIconColor: Colors.black,
        backgroundColor: Color(0xFF1A1A2E),
        barrierColor: Color(0xCC000000),
        sheetBorderRadius: 16,
      ),
    ),
  ];

  File? _file;

  @override
  Widget build(BuildContext context) {
    final preset = _themes[_selectedTheme];

    return DemoScaffold(
      title: 'Theming & Colors',
      description:
          'Pass ProfilePickerTheme per-widget or wrap with ProfilePickerThemeProvider.',
      codeSnippet: '''
ProfilePicker(
  theme: ProfilePickerTheme(
    primaryColor: Colors.teal,
    badgeColor: Colors.teal,
    sheetBorderRadius: 28,
  ),
  fallbackInitials: 'TH',
  onImageSelected: (file) {},
)
''',
      child: Column(
        children: [
          ProfilePicker(
            theme: preset.theme,
            fallbackInitials: preset.initials,
            allowRemove: true,
            onImageSelected: (file) => setState(() => _file = file),
          ),
          const SizedBox(height: 32),
          Text('Select Theme', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_themes.length, (i) {
              final t = _themes[i];
              return ChoiceChip(
                label: Text(t.name),
                selected: _selectedTheme == i,
                selectedColor: t.color.withOpacity(0.2),
                onSelected: (_) => setState(() => _selectedTheme = i),
                avatar: CircleAvatar(backgroundColor: t.color, radius: 8),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ThemePreset {
  const _ThemePreset(this.name, this.color, this.theme);
  final String name;
  final Color color;
  final ProfilePickerTheme theme;
  String get initials => name.substring(0, 2).toUpperCase();
}
