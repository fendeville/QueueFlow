import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class QueuesScreen extends StatelessWidget {
  const QueuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QueueFlow')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Welcome', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Please select a service to get your queue ticket.'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'CURRENTLY SERVING',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'A-142',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'IN WAITING',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('08 Persons', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.account_balance, color: Colors.blue),
              title: Text('Banking Services'),
              subtitle: Text('Deposits, withdrawals, & account queries'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('12 min'), Text('')],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.medical_services, color: Colors.green),
              title: Text('Medical Checkup'),
              subtitle: Text('General consultations & diagnostic tests'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('45 min'), Text('')],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.electric_bolt, color: Colors.orange),
              title: Text('Utility Payments'),
              subtitle: Text('Electricity, water, and internet bills'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('5 min'), Text('')],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.accessibility_new, color: Colors.purple),
              title: Text('Priority Care'),
              subtitle: Text('Seniors, disabled, & expectant mothers'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('2 min'), Text('')],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'TICKET DELIVERY METHOD',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.print),
                  label: Text('PRINT PAPER'),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.qr_code),
                  label: Text('SCAN QR'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {}, child: Text('SELECT A SERVICE')),
          const SizedBox(height: 24),
          Text(
            'Recent Tickets',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('B4')),
              title: Text('Metropolis Bank - Branch A'),
              subtitle: Text('Next in line ... Your turn soon'),
            ),
          ),
        ],
      ),
    );
  }
}
