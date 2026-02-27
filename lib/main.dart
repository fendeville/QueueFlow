import 'package:flutter/material.dart';
import 'package:the_queue_mobile/app/app.dart';
import 'package:the_queue_mobile/app/auth_controller.dart';
import 'package:the_queue_mobile/app/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.init();
  await AuthController.init();
  runApp(const TheQueueApp());
}
