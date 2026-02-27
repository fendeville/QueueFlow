import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appointments & Reservations',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.event, color: Colors.blue),
              title: Text('Upcoming Booking'),
              subtitle: Text('Metropolis Bank - Branch A\n10:30 AM, 28 Feb'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.event_busy, color: Colors.red),
              title: Text('Cancelled Booking'),
              subtitle: Text('City Central Hospital\n9:00 AM, 27 Feb'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.event_repeat, color: Colors.orange),
              title: Text('Reschedule Request'),
              subtitle: Text('State Electric & Water\n2:00 PM, 1 Mar'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
