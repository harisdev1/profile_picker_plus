import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

/// The absolute minimum code needed to use [ProfilePicker].
class MinimalDemo extends StatefulWidget {
  const MinimalDemo({super.key});

  @override
  State<MinimalDemo> createState() => _MinimalDemoState();
}

class _MinimalDemoState extends State<MinimalDemo> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Minimal Usage',
      description: 'The simplest possible ProfilePicker — just provide '
          'fallbackInitials and onImageSelected.',
      codeSnippet: '''
ProfilePicker(
  fallbackInitials: 'AK',
  onImageSelected: (file) {
    setState(() => _file = file);
  },
)
''',
      child: Column(
        children: [
          ProfilePicker(
            fallbackInitials: 'AK',
            onImageSelected: (file) => setState(() => _file = file),
          ),
          const SizedBox(height: 24),
          Text(
            _file != null
                ? '✅ Image selected:\n${_file!.path.split('/').last}'
                : 'Tap the avatar to pick an image',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
