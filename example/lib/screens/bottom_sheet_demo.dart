import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import '../demo_scaffold.dart';

class BottomSheetDemo extends StatefulWidget {
  const BottomSheetDemo({super.key});

  @override
  State<BottomSheetDemo> createState() => _BottomSheetDemoState();
}

class _BottomSheetDemoState extends State<BottomSheetDemo> {
  File? _file;
  double _radius = 60;
  bool _allowRemove = true;
  bool _cropEnabled = true;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Bottom Sheet Picker',
      description: 'Fully customizable bottom-sheet source selector with '
          'gallery, camera, and optional remove.',
      codeSnippet: '''
ProfilePicker(
  pickerMode: ProfilePickerMode.bottomSheet,
  radius: 60,
  allowRemove: true,
  cropEnabled: true,
  cropAspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  fallbackInitials: 'BS',
  onImageSelected: (file) => setState(() => _file = file),
)
''',
      child: Column(
        children: [
          ProfilePicker(
            pickerMode: ProfilePickerMode.bottomSheet,
            radius: _radius,
            allowRemove: _allowRemove,
            cropEnabled: _cropEnabled,
            cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            fallbackInitials: 'BS',
            onImageSelected: (file) => setState(() => _file = file),
          ),
          const SizedBox(height: 32),
          // Controls
          _sliderRow('Radius', _radius, 32, 90, (v) => setState(() => _radius = v)),
          _switchRow('Allow Remove', _allowRemove, (v) => setState(() => _allowRemove = v)),
          _switchRow('Crop Enabled', _cropEnabled, (v) => setState(() => _cropEnabled = v)),
          const SizedBox(height: 16),
          if (_file != null)
            Text('Selected: ${_file!.path.split('/').last}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _sliderRow(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 13))),
        Expanded(child: Slider(value: value, min: min, max: max, onChanged: onChanged)),
        Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
