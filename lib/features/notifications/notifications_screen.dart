import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_active, color: Colors.blue),
              title: Text('Ticket A-124 is 2 away'),
              subtitle: Text('Tap to open live ticket'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.orange),
              title: Text('Queue capacity reached'),
              subtitle: Text('Branch A is at max capacity'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.red),
              title: Text('No-show reminder'),
              subtitle: Text('Customer B-042 missed appointment'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
