import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlaceholderScreen(
        title: 'Notifications',
        subtitle: 'Alerts, reminders, and important queue events',
        items: [
          'New booking alert',
          'Queue capacity reached',
          'No-show reminders',
          'System status updates',
        ],
      ),
    );
  }
}
