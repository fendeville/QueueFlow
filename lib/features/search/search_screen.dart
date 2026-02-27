import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search organizations or services',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
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
                label: Text('Healthcare'),
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
          Card(
            child: ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Metropolis National Bank'),
              subtitle: Text('Wait: 12 min • Queue: 12'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text('City Central Hospital'),
              subtitle: Text('Wait: 46 min • Queue: 12'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.electric_bolt),
              title: Text('State Electric & Water'),
              subtitle: Text('Wait: 8 min • Queue: 12'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
