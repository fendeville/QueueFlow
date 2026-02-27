import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_queue_mobile/app/app_routes.dart';
import 'package:the_queue_mobile/app/auth_controller.dart';
import 'package:the_queue_mobile/app/role_controller.dart';
import 'package:the_queue_mobile/app/theme_controller.dart';
import 'package:the_queue_mobile/core/network/api_client.dart';

Future<ApiResult> _invokeAction(
  BuildContext context, {
  required String action,
  required String endpoint,
  String method = 'POST',
  String? route,
  Map<String, dynamic>? payload,
}) async {
  final result = await ApiClient.instance.invoke(
    endpoint: endpoint,
    method: method,
    body: payload,
  );
  if (result.success && route != null && context.mounted) {
    Navigator.pushNamed(context, route);
  }
  return result;
}

class _Organization {
  const _Organization({
    required this.name,
    required this.sector,
    required this.location,
    required this.wait,
    required this.queue,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String sector;
  final String location;
  final String wait;
  final String queue;
  final String description;
  final double latitude;
  final double longitude;
}

const _organizations = <_Organization>[
  _Organization(
    name: 'BICEC Kumba Main Branch',
    sector: 'banking',
    location: 'Commercial Avenue, Kumba',
    wait: '12 min',
    queue: '9',
    description: 'Retail banking, account opening, transfer support.',
    latitude: 4.6366,
    longitude: 9.4460,
  ),
  _Organization(
    name: 'Kumba District Hospital',
    sector: 'health',
    location: 'Fiango, Kumba',
    wait: '28 min',
    queue: '14',
    description: 'Outpatient consultation, lab intake, records desk.',
    latitude: 4.6388,
    longitude: 9.4437,
  ),
  _Organization(
    name: 'ENEO & CAMWATER Kumba Desk',
    sector: 'utility',
    location: 'Town Hall Junction, Kumba',
    wait: '8 min',
    queue: '6',
    description: 'Bills, metering updates, utility requests.',
    latitude: 4.6353,
    longitude: 9.4488,
  ),
];

class QueueFlowLoaderScreen extends StatefulWidget {
  const QueueFlowLoaderScreen({super.key});

  @override
  State<QueueFlowLoaderScreen> createState() => _QueueFlowLoaderScreenState();
}

class _QueueFlowLoaderScreenState extends State<QueueFlowLoaderScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      final target = AuthController.isLoggedIn.value
          ? (AuthController.shouldShowTutorial
                ? AppRoutes.tutorial
                : RoleController.homeRouteForRole())
          : AppRoutes.onboarding;
      Navigator.pushReplacementNamed(context, target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D131C),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, color: Color(0xFF58A7FF), size: 64),
            SizedBox(height: 12),
            Text(
              'QueueFlow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Preparing your workspace...',
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class PrototypeGalleryScreen extends StatelessWidget {
  const PrototypeGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[
      ('Customer Home', AppRoutes.customerHome),
      ('Ticket Issuance', AppRoutes.ticketIssuance),
      ('Live Ticket', AppRoutes.liveTicketDetail),
      ('Branch Map', AppRoutes.branchMap),
      ('Settings', AppRoutes.settingsProfile),
    ];
    return _ScreenScaffold(
      title: 'Prototype Gallery',
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => ListTile(
          tileColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(items[i].$1),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, items[i].$2),
        ),
      ),
    );
  }
}

