import 'package:flutter/material.dart';
import 'package:the_queue_mobile/app/app_routes.dart';
import 'package:the_queue_mobile/features/bookings/bookings_screen.dart';
import 'package:the_queue_mobile/features/dashboard/dashboard_screen.dart';
import 'package:the_queue_mobile/features/profile/profile_screen.dart';
import 'package:the_queue_mobile/features/queues/queues_screen.dart';
import 'package:the_queue_mobile/features/search/search_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    SearchScreen(),
    QueuesScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  final _titles = const [
    'Dashboard',
    'Search',
    'Queues',
    'Bookings',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(
                title: Text(
                  'The Queue',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('App navigation'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),
            ],
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.queue_outlined),
            label: 'Queues',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
