import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class QueuesScreen extends StatelessWidget {
  const QueuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Queues',
      subtitle: 'Manage active queues and monitor wait times',
      items: [
        'Main branch queue',
        'Priority queue',
        'Walk-in queue',
        'Completed queue history',
      ],
    );
  }
}
