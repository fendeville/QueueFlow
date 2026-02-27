import 'package:the_queue_mobile/features/onboarding/onboarding_screen.dart';
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
        return QueueFlowLoaderScreen();
      case AppRoutes.gallery:
        // return const PrototypeGalleryScreen();
        // Restored: fall through to normal navigation
        return OnboardingScreen();
      case AppRoutes.onboarding:
      case AppRoutes.login:
      case AppRoutes.signup:
        return OnboardingLoginScreen();
      case AppRoutes.customerHome:
      case AppRoutes.home:
        return CustomerHomeScreen();
      case AppRoutes.ticketIssuance:
        return TicketIssuanceScreen();
      case AppRoutes.liveTicketDetail:
        return LiveTicketDetailScreen();
      case AppRoutes.notifications:
        return NotificationCenterScreen();
      case AppRoutes.tutorial:
        return TutorialGuideScreen();
      case AppRoutes.branchMap:
        return BranchMapScreen();
      case AppRoutes.kioskIssuance:
        return KioskIssuanceScreen();
      case AppRoutes.staffDashboard:
        return StaffDashboardScreen();
      case AppRoutes.staffCounterView:
        return StaffCounterViewScreen();
      case AppRoutes.adminHome:
        return AdminHomeScreen();
      case AppRoutes.analyticsDashboard:
        return AnalyticsDashboardScreen();
      case AppRoutes.settingsProfile:
      case AppRoutes.settings:
        return SettingsProfileScreen();
      case AppRoutes.myTickets:
        return MyTicketsScreen();
      case AppRoutes.history:
        return HistoryScreen();
      case AppRoutes.profile:
        return ProfileScreen();
      case AppRoutes.staffSettings:
        return StaffSettingsScreen();
      case AppRoutes.branchManagement:
        return BranchManagementScreen();
      default:
        return QueueFlowLoaderScreen();
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
        builder: (_) => OnboardingLoginScreen(),
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
