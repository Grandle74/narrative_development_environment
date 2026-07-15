import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../theme/theme_controller.dart';
import '../settings/settings_screen.dart';
import 'character_detail_screen.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({
    super.key,
    required this.database,
    required this.themeController,
  });

  final AppDatabase database;
  final ThemeController themeController;

  Future<void> _addCharacter(BuildContext context) async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.addCharacter),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.nameLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    final id = await database.createEntity('character', displayName: name);
    await database.writeFact(subjectId: id, attribute: 'name', value: name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.charactersTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SettingsScreen(themeController: themeController),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<EntityRow>>(
        stream: database.watchEntitiesByType('character'),
        builder: (context, snapshot) {
          final characters = snapshot.data ?? const [];

          if (characters.isEmpty) {
            return Center(child: Text(l10n.noCharactersYet));
          }

          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return ListTile(
                title: Text(
                  character.displayName.isEmpty ? l10n.unnamedCharacter : character.displayName,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CharacterDetailScreen(
                      database: database,
                      entityId: character.id,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCharacter(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
