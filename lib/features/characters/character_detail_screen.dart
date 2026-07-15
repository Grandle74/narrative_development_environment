import 'package:flutter/material.dart';

import '../../data/attribute_labels.dart';
import '../../data/database.dart';
import '../../data/enum_options.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_dialog_button.dart';
import '../../widgets/inputs/attribute_fields.dart';
import '../../widgets/lockable_field.dart';

/// Section display order. Matches AttributeDefinition.layer values.
const List<String> _sectionOrder = [
  'identity',
  'narrative',
  'internal_state',
  'decision_model',
  'knowledge',
  'expression',
];

/// Field display order within each section. Anything not listed here
/// (a future attribute added to the registry) still renders — it just
/// falls to the end of its section instead of erroring.
const List<String> _fieldOrder = [
  'name', 'alias', 'species', 'birth',
  'status', 'location', 'arc', 'role', 'affiliation',
  'production_status', 'narrative_function', 'first_appearance',
  'core_belief', 'core_desire', 'core_fear', 'core_conflict',
  'decision_process', 'never_does', 'never_says', 'never_admits',
  'known_secret', 'hidden_secret', 'false_assumption',
  'dialogue_style', 'typical_behavior', 'body_language',
];

const Set<String> _shortTextFields = {'name', 'alias', 'species', 'role'};

class CharacterDetailScreen extends StatefulWidget {
  const CharacterDetailScreen({
    super.key,
    required this.database,
    required this.entityId,
  });

  final AppDatabase database;
  final String entityId;

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late Future<_FormData> _future;
  final Map<String, String> _edits = {};
  // Fields explicitly unlocked for this session only. Cleared on every
  // save/reload — unlocking is deliberate and temporary, not permanent.
  final Set<String> _unlockedFields = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_FormData> _load() async {
    final defs = await (widget.database.select(widget.database.attributeDefinitions)
          ..where((a) => a.appliesTo.equals('character')))
        .get();
    defs.sort((a, b) {
      final ai = _fieldOrder.indexOf(a.attrKey);
      final bi = _fieldOrder.indexOf(b.attrKey);
      if (ai == -1 && bi == -1) return a.attrKey.compareTo(b.attrKey);
      if (ai == -1) return 1;
      if (bi == -1) return -1;
      return ai.compareTo(bi);
    });
    final current = await widget.database.currentAttributeValues(widget.entityId);
    return _FormData(definitions: defs, current: current);
  }

  Future<void> _save(_FormData data) async {
    setState(() => _saving = true);
    for (final entry in _edits.entries) {
      final attrKey = entry.key;
      final newValue = entry.value;
      final existingFact = data.current[attrKey];
      if (existingFact?.value == newValue) continue;

      await widget.database.writeFact(
        subjectId: widget.entityId,
        attribute: attrKey,
        value: newValue,
        supersedes: existingFact?.id,
      );

      if (attrKey == 'name') {
        await widget.database.renameEntity(widget.entityId, newValue);
      }
    }

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final savedLabel = AppLocalizations.of(context)!.saved;
    setState(() {
      _saving = false;
      _edits.clear();
      _unlockedFields.clear();
      _future = _load();
    });
    messenger.showSnackBar(SnackBar(content: Text(savedLabel)));
  }

  Future<void> _confirmUnlock(String attrKey) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.unlockFieldTitle),
        content: Text(l10n.unlockFieldBody),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          AppDialogButtonRow(
            buttons: [
              AppDialogButton(
                label: MaterialLocalizations.of(dialogContext).cancelButtonLabel,
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              AppDialogButton(
                label: l10n.unlockConfirm,
                primary: true,
                onPressed: () => Navigator.of(dialogContext).pop(true),
              ),
            ],
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _unlockedFields.add(attrKey));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.characterDetailTitle)),
      body: FutureBuilder<_FormData>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final bySection = <String, List<AttributeDefinition>>{};
          for (final def in data.definitions) {
            bySection.putIfAbsent(def.layer, () => []).add(def);
          }
          final sections = [
            ..._sectionOrder,
            ...bySection.keys.where((s) => !_sectionOrder.contains(s)),
          ];

          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              for (final section in sections)
                if (bySection[section] != null)
                  ExpansionTile(
                    title: Text(sectionLabel(l10n, section)),
                    initiallyExpanded: section == 'identity',
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        child: Column(
                          children: [
                            for (final def in bySection[section]!)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildField(l10n, data, def),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
            ],
          );
        },
      ),
      floatingActionButton: FutureBuilder<_FormData>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: _saving ? null : () => _save(snapshot.data!),
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(l10n.save),
          );
        },
      ),
    );
  }

  Widget _buildField(AppLocalizations l10n, _FormData data, AttributeDefinition def) {
    final currentFact = data.current[def.attrKey];
    final currentValue = _edits[def.attrKey] ?? currentFact?.value;
    final unlocked = _unlockedFields.contains(def.attrKey);
    final locked = !def.mutable && currentFact != null && !unlocked;
    final enabled = def.mutable || currentFact == null || unlocked;

    return LockableField(
      locked: locked,
      tooltip: l10n.unlock,
      onUnlock: () => _confirmUnlock(def.attrKey),
      child: AttributeField(
        label: attributeLabel(l10n, def.attrKey),
        valueType: def.valueType,
        initialValue: currentValue,
        enabled: enabled,
        multiline: !_shortTextFields.contains(def.attrKey),
        options: EnumOptions.optionsFor(def.attrKey),
        optionLabel: (v) => enumOptionLabel(l10n, def.attrKey, v),
        onChanged: (value) => _edits[def.attrKey] = value,
      ),
    );
  }
}

class _FormData {
  _FormData({required this.definitions, required this.current});
  final List<AttributeDefinition> definitions;
  final Map<String, FactRow> current;
}
