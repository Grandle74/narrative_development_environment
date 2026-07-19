import 'package:flutter/material.dart';

import '../../data/attribute_labels.dart';
import '../../data/database.dart';
import '../../data/enum_options.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/inputs/attribute_fields.dart';
import '../../widgets/inputs/nationality_picker.dart';
import '../../widgets/inputs/power_selector.dart';

/// Section display order. Matches AttributeDefinition.layer values.
const List<String> _sectionOrder = [
  'identity',
  'powers',
  'narrative',
  'internal_state',
  'decision_model',
  'knowledge',
  'expression',
];

/// Above this width identity and powers are shown side-by-side.
const double _wideBreakpoint = 720;

/// Field display order within each section. Anything not listed here
/// (a future attribute added to the registry) still renders — it just
/// falls to the end of its section instead of erroring. The 'powers'
/// section is rendered separately by PowersGrid and doesn't use this.
const List<String> _fieldOrder = [
  'name', 'alias', 'species', 'birth', 'nationality',
  'participated_arcs', 'role', 'affiliation',
  'production_status', 'narrative_purpose',
  'first_appearance_volume', 'first_appearance_chapter',
  'core_belief', 'core_desire', 'core_fear', 'core_conflict',
  'decision_process', 'never_does', 'never_says', 'never_admits',
  'known_secret', 'hidden_secret', 'false_assumption',
  'dialogue_style', 'typical_behavior', 'body_language',
];

