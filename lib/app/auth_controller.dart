import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_queue_mobile/app/role_controller.dart';

class AuthController {
  AuthController._();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _identifierKey = 'auth_identifier';
  static const _channelKey = 'auth_channel';
  static const _roleKey = 'auth_role';
  static const _tutorialSeenKey = 'tutorial_seen';

  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  static String? _token;
  static String? _userName;
  static String? _identifier;
  static String _channel = 'email';
  static AppRole _role = AppRole.customer;
  static bool _tutorialSeen = true;

  static String? get token => _token;
  static String? get userName => _userName;
  static String? get identifier => _identifier;
  static String get channel => _channel;
  static AppRole get role => _role;
  static bool get shouldShowTutorial => isLoggedIn.value && !_tutorialSeen;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _userName = prefs.getString(_userKey);
    _identifier = prefs.getString(_identifierKey);
    _channel = prefs.getString(_channelKey) ?? 'email';
    _role = RoleController.parse(prefs.getString(_roleKey));
    _tutorialSeen = prefs.getBool(_tutorialSeenKey) ?? true;
    RoleController.role.value = _role;
    isLoggedIn.value = (_token ?? '').isNotEmpty;
  }

  static Future<void> setSession({
    required String token,
    required String userName,
    required AppRole role,
    String? identifier,
    String channel = 'email',
    bool forceTutorial = false,
  }) async {
    _token = token;
    _userName = userName;
    _identifier = identifier;
    _channel = channel;
    _role = role;
    _tutorialSeen = !forceTutorial;
    RoleController.role.value = role;
    isLoggedIn.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, userName);
    if (identifier != null && identifier.isNotEmpty) {
      await prefs.setString(_identifierKey, identifier);
    } else {
      await prefs.remove(_identifierKey);
    }
    await prefs.setString(_channelKey, channel);
    await prefs.setString(_roleKey, RoleController.serialize(role));
    await prefs.setBool(_tutorialSeenKey, _tutorialSeen);
  }

  static Future<void> markTutorialSeen() async {
    _tutorialSeen = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialSeenKey, true);
  }

  static Future<void> clearSession() async {
    _token = null;
    _userName = null;
    _identifier = null;
    _channel = 'email';
    _role = AppRole.customer;
    _tutorialSeen = true;
    RoleController.role.value = AppRole.customer;
    isLoggedIn.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_identifierKey);
    await prefs.remove(_channelKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_tutorialSeenKey);
  }
}
