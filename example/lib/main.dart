import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import 'screens/minimal_demo.dart';
import 'screens/bottom_sheet_demo.dart';
import 'screens/dialog_demo.dart';
import 'screens/theming_demo.dart';
import 'screens/badge_demo.dart';
import 'screens/trigger_demo.dart';
import 'screens/custom_builder_demo.dart';
import 'screens/profile_display_demo.dart';
import 'screens/controller_demo.dart';
import 'screens/full_profile_form.dart';

void main() => runApp(const ProfilePickerExampleApp());

class ProfilePickerExampleApp extends StatelessWidget {
  const ProfilePickerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfilePickerThemeProvider(
      // App-wide default theme — individual demos can override per-widget
      theme: const ProfilePickerTheme(primaryColor: Color(0xFF6C63FF)),
      child: MaterialApp(
        title: 'profile_picker_plus Examples',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF6C63FF),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

// ─── Home ────────────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _demos = [
    _DemoEntry('Minimal Usage', Icons.looks_one, MinimalDemo()),
    _DemoEntry('Bottom Sheet Picker', Icons.table_rows_outlined, BottomSheetDemo()),
    _DemoEntry('Dialog Picker', Icons.crop_square, DialogDemo()),
    _DemoEntry('Theming & Colors', Icons.palette_outlined, ThemingDemo()),
    _DemoEntry('Badge Positions', Icons.badge_outlined, BadgeDemo()),
    _DemoEntry('Trigger Modes', Icons.touch_app_outlined, TriggerDemo()),
    _DemoEntry('Custom Builders', Icons.build_outlined, CustomBuilderDemo()),
    _DemoEntry('ProfileDisplay', Icons.person_outline, ProfileDisplayDemo()),
    _DemoEntry('Controller API', Icons.settings_remote_outlined, ControllerDemo()),
    _DemoEntry('Full Profile Form', Icons.account_circle_outlined, FullProfileForm()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile_picker_plus'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                const ProfileDisplay(
                  fallbackInitials: 'AK',
                  radius: 40,
                  initialsBackgroundColor: Color(0xFF6C63FF),
                ),
                const SizedBox(height: 12),
                Text(
                  'profile_picker_plus v1.0.0',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pick, crop & display — complete profile picture toolkit',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _demos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final demo = _demos[i];
                return Card(
                  child: ListTile(
                    leading: Icon(demo.icon, color: const Color(0xFF6C63FF)),
                    title: Text(demo.title),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => demo.screen),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoEntry {
  const _DemoEntry(this.title, this.icon, this.screen);
  final String title;
  final IconData icon;
  final Widget screen;
}