const Set<String> _shortTextFields = {'name'};

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
  final Map<String, bool> _identityLocks = {};
  bool _firstAppearanceLocked = true;
  bool _saving = false;

  /// Returns true if any lockable field is currently unlocked.
  /// Saving is blocked while this is true to prevent accidental edits.
  bool get _hasUnlockedLockableFields {
    // First-appearance fields are locked by default (true = locked).
    if (!_firstAppearanceLocked) return true;
    // Identity fields are locked by default; unlocked when the user toggled them.
    // _identityLocks[key] == true means the user unlocked that field.
    return _identityLocks.values.any((unlocked) => unlocked);
  }

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
      _future = _load();
    });
    messenger.showSnackBar(SnackBar(content: Text(savedLabel)));
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

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= _wideBreakpoint;
              if (isWide) {
                return _buildWideBody(l10n, data, bySection, sections);
              }
              // ── Narrow / mobile layout (unchanged) ──
              return ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  for (final section in sections)
                    if (bySection[section] != null)
                      ExpansionTile(
                        title: Text(sectionLabel(l10n, section)),
                        initiallyExpanded:
                            section == 'identity' || section == 'powers',
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            child: section == 'powers'
                                ? _buildPowersGrid(data)
                                : Column(
                                    children: _buildSectionFields(
                                        l10n, data, bySection[section]!),
                                  ),
                          ),
                        ],
                      ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<_FormData>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final blocked = _hasUnlockedLockableFields;
          final button = FloatingActionButton.extended(
            onPressed: (_saving || blocked) ? null : () => _save(snapshot.data!),
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(blocked ? Icons.lock_open : Icons.check),
            label: Text(blocked ? l10n.lockAllFieldsToSave : l10n.save),
          );
          if (blocked) {
            return Tooltip(
              message: l10n.lockAllFieldsToSave,
              child: button,
            );
          }
          return button;
        },
      ),
    );
  }

  // ─── Wide-screen body ────────────────────────────────────────────────────
  //
  // Identity (left) | Powers (right) at the top, all other sections below.

  Widget _buildWideBody(
    AppLocalizations l10n,
    _FormData data,
    Map<String, List<AttributeDefinition>> bySection,
    List<String> sections,
  ) {
    final remainingSections = sections
        .where((s) => s != 'identity' && s != 'powers' && bySection[s] != null)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top row: identity | powers, same height ──
          // IntrinsicHeight measures the taller column (identity) then
          // constrains both to that height via CrossAxisAlignment.stretch.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left: identity section (ExpansionTile, grows to content)
                Expanded(
                  child: ExpansionTile(
                    title: Text(sectionLabel(l10n, 'identity')),
                    initiallyExpanded: true,
                    children: [
                      if (bySection['identity'] != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          child: Column(
                            children: _buildSectionFields(
                                l10n, data, bySection['identity']!),
                          ),
                        ),
                    ],
                  ),
                ),
                // Right: powers — Column with Expanded so PowersGrid fills
                // the same height as identity rather than shrinking.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header row matching ExpansionTile's visual style
                      ListTile(
                        title: Text(
                          sectionLabel(l10n, 'powers'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        trailing: Icon(
                          Icons.expand_less,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      // Expanded forces PowersGrid to fill the remaining height
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          child: _buildPowersGrid(data),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Remaining sections below, full width ──
          for (final section in remainingSections)
            ExpansionTile(
              title: Text(sectionLabel(l10n, section)),
              initiallyExpanded: false,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Column(
                    children:
                        _buildSectionFields(l10n, data, bySection[section]!),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionFields(AppLocalizations l10n, _FormData data, List<AttributeDefinition> defs) {
    final widgets = <Widget>[];
    
    // First Appearance (Volume) and First Appearance (Chapter) should be side-by-side.
    final List<AttributeDefinition> normalDefs = [];
    AttributeDefinition? volDef;
    AttributeDefinition? chapDef;

    for (final def in defs) {
      if (def.attrKey == 'first_appearance_volume') {
        volDef = def;
      } else if (def.attrKey == 'first_appearance_chapter') {
        chapDef = def;
      } else {
        normalDefs.add(def);
      }
    }

    // Add all normal fields
    for (final def in normalDefs) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildField(l10n, data, def),
      ));
    }

    // Add side-by-side first appearance with a single external lock button
    if (volDef != null || chapDef != null) {
      final locked = _firstAppearanceLocked;

      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (volDef != null)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: chapDef != null ? 4 : 0),
                  child: _buildFirstAppearanceField(l10n, data, volDef, enabled: !locked),
                ),
              ),
            if (chapDef != null)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: volDef != null ? 4 : 0),
                  child: _buildFirstAppearanceField(l10n, data, chapDef, enabled: !locked),
                ),
              ),
            // External lock button — outside the field boxes
            IconButton(
              icon: Icon(locked ? Icons.lock_outline : Icons.lock_open, size: 18),
              tooltip: locked ? l10n.unlockToEdit : l10n.lockEditing,
              onPressed: () => setState(() => _firstAppearanceLocked = !locked),
            ),
          ],
        ),
      ));
    }

    return widgets;
  }

  /// Builds a simple number field for first appearance (volume or chapter).
  /// No suffix icon — the lock lives outside the row.
  Widget _buildFirstAppearanceField(
      AppLocalizations l10n, _FormData data, AttributeDefinition def,
      {required bool enabled}) {
    final currentFact = data.current[def.attrKey];
    final currentValue = _edits[def.attrKey] ?? currentFact?.value;

    return AttributeField(
      key: ValueKey('${def.attrKey}_$enabled'),
      label: attributeLabel(l10n, def.attrKey),
      valueType: def.valueType,
      initialValue: currentValue,
      enabled: enabled,
      multiline: false,
      onChanged: (value) => setState(() => _edits[def.attrKey] = value),
    );
  }

  Widget _buildField(AppLocalizations l10n, _FormData data, AttributeDefinition def) {
    final currentFact = data.current[def.attrKey];
    final currentValue = _edits[def.attrKey] ?? currentFact?.value;
    final isIdentityField = def.layer == 'identity';
    
    // We maintain a local locked state per identity field. If not toggled, it defaults to locked (false).
    final locked = isIdentityField && !(_identityLocks[def.attrKey] ?? false);
    
    // An identity field is enabled only if it is unlocked.
    // Non-identity fields are enabled if they are mutable or have no value yet.
    final enabled = isIdentityField ? !locked : (def.mutable || currentFact == null);

    Widget? lockButton;
    if (isIdentityField) {
      lockButton = IconButton(
        icon: Icon(locked ? Icons.lock_outline : Icons.lock_open, size: 18),
        tooltip: locked ? l10n.unlockToEdit : l10n.lockEditing,
        onPressed: () => setState(() => _identityLocks[def.attrKey] = locked),
      );
    }

    if (def.attrKey == 'nationality') {
      return NationalityPickerField(
        key: ValueKey('${def.attrKey}_$enabled'),
        label: attributeLabel(l10n, def.attrKey),
        initialValue: currentValue,
        enabled: enabled,
        suffixIcon: lockButton,
        onChanged: (value) => setState(() => _edits[def.attrKey] = value),
      );
    }

    return AttributeField(
      key: ValueKey('${def.attrKey}_$enabled'),
      label: attributeLabel(l10n, def.attrKey),
      valueType: def.valueType,
      initialValue: currentValue,
      enabled: enabled,
      multiline: !_shortTextFields.contains(def.attrKey),
      options: EnumOptions.optionsFor(def.attrKey),
      optionLabel: (v) => enumOptionLabel(l10n, def.attrKey, v),
      suffixIcon: lockButton,
      onChanged: (value) {
        setState(() {
          _edits[def.attrKey] = value;
        });
        if (def.attrKey == 'name') {
          // Persist display name immediately so lists update without pressing Save.
          widget.database.renameEntity(widget.entityId, value);
        }
      },
    );
  }

  /// The Powers section spans multiple attributes (main_power +
  /// stone_1_power..stone_8_power) so it renders as one composite
  /// widget instead of one AttributeField per definition.
  Widget _buildPowersGrid(_FormData data) {
    String? valueOf(String key) => _edits[key] ?? data.current[key]?.value;

    void setValue(String key, String? value) {
      setState(() => _edits[key] = value ?? '');
    }

    return PowersGrid(
      mainPower: valueOf('main_power'),
      stonePowers: [for (var i = 1; i <= 9; i++) valueOf('stone_${i}_power')],
      onMainPowerChanged: (v) => setValue('main_power', v),
      onStonePowerChanged: (index, v) => setValue('stone_${index + 1}_power', v),
    );
  }
}

class _FormData {
  _FormData({required this.definitions, required this.current});
  final List<AttributeDefinition> definitions;
  final Map<String, FactRow> current;
}
