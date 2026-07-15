import 'package:flutter/material.dart';

/// Which dark background style is active. Both use the same neutral +
/// blue-accent scheme; only the surface darkness differs.
enum DarkVariant { oled, gray }

/// Clean monochrome base (Material 3's "neutral" dynamic scheme variant
/// keeps surfaces low-chroma instead of tinting everything toward the
/// seed hue) with a single blue accent used deliberately for active
/// state — selected chips, primary buttons, switches. Buttons are
/// rounded-rect, not pill-shaped, and sized to stretch full width when
/// wrapped in Expanded.
class AppTheme {
  AppTheme._();

  static const Color _accent = Color(0xFF0A84FF);
  static const double _radius = 14;

  static ThemeData get light => _build(Brightness.light);

  static ThemeData dark(DarkVariant variant) {
    final base = _build(Brightness.dark);
    if (variant == DarkVariant.gray) return base;

    // OLED: push the neutral-dark surfaces down to true black, keep
    // everything else (accent, text colors, elevation steps) as-is.
    final scheme = base.colorScheme.copyWith(
      surface: Colors.black,
      surfaceContainerLowest: Colors.black,
      surfaceContainerLow: const Color(0xFF0A0A0A),
      surfaceContainer: const Color(0xFF121212),
      surfaceContainerHigh: const Color(0xFF1C1C1E),
      surfaceContainerHighest: const Color(0xFF242426),
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: base.appBarTheme.copyWith(backgroundColor: Colors.black),
    );
  }

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    );
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius));

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: buttonShape,
          minimumSize: const Size.fromHeight(50),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: buttonShape,
          minimumSize: const Size.fromHeight(50),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: buttonShape),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.primary : null,
        ),
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
