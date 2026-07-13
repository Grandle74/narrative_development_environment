// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Narrative Development Environment';

  @override
  String get charactersTitle => 'Characters';

  @override
  String get addCharacter => 'Add Character';

  @override
  String get nameLabel => 'Name';

  @override
  String get save => 'Save';

  @override
  String get noCharactersYet => 'No characters yet. Tap + to add one.';

  @override
  String get unnamedCharacter => 'Unnamed';
}
