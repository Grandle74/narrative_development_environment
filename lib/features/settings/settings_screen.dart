import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(l10n.appearanceTitle, style: Theme.of(context).textTheme.titleSmall),
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.themeSystem),
                value: ThemeMode.system,
                groupValue: themeController.mode,
                onChanged: (m) => themeController.setMode(m!),
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.themeLight),
                value: ThemeMode.light,
                groupValue: themeController.mode,
                onChanged: (m) => themeController.setMode(m!),
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.themeDark),
                value: ThemeMode.dark,
                groupValue: themeController.mode,
                onChanged: (m) => themeController.setMode(m!),
              ),
            ],
          );
        },
      ),
    );
  }
}
