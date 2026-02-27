import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlaceholderScreen(
        title: 'Settings',
        subtitle: 'App behavior, preferences, and integrations',
        items: [
          'Theme and appearance',
          'Language and region',
          'Business hours',
          'Connected services',
        ],
      ),
    );
  }
}
