// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بيئة تطوير السرد';

  @override
  String get charactersTitle => 'الشخصيات';

  @override
  String get addCharacter => 'إضافة شخصية';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get save => 'حفظ';

  @override
  String get noCharactersYet => 'لا توجد شخصيات بعد. اضغط + للإضافة.';

  @override
  String get unnamedCharacter => 'بدون اسم';
}
