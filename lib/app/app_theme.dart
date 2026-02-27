import 'package:flutter/material.dart';

ThemeData buildAppTheme({required Brightness brightness}) {
  const base = Color(0xFF58A7FF);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: base,
    brightness: brightness,
  );
  final isDark = brightness == Brightness.dark;

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: isDark
        ? const Color(0xFF0D131C)
        : const Color(0xFFF4F7FC),
    textTheme:
        (isDark
                ? ThemeData.dark(useMaterial3: true)
                : ThemeData.light(useMaterial3: true))
            .textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: isDark
          ? const Color(0xFF101823)
          : const Color(0xFFFFFFFF),
      foregroundColor: isDark ? Colors.white : const Color(0xFF111827),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: isDark ? const Color(0xFF141E2B) : const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: isDark ? const Color(0xFF101823) : const Color(0xFFFFFFFF),
      filled: true,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF283A4D) : const Color(0xFFD1D5DB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF58A7FF)),
      ),
    ),
    dividerColor: isDark ? const Color(0xFF1F2C3B) : const Color(0xFFE5E7EB),
  );
}
