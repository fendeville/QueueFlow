import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Dashboard',
      subtitle: 'Overview of your queue activity and quick actions',
      items: [
        'Today\'s queue load',
        'Peak hours insight',
        'Recent customer actions',
        'Quick create queue',
      ],
    );
  }
}
