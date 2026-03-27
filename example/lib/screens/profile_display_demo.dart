import 'package:flutter/material.dart';
import 'package:profile_picker_plus/profile_picker_plus.dart';
import '../demo_scaffold.dart';

class ProfileDisplayDemo extends StatelessWidget {
  const ProfileDisplayDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'ProfileDisplay',
      description:
          'Read-only display widget. Supports network URL, file, bytes, asset, '
          'initials fallback, custom shapes, and borders.',
      codeSnippet: '''
// Network image
ProfileDisplay(imageUrl: 'https://...', radius: 36)

// Initials fallback
ProfileDisplay(fallbackInitials: 'JD', radius: 36)

// Rounded rectangle shape
ProfileDisplay(
  fallbackInitials: 'RR',
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
)
''',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row(context, 'Network URL (with fallback on error)', [
            const ProfileDisplay(
              imageUrl: 'https://i.pravatar.cc/150?img=1',
              radius: 36,
            ),
            const ProfileDisplay(
              imageUrl: 'https://i.pravatar.cc/150?img=5',
              radius: 36,
            ),
            const ProfileDisplay(
              imageUrl: 'https://i.pravatar.cc/150?img=11',
              radius: 36,
            ),
          ]),
          const SizedBox(height: 24),
          _row(context, 'Initials fallback', [
            const ProfileDisplay(
              fallbackInitials: 'JD',
              radius: 36,
              initialsBackgroundColor: Colors.deepPurple,
            ),
            const ProfileDisplay(
              fallbackInitials: 'Alice Brown',
              radius: 36,
              initialsBackgroundColor: Colors.teal,
            ),
            const ProfileDisplay(
              fallbackInitials: 'Z',
              radius: 36,
              initialsBackgroundColor: Colors.orange,
            ),
          ]),
          const SizedBox(height: 24),
          _row(context, 'Custom shapes', [
            ProfileDisplay(
              fallbackInitials: 'SQ',
              radius: 36,
              initialsBackgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            ProfileDisplay(
              fallbackInitials: 'DI',
              radius: 36,
              initialsBackgroundColor: Colors.pink,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            const ProfileDisplay(
              fallbackInitials: 'CI',
              radius: 36,
              initialsBackgroundColor: Colors.green,
              // Default CircleBorder
            ),
          ]),
          const SizedBox(height: 24),
          _row(context, 'With border', [
            ProfileDisplay(
              imageUrl: 'https://i.pravatar.cc/150?img=20',
              radius: 36,
              border: Border.all(color: const Color(0xFF6C63FF), width: 3),
            ),
            ProfileDisplay(
              fallbackInitials: 'BD',
              radius: 36,
              initialsBackgroundColor: Colors.teal,
              border: Border.all(color: Colors.teal, width: 3),
            ),
            ProfileDisplay(
              fallbackInitials: 'RD',
              radius: 36,
              initialsBackgroundColor: Colors.red.shade300,
              border: Border.all(color: Colors.red.shade300, width: 3),
            ),
          ]),
          const SizedBox(height: 24),
          _row(context, 'Various sizes', [
            const ProfileDisplay(
              imageUrl: 'https://i.pravatar.cc/150?img=3',
              radius: 20,
            ),
            const ProfileDisplay(
              imageUrl: 'https://i.pravatar.cc/150?img=3',
              radius: 36,
            ),
            const ProfileDisplay(
              imageUrl: 'https://i.pravatar.cc/150?img=3',
              radius: 56,
            ),
          ]),
          const SizedBox(height: 24),
          // Placeholder demo
          Text('Custom placeholder widget',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Center(
            child: ProfileDisplay(
              radius: 48,
              placeholder: Container(
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        color: Colors.grey.shade400, size: 28),
                    const SizedBox(height: 4),
                    Text('Add photo',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade400)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items,
        ),
      ],
    );
  }
}
