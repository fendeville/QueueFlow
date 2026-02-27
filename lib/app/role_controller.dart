import 'package:flutter/material.dart';

enum AppRole { customer, staff, admin }

class RoleController {
  RoleController._();

  static final ValueNotifier<AppRole> role = ValueNotifier<AppRole>(
    AppRole.customer,
  );

  static AppRole parse(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'admin':
        return AppRole.admin;
      case 'staff':
        return AppRole.staff;
      default:
        return AppRole.customer;
    }
  }

  static String serialize(AppRole role) {
    return role.name;
  }

  static bool canAccess(AppRole required) {
    final current = role.value;
    if (required == AppRole.customer) {
      return true;
    }
    if (required == AppRole.staff) {
      return current == AppRole.staff || current == AppRole.admin;
    }
    return current == AppRole.admin;
  }

  static String homeRouteForRole() {
    switch (role.value) {
      case AppRole.admin:
        return '/admin-home';
      case AppRole.staff:
        return '/staff-dashboard';
      case AppRole.customer:
        return '/customer-home';
    }
  }
}
