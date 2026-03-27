import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

class TriggerDemo extends StatefulWidget {
  const TriggerDemo({super.key});

  @override
  State<TriggerDemo> createState() => _TriggerDemoState();
}

class _TriggerDemoState extends State<TriggerDemo> {
  ProfileTriggerMode _triggerMode = ProfileTriggerMode.onTap;
  File? _file;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Trigger Modes',
      description:
          'Control which gesture opens the picker: tap, long-press, double-tap, or none.',
      codeSnippet: '''
// Long-press trigger
ProfilePicker(
  triggerMode: ProfileTriggerMode.onLongPress,
  fallbackInitials: 'TG',
  onImageSelected: (file) {},
)

// None — open via child builder
ProfilePicker(
  triggerMode: ProfileTriggerMode.none,
  badgeLayoutMode: BadgeLayoutMode.none,
  child: (ctx, open) => ElevatedButton(
    onPressed: open,
    child: Text('Open Picker'),
  ),
  onImageSelected: (file) {},
)
''',
      child: Column(
        children: [
          ProfilePicker(
            radius: 56,
            fallbackInitials: 'TG',
            triggerMode: _triggerMode,
            onImageSelected: (file) => setState(() => _file = file),
          ),
          const SizedBox(height: 16),
          Text(
            _hint,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text('Trigger Mode', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ProfileTriggerMode.values.map((m) {
              return ChoiceChip(
                label: Text(m.name),
                selected: _triggerMode == m,
                onSelected: (_) => setState(() => _triggerMode = m),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Text('Child Builder Pattern (triggerMode: none)',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          ProfilePicker(
            triggerMode: ProfileTriggerMode.none,
            badgeLayoutMode: BadgeLayoutMode.none,
            fallbackInitials: 'CB',
            onImageSelected: (file) => setState(() => _file = file),
            child: (context, open) => ElevatedButton.icon(
              onPressed: open,
              icon: const Icon(Icons.photo_camera),
              label: const Text('Open Picker'),
            ),
          ),
        ],
      ),
    );
  }

  String get _hint {
    switch (_triggerMode) {
      case ProfileTriggerMode.onTap:
        return 'Tap the avatar to open picker';
      case ProfileTriggerMode.onLongPress:
        return 'Long-press the avatar to open picker';
      case ProfileTriggerMode.onDoubleTap:
        return 'Double-tap the avatar to open picker';
      case ProfileTriggerMode.none:
        return 'No gesture — use controller or child builder';
    }
  }
}
