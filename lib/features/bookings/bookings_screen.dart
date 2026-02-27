import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Bookings',
      subtitle: 'Appointments and upcoming reservations',
      items: [
        'Upcoming bookings',
        'Reschedule request',
        'Cancelled bookings',
        'Booking calendar sync',
      ],
    );
  }
}
