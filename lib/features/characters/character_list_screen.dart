import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../theme/theme_controller.dart';
import '../../widgets/app_dialog_button.dart';
import '../settings/settings_screen.dart';
import 'character_detail_screen.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({
    super.key,
    required this.database,
    required this.themeController,
  });

  final AppDatabase database;
  final ThemeController themeController;

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late Future<List<EntityRow>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = _loadCharacters();
  }

  Future<List<EntityRow>> _loadCharacters() {
    return widget.database.searchEntities('character', '');
  }

  Future<void> _refreshCharacters() async {
    if (!mounted) return;
    setState(() {
      _charactersFuture = _loadCharacters();
    });
  }

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
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          AppDialogButtonRow(
            buttons: [
              AppDialogButton(
                label: MaterialLocalizations.of(dialogContext).cancelButtonLabel,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              AppDialogButton(
                label: l10n.save,
                primary: true,
                onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
              ),
            ],
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    final id = await widget.database.createEntity('character', displayName: name);
    await widget.database.writeFact(subjectId: id, attribute: 'name', value: name);
    await _refreshCharacters();
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
                builder: (_) => SettingsScreen(themeController: widget.themeController),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<EntityRow>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          final characters = snapshot.data ?? const [];

          if (snapshot.connectionState == ConnectionState.waiting && characters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

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
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailScreen(
                        database: widget.database,
                        entityId: character.id,
                      ),
                    ),
                  );
                  await _refreshCharacters();
                },
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
