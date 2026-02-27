import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: CircleAvatar(radius: 28, child: Icon(Icons.person)),
            title: Text('Neville Elonge'),
            subtitle: Text('App Owner & Administrator\nwatchtech.space'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    title: Text('Queue Status'),
                    subtitle: Text('All Systems Go'),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: ListTile(
                    title: Text('Active Roles'),
                    subtitle: Text('2 Assigned'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Admin View'),
                  subtitle: Text(
                    'Full access to analytics and branch management',
                  ),
                  trailing: Icon(Icons.check_circle, color: Colors.blue),
                ),
                ListTile(
                  title: Text('Staff View'),
                  subtitle: Text('Manage counters and serve live tickets'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: true,
                  onChanged: (_) {},
                  title: Text('Dark Mode Appearance'),
                ),
                SwitchListTile(
                  value: true,
                  onChanged: (_) {},
                  title: Text('Push Notifications'),
                ),
                SwitchListTile(
                  value: true,
                  onChanged: (_) {},
                  title: Text('SMS Templates'),
                ),
                SwitchListTile(
                  value: true,
                  onChanged: (_) {},
                  title: Text('Email Summaries'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text('Device Management'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: Text('Sign Out'),
            textColor: Colors.redAccent,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'QueueFlow Enterprise v2.4.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
