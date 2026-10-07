import 'package:flutter/material.dart';

class IronGorgeColors {
  static const background = Color(0xFF070B10);
  static const panel = Color(0xFF101820);
  static const panelRaised = Color(0xFF17232B);
  static const line = Color(0xFF2A3A43);
  static const cyan = Color(0xFF54D9DC);
  static const amber = Color(0xFFF0B45B);
  static const red = Color(0xFFE7655D);
  static const green = Color(0xFF7BCD76);
  static const text = Color(0xFFE8EFF0);
  static const muted = Color(0xFF8799A0);
}

ThemeData buildIronGorgeTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: IronGorgeColors.cyan,
    brightness: Brightness.dark,
    surface: IronGorgeColors.panel,
  );
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: scheme.copyWith(
      primary: IronGorgeColors.cyan,
      secondary: IronGorgeColors.amber,
      surface: IronGorgeColors.panel,
      error: IronGorgeColors.red,
    ),
    scaffoldBackgroundColor: IronGorgeColors.background,
    fontFamily: 'sans-serif',
    useMaterial3: true,
    splashFactory: NoSplash.splashFactory,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: IronGorgeColors.text, letterSpacing: 0.2),
      bodySmall: TextStyle(color: IronGorgeColors.muted, letterSpacing: 0.5),
      titleMedium: TextStyle(
          color: IronGorgeColors.text,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3),
      labelLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2),
    ),
  );
}
