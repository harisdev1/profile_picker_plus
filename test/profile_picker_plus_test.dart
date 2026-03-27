import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';

void main() {
  // ─── InitialsUtils ────────────────────────────────────────────
  group('InitialsUtils', () {
    test('derives 2 initials from full name', () {
      expect(InitialsUtils.derive('Jane Doe'), 'JD');
    });

    test('derives 2 initials from multi-word name', () {
      expect(InitialsUtils.derive('John Michael Doe'), 'JD');
    });

    test('derives 1 initial from single name', () {
      expect(InitialsUtils.derive('Alice'), 'A');
    });

    test('returns uppercase', () {
      expect(InitialsUtils.derive('alice brown'), 'AB');
    });

    test('returns empty string for empty input', () {
      expect(InitialsUtils.derive(''), '');
    });

    test('trims whitespace', () {
      expect(InitialsUtils.derive('  Jane  Doe  '), 'JD');
    });
  });

  // ─── ProfilePickerStrings ─────────────────────────────────────────
  group('ProfilePickerStrings', () {
    test('default English labels', () {
      const strings = ProfilePickerStrings();
      expect(strings.galleryLabel, 'Choose from Gallery');
      expect(strings.cameraLabel, 'Take a Photo');
      expect(strings.removeLabel, 'Remove Photo');
      expect(strings.cancelLabel, 'Cancel');
    });

    test('copyWith overrides specific fields', () {
      const strings = ProfilePickerStrings();
      final custom = strings.copyWith(
        galleryLabel: 'Photo Library',
        cameraLabel: 'Selfie',
      );
      expect(custom.galleryLabel, 'Photo Library');
      expect(custom.cameraLabel, 'Selfie');
      expect(custom.cancelLabel, 'Cancel'); // unchanged
    });
  });

  // ─── ProfilePickerTheme ───────────────────────────────────────────
  group('ProfilePickerTheme', () {
    test('default primary color', () {
      const theme = ProfilePickerTheme();
      expect(theme.primaryColor,  Color(0xFF6C63FF));
    });

    test('copyWith overrides specific fields', () {
      const theme = ProfilePickerTheme();
      final custom = theme.copyWith(sheetBorderRadius: 32);
      expect(custom.sheetBorderRadius, 32);
      expect(custom.dialogBorderRadius, theme.dialogBorderRadius);
    });
  });

  // ─── ProfilePickerController ──────────────────────────────────────
  group('ProfilePickerController', () {
    test('initial state', () {
      final controller = ProfilePickerController();
      expect(controller.isOpen, false);
      expect(controller.hasImage, false);
      expect(controller.currentFile, null);
      controller.dispose();
    });

    test('pending open queued before attach', () {
      final controller = ProfilePickerController();
      bool opened = false;
      controller.open(); // called before attach

      controller.attach(
        openCallback: () => opened = true,
        closeCallback: () {},
        setImageCallback: (_) {},
      );

      expect(opened, true);
      controller.dispose();
    });
  });
}
