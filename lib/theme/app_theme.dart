import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Colors
  static const Color primary    = Color(0xFF1A1A2E);
  static const Color accent     = Color(0xFFE94560);
  static const Color accentLight= Color(0xFFFF6B8A);
  static const Color surface    = Color(0xFFF8F9FA);
  static const Color card       = Colors.white;
  static const Color textPrimary= Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color gold       = Color(0xFFF59E0B);
  static const Color success    = Color(0xFF10B981);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'SF Pro Display',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: surface,
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
      ),
    ),
  );
}

class AppSpacing {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;
}
