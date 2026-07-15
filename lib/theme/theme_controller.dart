import 'package:flutter/material.dart';

import '../data/database.dart';
import 'app_theme.dart';

const _themeModeSettingKey = 'theme_mode';
const _darkVariantSettingKey = 'dark_variant';

/// Holds the active [ThemeMode] and [DarkVariant], persisting both to
/// the local database so preferences survive restarts.
class ThemeController extends ChangeNotifier {
  ThemeController(this._database) {
    _load();
  }

  final AppDatabase _database;
  ThemeMode _mode = ThemeMode.system;
  DarkVariant _darkVariant = DarkVariant.gray;

  ThemeMode get mode => _mode;
  DarkVariant get darkVariant => _darkVariant;

  Future<void> _load() async {
    final storedMode = await _database.getSetting(_themeModeSettingKey);
    final storedVariant = await _database.getSetting(_darkVariantSettingKey);
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
}
