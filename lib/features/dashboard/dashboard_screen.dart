import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _RealtimeClock(prefix: 'Admin • '),
          const SizedBox(height: 16),
          Text(
            'Sector Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text('All'),
                selected: true,
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: Text('Banking'),
                selected: false,
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: Text('Health'),
                selected: false,
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: Text('Utility'),
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Edit Schedules'),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () {}, // TODO: Implement schedule editing
          ),
          ListTile(
            title: const Text('Analytics'),
            trailing: const Icon(Icons.analytics),
            onTap: () {}, // TODO: Link to analytics dashboard
          ),
        ],
      ),
    );
  }
}
