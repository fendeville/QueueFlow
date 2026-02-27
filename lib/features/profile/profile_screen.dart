import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Profile Photo'),
          trailing: TextButton(
            onPressed: () {}, // TODO: Implement photo upload
            child: const Text('Upload'),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          title: const Text('Quick Tutorial'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {}, // TODO: Link to tutorial
        ),
        ListTile(
          title: const Text('Notification Preferences'),
          trailing: const Icon(Icons.notifications),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Sign Out'),
          textColor: Colors.redAccent,
          onTap: () {}, // TODO: Implement sign out
        ),
      ],
    );
  }
}
