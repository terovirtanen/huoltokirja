import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF9A6B00);
  static const _secondary = Color(0xFF6F5A00);
  static const _surface = Color(0xFFFFF8E8);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      secondary: _secondary,
      surface: _surface,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.primaryContainer.withValues(alpha: 0.45),
        foregroundColor: scheme.onSurface,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: scheme.surface),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      cardTheme: CardThemeData(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: scheme.surface,
        shadowColor: scheme.primary.withValues(alpha: 0.12),
      ),
    );
  }
}
