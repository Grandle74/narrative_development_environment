import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../l10n/generated/app_localizations.dart';

/// Dispatches to the right input widget for an AttributeDefinition's
/// `valueType`. This is the single place that knows how a value type
/// maps to a widget — screens just hand it a definition and a callback.
///
/// `entity_ref` fields degrade gracefully to plain text when their
/// target entity type doesn't exist yet in the data model (pass
/// [database] + [targetEntityType] once it does, and the real picker
/// switches on automatically).
class AttributeField extends StatelessWidget {
  const AttributeField({
    super.key,
    required this.label,
    required this.valueType,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
    this.multiline = false,
    this.options = const [],
    this.optionLabel,
    this.numberMin,
    this.numberMax,
    this.database,
    this.targetEntityType,
    this.suffixIcon,
  });

  final String label;
  final String valueType;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool multiline;

  // enum-only
  final List<String> options;
  final String Function(String value)? optionLabel;

  // number-only
  final double? numberMin;
  final double? numberMax;

  // entity_ref-only
  final AppDatabase? database;
  final String? targetEntityType;

  /// Optional widget (e.g. a lock icon button) injected into the
  /// InputDecoration suffix so it lives visually inside the field border.
  /// Not forwarded to boolean or tag_list fields (they manage their own
  /// suffix independently).
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    switch (valueType) {
      case 'boolean':
        return BooleanAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          onChanged: onChanged,
        );
      case 'number':
        return NumberAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          min: numberMin,
          max: numberMax,
          onChanged: onChanged,
          suffixIcon: suffixIcon,
        );
      case 'enum':
        return EnumAttributeField(
          label: label,
          options: options,
          optionLabel: optionLabel ?? (v) => v,
          initialValue: initialValue,
          enabled: enabled,
          onChanged: onChanged,
          suffixIcon: suffixIcon,
        );
      case 'date':
        return DateAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          onChanged: onChanged,
          suffixIcon: suffixIcon,
        );
      case 'tag_list':
        // TagListAttributeField manages its own internal lock — suffixIcon
        // is intentionally not forwarded here.
        return TagListAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          onChanged: onChanged,
        );
      case 'entity_ref':
        if (database != null && targetEntityType != null) {
          return EntityRefAttributeField(
            label: label,
            database: database!,
            targetEntityType: targetEntityType!,
            initialValue: initialValue,
            enabled: enabled,
            onChanged: onChanged,
          );
        }
        // Target entity type doesn't exist yet (Scene/Secret/Place/
        // Organization are later Parts) — fall back to text rather than
        // fake a picker with nothing to pick from.
        return TextAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          multiline: multiline,
          onChanged: onChanged,
          suffixIcon: suffixIcon,
        );
      case 'text':
      default:
        return TextAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          multiline: multiline,
          onChanged: onChanged,
          suffixIcon: suffixIcon,
        );
    }
  }
}

class TextAttributeField extends StatefulWidget {
  const TextAttributeField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
    this.multiline = false,
    this.suffixIcon,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool multiline;
  final Widget? suffixIcon;

  @override
  State<TextAttributeField> createState() => _TextAttributeFieldState();
}

class _TextAttributeFieldState extends State<TextAttributeField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      minLines: 1,
      maxLines: widget.multiline ? 5 : 1,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.suffixIcon,
      ),
      onChanged: widget.onChanged,
    );
  }
}

class BooleanAttributeField extends StatefulWidget {
  const BooleanAttributeField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<BooleanAttributeField> createState() => _BooleanAttributeFieldState();
}

class _BooleanAttributeFieldState extends State<BooleanAttributeField> {
  late bool _value = widget.initialValue == 'true';

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.label),
      value: _value,
      onChanged: widget.enabled
          ? (v) {
              setState(() => _value = v);
              widget.onChanged(v.toString());
            }
          : null,
    );
  }
}

class NumberAttributeField extends StatefulWidget {
  const NumberAttributeField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
    this.min,
    this.max,
    this.suffixIcon,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final double? min;
  final double? max;
  final Widget? suffixIcon;

  @override
  State<NumberAttributeField> createState() => _NumberAttributeFieldState();
}

class _NumberAttributeFieldState extends State<NumberAttributeField> {
  late double _sliderValue = double.tryParse(widget.initialValue ?? '') ?? (widget.min ?? 0);
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.min != null && widget.max != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
          Slider(
            value: _sliderValue.clamp(widget.min!, widget.max!),
            min: widget.min!,
            max: widget.max!,
            divisions: ((widget.max! - widget.min!) * 10).round().clamp(1, 1000),
            label: _sliderValue.toStringAsFixed(1),
            onChanged: widget.enabled
                ? (v) {
                    setState(() => _sliderValue = v);
                    widget.onChanged(v.toString());
                  }
                : null,
          ),
        ],
      );
    }

    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))],
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.suffixIcon,
      ),
      onChanged: widget.onChanged,
    );
  }
}

class EnumAttributeField extends StatelessWidget {
  const EnumAttributeField({
    super.key,
    required this.label,
    required this.options,
    required this.optionLabel,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
    this.suffixIcon,
  });

  final String label;
  final List<String> options;
  final String Function(String value) optionLabel;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final selected = (initialValue != null && options.contains(initialValue))
        ? initialValue
        : null;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        enabled: enabled,
        suffixIcon: suffixIcon,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selected,
          hint: const Text('—'),
          items: [
            for (final opt in options)
              DropdownMenuItem(value: opt, child: Text(optionLabel(opt))),
          ],
          onChanged: enabled
              ? (v) {
                  if (v != null) onChanged(v);
                }
              : null,
        ),
      ),
    );
  }
}

