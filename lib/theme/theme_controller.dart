import 'package:flutter/material.dart';

import '../data/database.dart';
import 'app_theme.dart';

const _themeModeSettingKey = 'theme_mode';
const _darkVariantSettingKey = 'dark_variant';
const _themeSeedColorKey = 'theme_seed_color';
const _themeSavedColorsKey = 'theme_saved_colors';
const _appLocaleKey = 'app_locale';

// Default Antigravity-like blue
const _defaultSeedColor = Color(0xFF0A84FF);

/// Holds active ThemeMode, DarkVariant, Color, and Locale preferences,
/// persisting everything to the local database so it survives restarts.
class ThemeController extends ChangeNotifier {
  ThemeController(this._database) {
    _load();
  }

  final AppDatabase _database;
  
  ThemeMode _mode = ThemeMode.system;
  DarkVariant _darkVariant = DarkVariant.gray;
  Color _seedColor = _defaultSeedColor;
  List<Color> _savedColors = [];
  Locale? _locale;

  ThemeMode get mode => _mode;
  DarkVariant get darkVariant => _darkVariant;
  Color get seedColor => _seedColor;
  List<Color> get savedColors => _savedColors;
  Locale? get locale => _locale;

  Future<void> _load() async {
    final storedMode = await _database.getSetting(_themeModeSettingKey);
    final storedVariant = await _database.getSetting(_darkVariantSettingKey);
    final storedSeed = await _database.getSetting(_themeSeedColorKey);
    final storedSaved = await _database.getSetting(_themeSavedColorsKey);
    final storedLocale = await _database.getSetting(_appLocaleKey);
    
    var changed = false;

    if (storedMode != null) {
      final match = ThemeMode.values.where((m) => m.name == storedMode);
      if (match.isNotEmpty) {
        _mode = match.first;
        changed = true;
      }
    }
    if (storedVariant != null) {
      final match = DarkVariant.values.where((v) => v.name == storedVariant);
      if (match.isNotEmpty) {
        _darkVariant = match.first;
        changed = true;
      }
    }
    if (storedSeed != null) {
      final parsed = int.tryParse(storedSeed, radix: 16);
      if (parsed != null) {
        _seedColor = Color(parsed);
        changed = true;
      }
    }
    if (storedSaved != null && storedSaved.isNotEmpty) {
      final parts = storedSaved.split(',');
      _savedColors = parts.map((p) => int.tryParse(p, radix: 16)).whereType<int>().map((i) => Color(i)).toList();
      changed = true;
    }
    if (storedLocale != null && storedLocale.isNotEmpty) {
      _locale = Locale(storedLocale);
      changed = true;
    }

    if (changed) notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    await _database.setSetting(_themeModeSettingKey, mode.name);
  }

  Future<void> setDarkVariant(DarkVariant variant) async {
    if (variant == _darkVariant) return;
    _darkVariant = variant;
    notifyListeners();
    await _database.setSetting(_darkVariantSettingKey, variant.name);
  }

  Future<void> setSeedColor(Color color) async {
    if (color.toARGB32() == _seedColor.toARGB32()) return;
    _seedColor = color;
    notifyListeners();
    await _database.setSetting(_themeSeedColorKey, color.toARGB32().toRadixString(16));
  }

  Future<void> saveColor(Color color) async {
    if (_savedColors.any((c) => c.toARGB32() == color.toARGB32())) return;
    _savedColors = List.from(_savedColors)..add(color);
    notifyListeners();
    await _persistSavedColors();
  }

  Future<void> removeSavedColor(Color color) async {
    _savedColors = _savedColors.where((c) => c.toARGB32() != color.toARGB32()).toList();
    notifyListeners();
    await _persistSavedColors();
  }

  Future<void> _persistSavedColors() async {
    final str = _savedColors.map((c) => c.toARGB32().toRadixString(16)).join(',');
    await _database.setSetting(_themeSavedColorsKey, str);
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale?.languageCode == _locale?.languageCode) return;
    _locale = locale;
    notifyListeners();
    await _database.setSetting(_appLocaleKey, locale?.languageCode ?? '');
  }
}
