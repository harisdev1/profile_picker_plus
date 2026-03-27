import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

/// Full profile-edit form — the flagship demo for pub.dev GIF/video.
///
/// Shows ProfilePicker in a realistic user-profile editing context with
/// name, bio, and save/cancel buttons.
class FullProfileForm extends StatefulWidget {
  const FullProfileForm({super.key});

  @override
  State<FullProfileForm> createState() => _FullProfileFormState();
}

class _FullProfileFormState extends State<FullProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Alex Kim');
  final _usernameCtrl = TextEditingController(text: '@alexkim');
  final _bioCtrl = TextEditingController(
      text: 'Flutter developer. Building beautiful apps. ☕');

  File? _avatarFile;
  bool _saved = false;
  int _selectedThemeIndex = 0;

  static const _themes = [
    ('Violet', Color(0xFF6C63FF)),
    ('Teal', Colors.teal),
    ('Rose', Color(0xFFE8918A)),
    ('Orange', Colors.deepOrange),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Profile saved!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _reset() {
    setState(() {
      _avatarFile = null;
      _saved = false;
      _nameCtrl.text = 'Alex Kim';
      _usernameCtrl.text = '@alexkim';
      _bioCtrl.text = 'Flutter developer. Building beautiful apps. ☕';
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _themes[_selectedThemeIndex].$2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Profile Form'),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _reset, child: const Text('Reset')),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header with avatar ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withOpacity(0.15),
                    primaryColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  ProfilePicker(
                    radius: 56,
                    fallbackInitials: _nameCtrl.text,
                    initialImageFile: _avatarFile,
                    allowRemove: _avatarFile != null,
                    cropEnabled: true,
                    compressionQuality: 80,
                    badgePosition: BadgePosition.bottomRight,
                    theme: ProfilePickerTheme(
                      primaryColor: primaryColor,
                      badgeColor: primaryColor,
                      sheetBorderRadius: 24,
                    ),
                    onImageSelected: (file) => setState(() {
                      _avatarFile = file;
                      _saved = false;
                    }),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap avatar to update photo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Form ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Theme picker row
                    Text('Accent Colour',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(_themes.length, (i) {
                        final selected = _selectedThemeIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedThemeIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: _themes[i].$2,
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(color: Colors.black26, width: 3)
                                  : null,
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: _themes[i].$2.withOpacity(0.4),
                                        blurRadius: 8,
                                      )
                                    ]
                                  : null,
                            ),
                            child: selected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 16)
                                : null,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    _label('Full Name'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: _inputDecoration('e.g. Alex Kim', primaryColor),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Name is required' : null,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    _label('Username'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _usernameCtrl,
                      decoration: _inputDecoration('@username', primaryColor),
                    ),
                    const SizedBox(height: 16),

                    _label('Bio'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _bioCtrl,
                      maxLines: 3,
                      maxLength: 120,
                      decoration: _inputDecoration('Tell us about yourself…', primaryColor),
                    ),
                    const SizedBox(height: 24),

                    // Save button
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _save,
                      child: Text(
                        _saved ? '✅ Saved' : 'Save Profile',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),

                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _reset,
                      child: const Text('Discard Changes'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.w600),
      );

  InputDecoration _inputDecoration(String hint, Color primaryColor) =>
      InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      );
}
