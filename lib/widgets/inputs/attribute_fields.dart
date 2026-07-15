import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';

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
        );
      case 'enum':
        return EnumAttributeField(
          label: label,
          options: options,
          optionLabel: optionLabel ?? (v) => v,
          initialValue: initialValue,
          enabled: enabled,
          onChanged: onChanged,
        );
      case 'date':
        return DateAttributeField(
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
        // Target entity type doesn't exist yet (Scene/Secret/Place/Org
        // are later Parts) — fall back to text rather than fake a
        // picker with nothing to pick from.
        return TextAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          multiline: multiline,
          onChanged: onChanged,
        );
      case 'text':
      default:
        return TextAttributeField(
          label: label,
          initialValue: initialValue,
          enabled: enabled,
          multiline: multiline,
          onChanged: onChanged,
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
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool multiline;

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
      decoration: InputDecoration(labelText: widget.label),
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
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final double? min;
  final double? max;

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
      decoration: InputDecoration(labelText: widget.label),
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
  });

  final String label;
  final List<String> options;
  final String Function(String value) optionLabel;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final selected = (initialValue != null && options.contains(initialValue))
        ? initialValue
        : null;

    return InputDecorator(
      decoration: InputDecoration(labelText: label, enabled: enabled),
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
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  DateTime? get _parsed {
    if (initialValue == null || initialValue!.isEmpty) return null;
    return DateTime.tryParse(initialValue!);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final date = _parsed;
    final display = date == null ? '—' : DateFormat.yMMMd(locale).format(date);

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
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(display),
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
