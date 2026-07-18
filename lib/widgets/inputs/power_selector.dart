import 'package:flutter/material.dart';

import '../../data/nature_powers.dart';
import '../../l10n/generated/app_localizations.dart';

const List<String> _stoneNatureIds = ['fire', 'ice', 'mist', 'earth', 'water', 'air', 'electro', 'plant', 'dark'];

/// One big "main power" button plus 8 small stone slots. Each slot is
/// fixed to a single nature and toggles between that nature and none.
class PowersGrid extends StatelessWidget {
  const PowersGrid({
    super.key,
    required this.mainPower,
    required this.stonePowers,
    required this.onMainPowerChanged,
    required this.onStonePowerChanged,
  });

  /// Nature id, or null/'' for unset.
  final String? mainPower;

  /// Exactly 8 entries, each a Nature id or null/'' for an empty stone.
  final List<String?> stonePowers;

  final ValueChanged<String?> onMainPowerChanged;
  final void Function(int index, String? value) onStonePowerChanged;

  Future<void> _pick(
    BuildContext context,
    String? current,
    ValueChanged<String?> onSelected,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.block, size: 20),
              title: Text(l10n.powerNone),
              selected: current == null || current.isEmpty,
              onTap: () => Navigator.of(sheetContext).pop(''),
            ),
            const Divider(height: 1),
            for (final power in naturePowers)
              ListTile(
                leading: Icon(power.icon, color: power.color),
                title: Text(naturePowerLabel(l10n, power.id)),
                selected: power.id == current,
                onTap: () => Navigator.of(sheetContext).pop(power.id),
              ),
          ],
        ),
      ),
    );
    if (choice != null) onSelected(choice);
  }

  Widget _slot(
    BuildContext context, {
    required double size,
    required String? value,
    required VoidCallback onTap,
    required String tooltip,
    required IconData icon,
    required Color color,
    required bool selected,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: selected
                ? color.withValues(alpha: 0.18)
                : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
            border: Border.all(
              color: selected ? color : scheme.outlineVariant,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.45),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: selected ? color : scheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: size * 0.48,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainLabel =
        naturePowerById(mainPower) != null ? naturePowerLabel(l10n, mainPower!) : l10n.powerNone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              _slot(
                context,
                size: 92,
                value: mainPower,
                tooltip: mainLabel,
                onTap: () => _pick(context, mainPower, onMainPowerChanged),
                icon: naturePowerById(mainPower)?.icon ?? Icons.block,
                color: naturePowerById(mainPower)?.color ?? Theme.of(context).colorScheme.outline,
                selected: naturePowerById(mainPower) != null,
              ),
              const SizedBox(height: 6),
              Text(mainLabel, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                l10n.mainPowerLabel,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(l10n.stonePowersLabel, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < _stoneNatureIds.length; i++)
              _slot(
                context,
                size: 48,
                value: stonePowers[i],
                // Always show the nature name — toggled or not — so the
                // user knows what each slot does before activating it.
                tooltip: naturePowerLabel(l10n, _stoneNatureIds[i]),
                onTap: () {
                  final nextValue = stonePowers[i] == _stoneNatureIds[i] ? '' : _stoneNatureIds[i];
                  onStonePowerChanged(i, nextValue);
                },
                icon: naturePowerById(_stoneNatureIds[i])?.icon ?? Icons.block,
                color: naturePowerById(_stoneNatureIds[i])?.color ?? Theme.of(context).colorScheme.outline,
                selected: stonePowers[i] == _stoneNatureIds[i],
              ),
          ],
        ),
      ],
    );
  }
}
