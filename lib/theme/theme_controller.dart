import 'package:flutter/material.dart';

import '../data/database.dart';

const _themeModeSettingKey = 'theme_mode';

/// Holds the active [ThemeMode] and persists it to the local database so
/// a manual override survives restarts. Defaults to [ThemeMode.system]
/// until a stored preference is loaded.
class ThemeController extends ChangeNotifier {
  ThemeController(this._database) {
    _load();
  }

  final AppDatabase _database;
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> _load() async {
    final stored = await _database.getSetting(_themeModeSettingKey);
    if (stored == null) return;
    final match = ThemeMode.values.where((m) => m.name == stored);
    if (match.isEmpty) return;
    _mode = match.first;
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    await _database.setSetting(_themeModeSettingKey, mode.name);
  }
}