class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key});

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  bool isSignIn = true;
  bool isPhone = false;
  bool revealPassword = false;
  bool isSubmitting = false;
  String? error;

  final fullName = TextEditingController();
  final identity = TextEditingController();
  final secret = TextEditingController();

  @override
  void dispose() {
    fullName.dispose();
    identity.dispose();
    secret.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final identifier = identity.text.trim();
    final password = secret.text.trim();
    final channel = isPhone ? 'phone' : 'email';

    if (!isSignIn && fullName.text.trim().isEmpty) {
      setState(() => error = 'Full name is required for sign up.');
      return;
    }
    if (identifier.isEmpty || password.isEmpty) {
      setState(() => error = 'Enter your credentials to continue.');
      return;
    }

    setState(() {
      isSubmitting = true;
      error = null;
    });

    final result = await _invokeAction(
      context,
      action: isSignIn ? 'Sign In' : 'Sign Up',
      endpoint: '/api/v1/auth/${isSignIn ? 'signin' : 'signup'}/$channel',
      payload: {
        if (!isSignIn) 'fullName': fullName.text.trim(),
        'identifier': identifier,
        'secret': password,
        'channel': channel,
      },
    );

    if (!mounted) return;
    setState(() => isSubmitting = false);

    if (!result.success) {
      setState(() => error = result.message);
      return;
    }

    final token =
        result.data?['token']?.toString() ??
        'mock-${DateTime.now().millisecondsSinceEpoch}';
    final userName =
        result.data?['user']?['name']?.toString() ??
        (fullName.text.trim().isEmpty ? identifier : fullName.text.trim());
    final role = RoleController.parse(result.data?['role']?.toString());

    await AuthController.setSession(
      token: token,
      userName: userName,
      role: role,
      identifier: identifier,
      channel: channel,
      forceTutorial: !isSignIn,
    );

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AuthController.shouldShowTutorial
          ? AppRoutes.tutorial
          : RoleController.homeRouteForRole(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      title: 'QueueFlow',
      showBack: false,
      showBottomNav: false,
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const Center(
            child: Icon(Icons.bolt, color: Color(0xFF58A7FF), size: 44),
          ),
          const SizedBox(height: 12),
          Text(
            isSignIn ? 'Welcome back' : 'Create account',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Email'),
                selected: !isPhone,
                onSelected: (_) => setState(() => isPhone = false),
              ),
              ChoiceChip(
                label: const Text('Phone'),
                selected: isPhone,
                onSelected: (_) => setState(() => isPhone = true),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Sign In'),
                selected: isSignIn,
                onSelected: (_) => setState(() => isSignIn = true),
              ),
              ChoiceChip(
                label: const Text('Sign Up'),
                selected: !isSignIn,
                onSelected: (_) => setState(() => isSignIn = false),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!isSignIn) ...[
            TextField(
              controller: fullName,
              decoration: const InputDecoration(
                hintText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: identity,
            keyboardType: isPhone
                ? TextInputType.phone
                : TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: isPhone ? 'Phone number' : 'Email address',
              prefixIcon: Icon(isPhone ? Icons.phone : Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: secret,
            obscureText: isPhone ? false : !revealPassword,
            decoration: InputDecoration(
              hintText: isPhone ? 'OTP code' : 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: isPhone
                  ? null
                  : IconButton(
                      onPressed: () =>
                          setState(() => revealPassword = !revealPassword),
                      icon: Icon(
                        revealPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!, style: const TextStyle(color: Colors.redAccent)),
          ],
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: isSubmitting ? null : _submit,
            child: Text(
              isSignIn ? 'Sign in to QueueFlow' : 'Create QueueFlow Account',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.tutorial),
            child: const Text('Open quick tutorial'),
          ),
        ],
      ),
    );
  }
}

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String sector = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = sector == 'all'
        ? _organizations
        : _organizations.where((item) => item.sector == sector).toList();

    return _ScreenScaffold(
      title: 'QueueFlow',
      navItems: const [
        _NavItem('Home', AppRoutes.customerHome),
        _NavItem('My Tickets', AppRoutes.myTickets),
        _NavItem('History', AppRoutes.history),
        _NavItem('Profile', AppRoutes.settingsProfile),
      ],
      selectedNav: 0,
      body: ListView(
        children: [
          Text(
            'OWNER: ${AuthController.userName ?? 'QueueFlow Kumba'}',
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          _RealtimeClock(
            prefix: AuthController.userName != null
                ? 'Welcome, ${AuthController.userName!} • '
                : '',
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Select Branch: Kumba Commercial Avenue'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.branchMap),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: sector == 'all',
                onSelected: (_) => setState(() => sector = 'all'),
              ),
              ChoiceChip(
                label: const Text('Banking'),
                selected: sector == 'banking',
                onSelected: (_) => setState(() => sector = 'banking'),
              ),
              ChoiceChip(
                label: const Text('Health'),
                selected: sector == 'health',
                onSelected: (_) => setState(() => sector = 'health'),
              ),
              ChoiceChip(
                label: const Text('Utility'),
                selected: sector == 'utility',
                onSelected: (_) => setState(() => sector = 'utility'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...filtered.map(
            (item) => Card(
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(
                  '${item.location}\nWait: ${item.wait} • Queue: ${item.queue}\n${item.description}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.ticketIssuance),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketIssuanceScreen extends StatefulWidget {
  const TicketIssuanceScreen({super.key});

  @override
  State<TicketIssuanceScreen> createState() => _TicketIssuanceScreenState();
}

class _TicketIssuanceScreenState extends State<TicketIssuanceScreen> {
  int visitType = 0;
  int priorityType = 0;
  DateTime scheduledAt = DateTime.now().add(const Duration(hours: 1));

  String get scheduleLabel {
    final h = scheduledAt.hour % 12 == 0 ? 12 : scheduledAt.hour % 12;
    final m = scheduledAt.minute.toString().padLeft(2, '0');
    final p = scheduledAt.hour >= 12 ? 'PM' : 'AM';
    return '${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year} • $h:$m $p';
  }

  Future<void> editSchedule() async {
    final date = await showDatePicker(
      context: context,
      initialDate: scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(scheduledAt),
    );
    if (!mounted || time == null) return;

    setState(() {
      scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isScheduled = visitType == 1;

    return _ScreenScaffold(
      title: 'Get Ticket',
      showBottomNav: false,
      body: ListView(
        children: [
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Visit Type'),
            subtitle: const Text('Choose your preference'),
            trailing: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Walk-in')),
                ButtonSegment(value: 1, label: Text('Schedule')),
              ],
              selected: {visitType},
              onSelectionChanged: (set) =>
                  setState(() => visitType = set.first),
            ),
          ),
          const SizedBox(height: 10),
          if (isScheduled) ...[
            ListTile(
              tileColor: Theme.of(context).cardColor,
              title: const Text('Preferred Time Slot'),
              subtitle: Text(scheduleLabel),
              trailing: TextButton(
                onPressed: editSchedule,
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(height: 10),
          ],
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Standard')),
              ButtonSegment(value: 1, label: Text('Priority')),
            ],
            selected: {priorityType},
            onSelectionChanged: (set) =>
                setState(() => priorityType = set.first),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () async {
              final result = await _invokeAction(
                context,
                action: 'Confirm ticket request',
                endpoint: '/api/v1/tickets/issue',
                payload: {
                  'visitType': isScheduled ? 'schedule' : 'walk-in',
                  'priority': priorityType == 1 ? 'priority' : 'standard',
                  if (isScheduled) 'scheduledAt': scheduledAt.toIso8601String(),
                },
              );
              if (!mounted || !result.success) return;
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.liveTicketDetail,
              );
            },
            child: const Text('Confirm & Get Ticket'),
          ),
        ],
      ),
    );
  }
}

class LiveTicketDetailScreen extends StatelessWidget {
  const LiveTicketDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      title: 'Live Ticket',
      navItems: const [
        _NavItem('Home', AppRoutes.customerHome),
        _NavItem('My Tickets', AppRoutes.myTickets),
        _NavItem('History', AppRoutes.history),
        _NavItem('Profile', AppRoutes.settingsProfile),
      ],
      selectedNav: 1,
      body: ListView(
        children: [
          const Card(
            child: ListTile(
              title: Text('Token A-124'),
              subtitle: Text('2 ahead • est wait 4m'),
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
            child: const Text('View Alerts'),
          ),
        ],
      ),
    );
  }
}

class KioskIssuanceScreen extends StatelessWidget {
  const KioskIssuanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScreen(title: 'Kiosk Issuance');
  }
}

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScreen(title: 'Staff Dashboard');
  }
}

class StaffCounterViewScreen extends StatelessWidget {
  const StaffCounterViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScreen(title: 'Staff Counter View');
  }
}

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScreen(title: 'Admin Home');
  }
}

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScreen(title: 'Analytics Dashboard');
  }
}

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  static const _photoPathKey = 'profile_photo_path';
  final picker = ImagePicker();
  String? photoPath;
  bool darkMode = ThemeController.isDarkMode;

  @override
  void initState() {
    super.initState();
    _loadPhoto();
  }

  Future<void> _loadPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_photoPathKey);
    if (!mounted) return;
    setState(() => photoPath = value);
  }

  Future<void> _uploadPhoto() async {
    final mode = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Upload from gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              title: const Text('Take photo with camera'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              title: const Text('Remove photo'),
              onTap: () => Navigator.pop(context, 'remove'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || mode == null) return;

    final prefs = await SharedPreferences.getInstance();
    if (mode == 'remove') {
      await prefs.remove(_photoPathKey);
      if (mounted) setState(() => photoPath = null);
      return;
    }

    final picked = await picker.pickImage(
      source: mode == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 82,
    );
    if (!mounted || picked == null) return;

    await prefs.setString(_photoPathKey, picked.path);
    setState(() => photoPath = picked.path);
  }

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      title: 'Settings',
      navItems: const [
        _NavItem('Home', AppRoutes.customerHome),
        _NavItem('My Tickets', AppRoutes.myTickets),
        _NavItem('History', AppRoutes.history),
        _NavItem('Profile', AppRoutes.settingsProfile),
      ],
      selectedNav: 3,
      body: ListView(
        children: [
          ListTile(
            tileColor: Theme.of(context).cardColor,
            leading: CircleAvatar(
              backgroundImage: photoPath != null
                  ? FileImage(File(photoPath!))
                  : null,
              child: photoPath == null ? const Icon(Icons.person) : null,
            ),
            title: Text(AuthController.userName ?? 'QueueFlow User'),
            subtitle: Text(
              '${AuthController.channel == 'phone' ? 'Phone' : 'Email'}: ${AuthController.identifier ?? 'N/A'}',
            ),
            trailing: TextButton(
              onPressed: _uploadPhoto,
              child: const Text('Upload'),
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            value: darkMode,
            onChanged: (value) {
              setState(() => darkMode = value);
              ThemeController.setDarkMode(value);
            },
            title: const Text('Dark Mode'),
          ),
          ListTile(
            title: const Text('Quick Tutorial'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.tutorial),
          ),
          ListTile(
            title: const Text('Notification Center'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          ListTile(
            title: const Text('Sign Out'),
            textColor: Colors.redAccent,
            onTap: () async {
              await AuthController.clearSession();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.onboarding,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) => _SimpleScreen(title: 'My Tickets');
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => _SimpleScreen(title: 'History');
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      title: 'Profile',
      navItems: const [
        _NavItem('Home', AppRoutes.customerHome),
        _NavItem('My Tickets', AppRoutes.myTickets),
        _NavItem('History', AppRoutes.history),
        _NavItem('Profile', AppRoutes.settingsProfile),
      ],
      selectedNav: 3,
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(AuthController.userName ?? 'QueueFlow User'),
              subtitle: Text(
                'Role: ${RoleController.serialize(AuthController.role)}\n${AuthController.channel}: ${AuthController.identifier ?? 'N/A'}',
              ),
              isThreeLine: true,
            ),
          ),
          ListTile(
            title: const Text('Open Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.settingsProfile),
          ),
        ],
      ),
    );
  }
}

class StaffSettingsScreen extends StatelessWidget {
  const StaffSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => _SimpleScreen(title: 'Staff Settings');
}

class BranchManagementScreen extends StatelessWidget {
  const BranchManagementScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      _SimpleScreen(title: 'Branch Management');
}

class BranchMapScreen extends StatefulWidget {
  const BranchMapScreen({super.key});

  @override
  State<BranchMapScreen> createState() => _BranchMapScreenState();
}

class _BranchMapScreenState extends State<BranchMapScreen> {
  LatLng? userLocation;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      if (mounted) {
        setState(() => error = 'Enable location service to use GPS map.');
      }
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => error = 'Location permission denied.');
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() => userLocation = LatLng(pos.latitude, pos.longitude));
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      for (final item in _organizations)
        Marker(
          markerId: MarkerId(item.name),
          position: LatLng(item.latitude, item.longitude),
          infoWindow: InfoWindow(title: item.name, snippet: item.location),
        ),
      if (userLocation != null)
        Marker(
          markerId: const MarkerId('me'),
          position: userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
    };

    return _ScreenScaffold(
      title: 'Branch Map',
      showBottomNav: false,
      body: ListView(
        children: [
          if (error != null)
            Text(error!, style: const TextStyle(color: Colors.redAccent)),
          Container(
            height: 360,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation ?? const LatLng(4.6363, 9.4469),
                zoom: 13.5,
              ),
              myLocationEnabled: userLocation != null,
              myLocationButtonEnabled: true,
              markers: markers,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      title: 'Notifications',
      navItems: const [
        _NavItem('Home', AppRoutes.customerHome),
        _NavItem('My Tickets', AppRoutes.myTickets),
        _NavItem('History', AppRoutes.history),
        _NavItem('Profile', AppRoutes.settingsProfile),
      ],
      selectedNav: 3,
      body: ListView(
        children: [
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Ticket A-124 is 2 away'),
            subtitle: const Text('Tap to open live ticket'),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.liveTicketDetail),
          ),
          ListTile(
            title: const Text('Mark all as checked'),
            onTap: () => _invokeAction(
              context,
              action: 'Mark all notifications checked',
              endpoint: '/api/v1/notifications/mark-all-checked',
              method: 'PATCH',
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialGuideScreen extends StatelessWidget {
  const TutorialGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      title: 'Quick Tutorial',
      showBottomNav: false,
      body: ListView(
        children: [
          const ListTile(
            title: Text('1) Find an organization'),
            subtitle: Text('Use search and sector chips on Home'),
          ),
          const ListTile(
            title: Text('2) Choose Walk-in or Schedule'),
            subtitle: Text('Set priority and schedule if needed'),
          ),
          const ListTile(
            title: Text('3) Track updates'),
            subtitle: Text('Use Notifications and Live Ticket screens'),
          ),
          const ListTile(
            title: Text('4) Use Branch Map'),
            subtitle: Text('Enable GPS and view nearby branches'),
          ),
          const ListTile(
            title: Text('5) Check-in and complete'),
            subtitle: Text('Confirm arrival and finish at counter'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await AuthController.markTutorialSeen();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoleController.homeRouteForRole(),
                (_) => false,
              );
            },
            child: const Text('Start Using QueueFlow'),
          ),
        ],
      ),
    );
  }
}

class _SimpleScreen extends StatelessWidget {
  const _SimpleScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return _ScreenScaffold(
      title: title,
      body: Center(child: Text(title)),
      showBottomNav: false,
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.route);
  final String label;
  final String route;
}

class _ScreenScaffold extends StatelessWidget {
  const _ScreenScaffold({
    required this.title,
    required this.body,
    this.navItems = const [],
    this.selectedNav = 0,
    this.showBottomNav = true,
    this.showBack = true,
  });

  final String title;
  final Widget body;
  final List<_NavItem> navItems;
  final int selectedNav;
  final bool showBottomNav;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final roots = {
      AppRoutes.customerHome,
      AppRoutes.staffDashboard,
      AppRoutes.adminHome,
      AppRoutes.onboarding,
      AppRoutes.loader,
      AppRoutes.tutorial,
    };
    final canBack =
        showBack && Navigator.canPop(context) && !roots.contains(currentRoute);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: canBack
            ? IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoleController.homeRouteForRole(),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.chevron_left),
              )
            : null,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.gallery),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(14), child: body),
      ),
      bottomNavigationBar: showBottomNav && navItems.isNotEmpty
          ? BottomNavigationBar(
              currentIndex: selectedNav,
              onTap: (index) => Navigator.pushReplacementNamed(
                context,
                navItems[index].route,
              ),
              items: navItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: const Icon(Icons.circle_outlined),
                      label: item.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}

class _RealtimeClock extends StatelessWidget {
  const _RealtimeClock({this.prefix = ''});

  final String prefix;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream<DateTime>.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
        final m = now.minute.toString().padLeft(2, '0');
        final s = now.second.toString().padLeft(2, '0');
        final p = now.hour >= 12 ? 'PM' : 'AM';
        return Text(
          '$prefix$h:$m:$s $p',
          style: const TextStyle(fontWeight: FontWeight.w700),
        );
      },
    );
  }
}
