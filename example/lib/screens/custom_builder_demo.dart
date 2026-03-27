import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

class CustomBuilderDemo extends StatefulWidget {
  const CustomBuilderDemo({super.key});

  @override
  State<CustomBuilderDemo> createState() => _CustomBuilderDemoState();
}

class _CustomBuilderDemoState extends State<CustomBuilderDemo> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Custom Builders',
      description:
          'Replace the header, footer, individual option tiles, or the '
          'entire picker sheet content while keeping the pick/crop pipeline intact.',
      codeSnippet: '''
// Custom option tile for Remove
ProfilePicker(
  allowRemove: true,
  optionBuilder: (type, action) {
    if (type == OptionType.remove) {
      return ListTile(
        leading: Icon(Icons.delete_forever, color: Colors.red),
        title: Text('Delete Photo', style: TextStyle(color: Colors.red)),
        onTap: action,
      );
    }
    return null; // default tiles for gallery & camera
  },
  onImageSelected: (file) {},
)
''',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Custom option tile for Remove
          _SectionLabel('Custom Remove Tile'),
          Center(
            child: ProfilePicker(
              radius: 48,
              fallbackInitials: 'CR',
              allowRemove: true,
              optionBuilder: (type, action) {
                if (type == OptionType.remove) {
                  return ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Delete Photo',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                    onTap: action,
                  );
                }
                return null;
              },
              onImageSelected: (file) => setState(() => _file = file),
            ),
          ),
          const SizedBox(height: 32),

          // 2. Custom header + footer
          _SectionLabel('Custom Header & Footer'),
          Center(
            child: ProfilePicker(
              radius: 48,
              fallbackInitials: 'HF',
              allowRemove: true,
              headerBuilder: (context) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle, size: 28, color: Color(0xFF6C63FF)),
                    const SizedBox(width: 8),
                    Text('Update your photo',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6C63FF),
                            )),
                  ],
                ),
              ),
              footerBuilder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '📌 Photos are only stored on your device.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
              onImageSelected: (file) => setState(() => _file = file),
            ),
          ),
          const SizedBox(height: 32),

          // 3. Custom icon options
          _SectionLabel('Custom Icon + Style per Option'),
          Center(
            child: ProfilePicker(
              radius: 48,
              fallbackInitials: 'CI',
              allowRemove: true,
              optionBuilder: (type, action) {
                final items = {
                  OptionType.gallery: (Icons.collections, 'Photo Library', Colors.blue),
                  OptionType.camera: (Icons.camera_enhance, 'Take Selfie', Colors.green),
                  OptionType.remove: (Icons.no_photography, 'Clear Avatar', Colors.red),
                };
                final item = items[type];
                if (item == null) return null;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: item.$3.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(item.$1, color: item.$3),
                    title: Text(item.$2,
                        style: TextStyle(color: item.$3, fontWeight: FontWeight.w600)),
                    onTap: action,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              onImageSelected: (file) => setState(() => _file = file),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      );
}
