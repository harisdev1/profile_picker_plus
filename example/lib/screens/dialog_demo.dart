import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

class DialogDemo extends StatefulWidget {
  const DialogDemo({super.key});

  @override
  State<DialogDemo> createState() => _DialogDemoState();
}

class _DialogDemoState extends State<DialogDemo> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Dialog Picker',
      description: 'Source selector presented as a centered dialog instead of a bottom sheet.',
      codeSnippet: '''
ProfilePicker(
  pickerMode: ProfilePickerMode.dialog,
  radius: 56,
  allowRemove: true,
  fallbackInitials: 'DL',
  theme: ProfilePickerTheme(
    primaryColor: Colors.deepPurple,
    dialogBorderRadius: 20,
  ),
  onImageSelected: (file) => setState(() => _file = file),
)
''',
      child: Column(
        children: [
          ProfilePicker(
            pickerMode: ProfilePickerMode.dialog,
            radius: 56,
            allowRemove: true,
            fallbackInitials: 'DL',
            theme: const ProfilePickerTheme(
              primaryColor: Colors.deepPurple,
              dialogBorderRadius: 20,
              badgeColor: Colors.deepPurple,
            ),
            onImageSelected: (file) => setState(() => _file = file),
          ),
          const SizedBox(height: 24),
          Text(
            _file != null ? '✅ Photo updated!' : 'Tap avatar → Dialog appears',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
