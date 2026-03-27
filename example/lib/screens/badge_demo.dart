import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

class BadgeDemo extends StatefulWidget {
  const BadgeDemo({super.key});

  @override
  State<BadgeDemo> createState() => _BadgeDemoState();
}

class _BadgeDemoState extends State<BadgeDemo> {
  BadgePosition _position = BadgePosition.bottomRight;
  BadgeLayoutMode _layoutMode = BadgeLayoutMode.stack;
  bool _badgeInside = false;
  bool _badgeVisible = true;
  bool _customBadge = false;
  int _styleIndex = 0;
  File? _file;

  static const _styleNames = [
    'Default',
    'Teal Border',
    'Gradient Ring',
  ];

  ProfilePickerTheme _styleTheme() {
    switch (_styleIndex) {
      case 1:
        return const ProfilePickerTheme(
          badgeColor: Color(0xFF009688),
          badgeIcon: Icons.camera_alt,
          badgeIconColor: Colors.white,
          badgeIconSize: 18,
          badgeBorderColor: Colors.white,
          badgeBorderWidth: 2,
          badgeIconPadding: EdgeInsets.all(2),
        );
      case 2:
        return const ProfilePickerTheme(
          badgeColor: Color(0xFF3B3B3B),
          badgeIcon: Icons.edit_rounded,
          badgeIconColor: Color(0xFFFFF7E0),
          badgeIconSize: 17,
          badgeBorderColor: Color(0xFFFFF7E0),
          badgeBorderWidth: 1.5,
          badgeIconPadding: EdgeInsets.all(1.5),
          badgeGradient: LinearGradient(
            colors: [Color(0xFF0E7C7B), Color(0xFFF4A261)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          badgeBoxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        );
      default:
        return const ProfilePickerTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Badge Positions',
      description:
          'Control where and how the edit badge appears on the avatar.',
      codeSnippet: '''
ProfilePicker(
  theme: ProfilePickerTheme(
    badgeColor: Colors.teal,
    badgeIcon: Icons.camera_alt,
    badgeIconColor: Colors.white,
    badgeIconSize: 18,
    badgeBorderColor: Colors.white,
    badgeBorderWidth: 2,
    badgeIconPadding: EdgeInsets.all(2),
  ),
  badgePosition: BadgePosition.bottomRight,
  badgeInside: false,
  badgeLayoutMode: BadgeLayoutMode.stack,
  fallbackInitials: 'BD',
  onImageSelected: (file) {},
)
''',
      child: Column(
        children: [
          ProfilePicker(
            radius: 56,
            theme: _styleTheme(),
            fallbackInitials: 'BD',
            badgePosition: _position,
            badgeLayoutMode: _layoutMode,
            badgeInside: _badgeInside,
            badgeVisible: _badgeVisible,
            badgeWidget: _customBadge
                ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_a_photo,
                        color: Colors.white, size: 16),
                  )
                : null,
            onImageSelected: (file) => setState(() => _file = file),
          ),
          const SizedBox(height: 32),
          Text('Badge Style', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(_styleNames.length, (index) {
              return ChoiceChip(
                label: Text(_styleNames[index]),
                selected: _styleIndex == index,
                onSelected: (_) => setState(() => _styleIndex = index),
              );
            }),
          ),
          const SizedBox(height: 16),
          // Position picker
          Text('Badge Position', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: BadgePosition.values.map((p) {
              return ChoiceChip(
                label: Text(p.name),
                selected: _position == p,
                onSelected: (_) => setState(() => _position = p),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Layout Mode', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: BadgeLayoutMode.values.map((m) {
              return ChoiceChip(
                label: Text(m.name),
                selected: _layoutMode == m,
                onSelected: (_) => setState(() => _layoutMode = m),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          _switchRow('Badge Inside Avatar', _badgeInside,
              (v) => setState(() => _badgeInside = v)),
          _switchRow('Badge Visible', _badgeVisible,
              (v) => setState(() => _badgeVisible = v)),
          _switchRow('Custom Badge Widget', _customBadge,
              (v) => setState(() => _customBadge = v)),
        ],
      ),
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Switch(value: value, onChanged: onChanged),
        ],
      );
}
