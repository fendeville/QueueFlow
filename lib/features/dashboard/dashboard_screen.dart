import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Overview')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'BRANCHES',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('12 Active', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'WAITING',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('148', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'AVG. WAIT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('18.5m', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'STAFF ONLINE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('42', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Quick Management',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Branch Management'),
            subtitle: Text('Manage locations, kiosks & counters'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Service Catalog'),
            subtitle: Text('Edit banking, medical, or utility'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Staff Directory'),
            subtitle: Text('Role assignment and management'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Deep Analytics'),
            subtitle: Text('Visual reports and peak hour'),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.blue.shade50,
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('System Status'),
              subtitle: Text('QueueFlow Server Cluster Operational'),
              trailing: Text(
                'Operational',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
