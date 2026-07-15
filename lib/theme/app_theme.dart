import 'package:flutter/material.dart';

/// "Warm writer's studio" meets "dense & structured": a terracotta/sienna
/// seed instead of Material's default cool blue, tightened spacing and
/// list density so more of the knowledge graph is visible at once, and a
/// slightly heavier type scale for section headers so long forms stay
/// scannable.
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFFAD6B3F);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          color: scheme.onSurface,
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        iconColor: scheme.primary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      expansionTileTheme: ExpansionTileThemeData(
        collapsedShape: const RoundedRectangleBorder(),
        shape: const RoundedRectangleBorder(),
        iconColor: scheme.primary,
        collapsedIconColor: scheme.onSurfaceVariant,
        childrenPadding: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      textTheme: _textTheme(scheme),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    return TextTheme(
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
      titleLarge: TextStyle(fontWeight: FontWeight.w700, color: scheme.onSurface),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: scheme.primary,
      ),
      bodyLarge: TextStyle(color: scheme.onSurface, height: 1.35),
      bodyMedium: TextStyle(color: scheme.onSurface, height: 1.35),
      labelLarge: TextStyle(fontWeight: FontWeight.w600),
    );
  }
}
