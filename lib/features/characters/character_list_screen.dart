import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../l10n/generated/app_localizations.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key, required this.database});

  final AppDatabase database;

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
      appBar: AppBar(title: Text(l10n.charactersTitle)),
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
