import 'package:flutter/material.dart';
import 'package:the_queue_mobile/app/app_routes.dart';
import 'package:the_queue_mobile/app/auth_controller.dart';
import 'package:the_queue_mobile/app/role_controller.dart';
import 'package:the_queue_mobile/app/app_theme.dart';
import 'package:the_queue_mobile/app/theme_controller.dart';
import 'package:the_queue_mobile/features/prototype/prototype_screens.dart';

class TheQueueApp extends StatelessWidget {
  const TheQueueApp({super.key});

  Widget _resolveRoute(String? name) {
    switch (name) {
      case AppRoutes.loader:
        return const QueueFlowLoaderScreen();
      case AppRoutes.gallery:
        return const PrototypeGalleryScreen();
      case AppRoutes.onboarding:
      case AppRoutes.login:
      case AppRoutes.signup:
        return const OnboardingLoginScreen();
      case AppRoutes.customerHome:
      case AppRoutes.home:
        return const CustomerHomeScreen();
      case AppRoutes.ticketIssuance:
        return const TicketIssuanceScreen();
      case AppRoutes.liveTicketDetail:
        return const LiveTicketDetailScreen();
      case AppRoutes.notifications:
        return const NotificationCenterScreen();
      case AppRoutes.tutorial:
        return const TutorialGuideScreen();
      case AppRoutes.branchMap:
        return const BranchMapScreen();
      case AppRoutes.kioskIssuance:
        return const KioskIssuanceScreen();
      case AppRoutes.staffDashboard:
        return const StaffDashboardScreen();
      case AppRoutes.staffCounterView:
        return const StaffCounterViewScreen();
      case AppRoutes.adminHome:
        return const AdminHomeScreen();
      case AppRoutes.analyticsDashboard:
        return const AnalyticsDashboardScreen();
      case AppRoutes.settingsProfile:
      case AppRoutes.settings:
        return const SettingsProfileScreen();
      case AppRoutes.myTickets:
        return const MyTicketsScreen();
      case AppRoutes.history:
        return const HistoryScreen();
      case AppRoutes.profile:
        return const ProfileScreen();
      case AppRoutes.staffSettings:
        return const StaffSettingsScreen();
      case AppRoutes.branchManagement:
        return const BranchManagementScreen();
      default:
        return const QueueFlowLoaderScreen();
    }
  }

  AppRole _requiredRole(String? name) {
    switch (name) {
      case AppRoutes.staffDashboard:
      case AppRoutes.staffCounterView:
      case AppRoutes.staffSettings:
        return AppRole.staff;
      case AppRoutes.adminHome:
      case AppRoutes.analyticsDashboard:
      case AppRoutes.branchManagement:
        return AppRole.admin;
      default:
        return AppRole.customer;
    }
  }

  Route<dynamic> _buildRoute(RouteSettings settings) {
    final requiredRole = _requiredRole(settings.name);
    final isLoggedIn = AuthController.isLoggedIn.value;
    final isAuthScreen =
        settings.name == AppRoutes.onboarding ||
        settings.name == AppRoutes.login ||
        settings.name == AppRoutes.signup ||
        settings.name == AppRoutes.loader;

    if (!isLoggedIn && !isAuthScreen) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const OnboardingLoginScreen(),
      );
    }

    if (isLoggedIn && !RoleController.canAccess(requiredRole)) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => _resolveRoute(RoleController.homeRouteForRole()),
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => _resolveRoute(settings.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) => MaterialApp(
        title: 'The Queue',
        theme: buildAppTheme(brightness: Brightness.light),
        darkTheme: buildAppTheme(brightness: Brightness.dark),
        themeMode: mode,
        themeAnimationCurve: Curves.easeInOutCubic,
        themeAnimationDuration: const Duration(milliseconds: 350),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.loader,
        onGenerateRoute: _buildRoute,
      ),
    );
  }
}
