import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.themeController});

  final ThemeController themeController;

  static const _presetColors = [
    Color(0xFF0A84FF), // Default Blue
    Color(0xFF34C759), // Green
    Color(0xFFFF9500), // Orange
    Color(0xFFFF2D55), // Pink
    Color(0xFFAF52DE), // Purple
  ];

  Future<void> _pickCustomColor(BuildContext context, AppLocalizations l10n) async {
    Color pickerColor = themeController.seedColor;

    final selected = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.customColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) => pickerColor = color,
              enableAlpha: false,
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(pickerColor),
              child: Text(l10n.saveColor),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      themeController.saveColor(selected);
      themeController.setSeedColor(selected);
    }
  }

  Widget _buildColorDot(BuildContext context, Color color, {bool isCustom = false}) {
    final isSelected = themeController.seedColor.toARGB32() == color.toARGB32();
    return GestureDetector(
      onTap: () => themeController.setSeedColor(color),
      onLongPress: isCustom ? () => themeController.removeSavedColor(color) : null,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
              : Border.all(color: Colors.black12, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

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
              // ─── LANGUAGE ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(l10n.languageTitle, style: Theme.of(context).textTheme.titleSmall),
              ),
              RadioListTile<String?>(
                title: Text(l10n.languageSystem),
                value: null,
                groupValue: themeController.locale?.languageCode,
                onChanged: (_) => themeController.setLocale(null),
              ),
              RadioListTile<String?>(
                title: Text(l10n.languageEnglish),
                value: 'en',
                groupValue: themeController.locale?.languageCode,
                onChanged: (code) => themeController.setLocale(Locale(code!)),
              ),
              RadioListTile<String?>(
                title: Text(l10n.languageArabic),
                value: 'ar',
                groupValue: themeController.locale?.languageCode,
                onChanged: (code) => themeController.setLocale(Locale(code!)),
              ),
              const Divider(height: 24),

              // ─── APPEARANCE ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
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
              const Divider(height: 24),
              
              // ─── DARK BACKGROUND VARIANT ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  l10n.darkBackgroundTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              RadioListTile<DarkVariant>(
                title: Text(l10n.darkVariantGray),
                value: DarkVariant.gray,
                groupValue: themeController.darkVariant,
                onChanged: (v) => themeController.setDarkVariant(v!),
              ),
              RadioListTile<DarkVariant>(
                title: Text(l10n.darkVariantOled),
                value: DarkVariant.oled,
                groupValue: themeController.darkVariant,
                onChanged: (v) => themeController.setDarkVariant(v!),
              ),
              const Divider(height: 24),

              // ─── THEME COLOR ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  l10n.themeColorTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final color in _presetColors)
                        _buildColorDot(context, color),
                      
                      // Custom color button
                      ActionChip(
                        label: Text(l10n.customColor),
                        avatar: const Icon(Icons.palette, size: 18),
                        onPressed: () => _pickCustomColor(context, l10n),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (themeController.savedColors.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    l10n.savedColorsTitle,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final color in themeController.savedColors)
                          _buildColorDot(context, color, isCustom: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ],
          );
        },
      ),
    );
  }
}