class DateAttributeField extends StatelessWidget {
  const DateAttributeField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
    this.suffixIcon,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final Widget? suffixIcon;

  DateTime? get _parsed {
    if (initialValue == null || initialValue!.isEmpty) return null;
    return DateTime.tryParse(initialValue!);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final date = _parsed;
    final display = date == null ? '—' : DateFormat.yMMMd(locale).format(date);

    // When a lock icon is provided alongside the calendar icon, wrap both
    // in a minimal Row so they sit side-by-side inside the suffix slot.
    final calendarIcon = const Icon(Icons.calendar_today_outlined, size: 18);
    final combinedSuffix = suffixIcon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [calendarIcon, suffixIcon!],
          )
        : calendarIcon;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: !enabled
          ? null
          : () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(1000),
                lastDate: DateTime(2200),
              );
              if (picked != null) {
                onChanged(picked.toIso8601String().split('T').first);
              }
            },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          suffixIcon: combinedSuffix,
        ),
        child: Text(display),
      ),
    );
  }
}

/// A field that holds several short free-form entries (e.g. Arc, Role)
/// instead of one block of text. Stored as a JSON array in the Fact
/// value. Starts locked — tap the padlock to reveal the ✕ on each chip
/// so a stray tap can't delete something by accident. Every removal can
/// be undone from the snackbar it triggers.
class TagListAttributeField extends StatefulWidget {
  const TagListAttributeField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<TagListAttributeField> createState() => _TagListAttributeFieldState();
}

class _TagListAttributeFieldState extends State<TagListAttributeField> {
  late final List<String> _tags = _parse(widget.initialValue);
  bool _locked = true;
  final _addController = TextEditingController();

  static List<String> _parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
    } catch (_) {
      // Legacy plain-text value from before this field used tags — keep
      // it as a single tag rather than losing it silently.
      return [raw];
    }
    return [];
  }

  void _commit() => widget.onChanged(jsonEncode(_tags));

  void _addTag() {
    final text = _addController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tags.add(text);
      _addController.clear();
    });
    _commit();
  }

  void _removeTag(int index) {
    final removed = _tags[index];
    setState(() => _tags.removeAt(index));
    _commit();

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.removedTag}: "$removed"'),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () {
            setState(() => _tags.insert(index, removed));
            _commit();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final canEdit = widget.enabled && !_locked;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        enabled: widget.enabled,
        suffixIcon: widget.enabled
            ? IconButton(
                tooltip: _locked ? l10n.unlockToEdit : l10n.lockEditing,
                icon: Icon(_locked ? Icons.lock_outline : Icons.lock_open, size: 18),
                onPressed: () => setState(() => _locked = !_locked),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_tags.isEmpty)
            Text('—', style: TextStyle(color: scheme.onSurfaceVariant))
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 0; i < _tags.length; i++)
                  Chip(
                    label: Text(_tags[i]),
                    onDeleted: canEdit ? () => _removeTag(i) : null,
                  ),
              ],
            ),
          if (canEdit) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addController,
                    decoration: InputDecoration(hintText: l10n.tagAddHint, isDense: true),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTag),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Typeahead picker over Entities of a given type. Not wired into the
/// character form yet (its entity_ref fields target Scene/Secret/
/// Place/Organization, none of which exist as entity types yet) but
/// ready for Part 3 (picking an existing character for a Relation).
class EntityRefAttributeField extends StatefulWidget {
  const EntityRefAttributeField({
    super.key,
    required this.label,
    required this.database,
    required this.targetEntityType,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final AppDatabase database;
  final String targetEntityType;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<EntityRefAttributeField> createState() => _EntityRefAttributeFieldState();
}

class _EntityRefAttributeFieldState extends State<EntityRefAttributeField> {
  String _resolvedLabel = '';

  @override
  void initState() {
    super.initState();
    final id = widget.initialValue;
    if (id != null && id.isNotEmpty) _resolve(id);
  }

  Future<void> _resolve(String id) async {
    final row = await widget.database.getEntity(id);
    if (mounted && row != null) setState(() => _resolvedLabel = row.displayName);
  }

  Future<void> _pick() async {
    final result = await showDialog<EntityRow>(
      context: context,
      builder: (_) => _EntityPickerDialog(
        database: widget.database,
        entityType: widget.targetEntityType,
      ),
    );
    if (result != null) {
      setState(() => _resolvedLabel = result.displayName);
      widget.onChanged(result.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.enabled ? _pick : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          enabled: widget.enabled,
          suffixIcon: const Icon(Icons.search, size: 18),
        ),
        child: Text(_resolvedLabel.isEmpty ? '—' : _resolvedLabel),
      ),
    );
  }
}

class _EntityPickerDialog extends StatefulWidget {
  const _EntityPickerDialog({required this.database, required this.entityType});

  final AppDatabase database;
  final String entityType;

  @override
  State<_EntityPickerDialog> createState() => _EntityPickerDialogState();
}

class _EntityPickerDialogState extends State<_EntityPickerDialog> {
  final _searchController = TextEditingController();
  List<EntityRow> _results = const [];

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final results = await widget.database.searchEntities(widget.entityType, query);
    if (mounted) setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 360,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
              onChanged: _search,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('—'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final e = _results[index];
                        return ListTile(
                          title: Text(e.displayName),
                          onTap: () => Navigator.of(context).pop(e),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
