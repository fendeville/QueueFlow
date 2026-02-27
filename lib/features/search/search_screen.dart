import 'package:flutter/material.dart';
import 'package:the_queue_mobile/core/widgets/placeholder_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Search',
      subtitle: 'Find customers, tickets, and queue records',
      items: [
        'Recent searches',
        'Saved filter templates',
        'Queue ID lookup',
        'Customer name lookup',
      ],
    );
  }
}
