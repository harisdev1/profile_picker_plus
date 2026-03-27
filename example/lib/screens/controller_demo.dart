import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

class ControllerDemo extends StatefulWidget {
  const ControllerDemo({super.key});

  @override
  State<ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<ControllerDemo> {
  final _controller = ProfilePickerController();
  File? _file;
  String _log = 'Waiting for controller events…';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _log = 'isOpen: ${_controller.isOpen} | '
            'hasImage: ${_controller.hasImage}';
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Controller API',
      description:
          'Drive ProfilePicker programmatically from any button, menu, '
          'or onboarding step using ProfilePickerController.',
      codeSnippet: '''
final _controller = ProfilePickerController();

ProfilePicker(
  controller: _controller,
  triggerMode: ProfileTriggerMode.none,
  badgeLayoutMode: BadgeLayoutMode.none,
  onImageSelected: (file) => setState(() => _file = file),
),

// Open from a button
ElevatedButton(
  onPressed: () => _controller.open(),
  child: Text('Change Photo'),
),

// Clear from a button
TextButton(
  onPressed: () => _controller.clearImage(),
  child: Text('Remove Photo'),
),
''',
      child: Column(
        children: [
          // Avatar — no tap trigger, no badge
          ProfilePicker(
            controller: _controller,
            triggerMode: ProfileTriggerMode.none,
            badgeLayoutMode: BadgeLayoutMode.none,
            radius: 60,
            fallbackInitials: 'CT',
            allowRemove: true,
            onImageSelected: (file) {
              setState(() => _file = file);
            },
          ),
          const SizedBox(height: 8),
          Text(
            _file != null
                ? _file!.path.split('/').last
                : 'No image selected',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Controller buttons
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _controller.open(),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Open Picker'),
              ),
              OutlinedButton.icon(
                onPressed: _controller.hasImage
                    ? () => _controller.clearImage()
                    : null,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear Image'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // State display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.monitor_heart_outlined,
                    color: Colors.greenAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _log,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
