import 'package:flutter/material.dart';

/// Shared scaffold for all demo screens.
/// Shows a title, description, the live demo widget, and a code snippet.
class DemoScaffold extends StatelessWidget {
  const DemoScaffold({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.codeSnippet,
  });

  final String title;
  final Widget child;
  final String? description;
  final String? codeSnippet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (description != null) ...[
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
            Center(child: child),
            if (codeSnippet != null) ...[
              const SizedBox(height: 32),
              Text('Code', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    codeSnippet!.trim(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      color: Color(0xFFCDD6F4),
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
