import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Profile',
      subtitle: 'Personal info, preferences, and account status',
      items: [
        'Edit profile details',
        'Business details',
        'Notification preferences',
        'Security and sign out',
      ],
    );
  }
}
