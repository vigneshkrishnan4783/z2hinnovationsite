import 'package:flutter/material.dart';

class Z2HColors {
  static const bgPrimary = Color(0xFF060913);
  static const bgSecondary = Color(0xFF0B1120);
  static const bgSurface = Color(0xFF11192E);
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFFCBD5E1);
  static const textMuted = Color(0xFF94A3B8);
  static const accentCyan = Color(0xFF00E5FF);
  static const accentIndigo = Color(0xFF6366F1);
  static const accentViolet = Color(0xFF8B5CF6);
  static const accentEmerald = Color(0xFF10B981);
  static const borderSubtle = Color(0x2694A3B8);
}

enum ScreenSizeClass { smallPhone, mobile, tablet, desktop }

ScreenSizeClass classifyWidth(double width) {
  if (width < 480) return ScreenSizeClass.smallPhone;
  if (width < 768) return ScreenSizeClass.mobile;
  if (width < 1080) return ScreenSizeClass.tablet;
  return ScreenSizeClass.desktop;
}

ThemeData buildZ2HTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: Z2HColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: Z2HColors.accentCyan,
      secondary: Z2HColors.accentIndigo,
      tertiary: Z2HColors.accentEmerald,
      surface: Z2HColors.bgSecondary,
      onPrimary: Color(0xFF040711),
      onSurface: Z2HColors.textPrimary,
    ),
    cardTheme: CardTheme(
      color: Z2HColors.bgSurface.withOpacity(0.75),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Z2HColors.borderSubtle),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Z2HColors.bgSecondary,
      foregroundColor: Z2HColors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Z2HColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Z2HColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Z2HColors.accentCyan),
      ),
    ),
  );
}
