import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// One Nature power type. `icon` and `color` are placeholders — swap
/// them for the real stone/power artwork later without touching
/// anything else (the data model just stores `id`).
class NaturePower {
  const NaturePower(this.id, this.icon, this.color);

  final String id;
  final IconData icon;
  final Color color;
}

/// Canonical list of Nature power types. Order here is display order
/// everywhere (main power picker, stone picker).
const List<NaturePower> naturePowers = [
  NaturePower('fire', Icons.local_fire_department, Color(0xFFE8532B)),
  NaturePower('ice', Icons.ac_unit, Color(0xFF5FC9E8)),
  NaturePower('mist', Icons.blur_on, Color(0xFF9DB4C0)),
  NaturePower('earth', Icons.terrain, Color(0xFF8B5E34)),
  NaturePower('water', Icons.water_drop, Color(0xFF2E7DD1)),
  NaturePower('air', Icons.air, Color(0xFF8FD9C4)),
  NaturePower('electro', Icons.bolt, Color(0xFFE8C93A)),
  NaturePower('plant', Icons.eco, Color(0xFF4C9A4A)),
  NaturePower('dark', Icons.dark_mode, Color(0xFF4B3B6B)),
];

/// Looks up a power by its stored id. Returns null for an empty/unset
/// slot (`null` or `''`) or an id that isn't recognized.
NaturePower? naturePowerById(String? id) {
  if (id == null || id.isEmpty) return null;
  for (final power in naturePowers) {
    if (power.id == id) return power;
  }
  return null;
}

String naturePowerLabel(AppLocalizations l10n, String id) {
  switch (id) {
    case 'fire':
      return l10n.powerFire;
    case 'ice':
      return l10n.powerIce;
    case 'mist':
      return l10n.powerMist;
    case 'earth':
      return l10n.powerEarth;
    case 'water':
      return l10n.powerWater;
    case 'air':
      return l10n.powerAir;
    case 'electro':
      return l10n.powerElectro;
    case 'plant':
      return l10n.powerPlant;
    case 'dark':
      return l10n.powerDark;
    default:
      return id;
  }
}
