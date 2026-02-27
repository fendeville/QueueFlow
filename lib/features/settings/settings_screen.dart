import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
        ],
      ),
    );
  }
}
