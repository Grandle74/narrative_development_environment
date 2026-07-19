import 'package:flutter/material.dart';

import '../../data/nature_powers.dart';
import '../../l10n/generated/app_localizations.dart';

const List<String> _stoneNatureIds = [
  'fire', 'ice', 'mist', 'earth', 'water', 'air', 'electro', 'plant', 'dark',
];

/// Main power button + 9 stone slots.
///
/// Always renders in portrait (main power centred above the 3 × 3 stone grid).
/// The card fills whatever width its parent gives it, and also fills whatever
/// height its parent gives it — so it works both as a free-floating mobile
/// card and as a height-matched column on wide-screen layouts.
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

  /// Exactly 9 entries, each a Nature id or null/'' for an empty stone.
  final List<String?> stonePowers;

  final ValueChanged<String?> onMainPowerChanged;
  final void Function(int index, String? value) onStonePowerChanged;

  // ─── Bottom-sheet picker ────────────────────────────────────────────────

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

  // ─── Shared slot renderer ───────────────────────────────────────────────

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
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected
                ? color.withValues(alpha: 0.16)
                : scheme.surfaceContainerHighest.withValues(alpha: 0.28),
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: 0.85)
                  : scheme.outlineVariant.withValues(alpha: 0.45),
              width: selected ? 1.5 : 1.0,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: selected
                ? color
                : scheme.onSurfaceVariant.withValues(alpha: 0.38),
            size: size * 0.46,
          ),
        ),
      ),
    );
  }

  // ─── Main-power column ──────────────────────────────────────────────────

  Widget _mainPowerColumn(BuildContext context, AppLocalizations l10n) {
    final mainLabel = naturePowerById(mainPower) != null
        ? naturePowerLabel(l10n, mainPower!)
        : l10n.powerNone;
    final power = naturePowerById(mainPower);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _slot(
          context,
          size: 80,
          value: mainPower,
          tooltip: mainLabel,
          onTap: () => _pick(context, mainPower, onMainPowerChanged),
          icon: power?.icon ?? Icons.block,
          color: power?.color ?? scheme.outline,
          selected: power != null,
        ),
        const SizedBox(height: 6),
        Text(
          mainLabel,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: power != null ? power.color : scheme.onSurfaceVariant,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          l10n.mainPowerLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  // ─── Stone grid (3 × 3) ─────────────────────────────────────────────────
  // NOTE: deliberately not using GridView — it cannot participate in
  // intrinsic-height measurement and would crash inside Row/Column trees.

  Widget _stonesGrid(BuildContext context, AppLocalizations l10n,
      {required double slotSize, required double spacing}) {
    const cols = 3;
    final rows = (_stoneNatureIds.length / cols).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var r = 0; r < rows; r++) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var c = 0; c < cols; c++) ...[
                if (c > 0) SizedBox(width: spacing),
                Builder(builder: (ctx) {
                  final i = r * cols + c;
                  if (i >= _stoneNatureIds.length) {
                    return SizedBox(width: slotSize, height: slotSize);
                  }
                  return _slot(
                    ctx,
                    size: slotSize,
                    value: stonePowers[i],
                    tooltip: naturePowerLabel(l10n, _stoneNatureIds[i]),
                    onTap: () {
                      final next = stonePowers[i] == _stoneNatureIds[i]
                          ? ''
                          : _stoneNatureIds[i];
                      onStonePowerChanged(i, next);
                    },
                    icon: naturePowerById(_stoneNatureIds[i])?.icon ??
                        Icons.block,
                    color: naturePowerById(_stoneNatureIds[i])?.color ??
                        Theme.of(ctx).colorScheme.outline,
                    selected: stonePowers[i] == _stoneNatureIds[i],
                  );
                }),
              ],
            ],
          ),
          if (r < rows - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }

  // ─── Card shell ──────────────────────────────────────────────────────────
  // The Container has no explicit height so it fills whatever bounded height
  // its parent provides (e.g. from IntrinsicHeight + CrossAxisAlignment.stretch
  // on the wide-screen page layout) while still shrink-wrapping on mobile.

  Widget _card(BuildContext context, Widget child) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surfaceContainerLow,
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Always portrait: main power centred above the stone grid.
    // No internal breakpoint — the page layout handles wide vs. narrow.
    return _card(
      context,
      Column(
        // MainAxisSize.max so the column fills any bounded height handed down
        // by the parent (wide-screen stretch), while still auto-sizing on mobile.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: _mainPowerColumn(context, l10n)),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.4),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.stonePowersLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.6),
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: 8),
          Center(
            child: _stonesGrid(context, l10n, slotSize: 44, spacing: 8),
          ),
        ],
      ),
    );
  }
}
