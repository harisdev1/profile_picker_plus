import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';

void main() {
  group('ProfileDisplay widget', () {
    testWidgets('renders initials when no image provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProfileDisplay(
                fallbackInitials: 'JD',
                radius: 40,
              ),
            ),
          ),
        ),
      );
      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('derives initials from full name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProfileDisplay(
                fallbackInitials: 'Jane Doe',
                radius: 40,
              ),
            ),
          ),
        ),
      );
      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('shows placeholder when no initials or image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProfileDisplay(radius: 40),
            ),
          ),
        ),
      );
      // Default placeholder shows a person icon
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('custom placeholder widget is shown', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProfileDisplay(
                radius: 40,
                placeholder: const Text('custom-placeholder'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('custom-placeholder'), findsOneWidget);
    });
  });

  group('ProfilePickerThemeProvider', () {
    testWidgets('provides theme to descendants', (tester) async {
      const testColor = Colors.orange;
      ProfilePickerTheme? capturedTheme;

      await tester.pumpWidget(
        ProfilePickerThemeProvider(
          theme: const ProfilePickerTheme(primaryColor: testColor),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                capturedTheme = ProfilePickerThemeProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme?.primaryColor, testColor);
    });

    testWidgets('falls back to default theme when no provider', (tester) async {
      ProfilePickerTheme? capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedTheme = ProfilePickerThemeProvider.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme?.primaryColor,
          const ProfilePickerTheme().primaryColor);
    });
  });
}
