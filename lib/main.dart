import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/database.dart';
import 'features/characters/character_list_screen.dart';
import 'l10n/generated/app_localizations.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Required before formatting/parsing dates in non-English locales
  // (the calendar date pickers are bilingual, en + ar).
  await initializeDateFormatting();

  final database = AppDatabase();
  final themeController = ThemeController(database);
  runApp(NdeApp(database: database, themeController: themeController));
}

class NdeApp extends StatelessWidget {
  const NdeApp({super.key, required this.database, required this.themeController});

  final AppDatabase database;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.mode,
          home: CharacterListScreen(database: database, themeController: themeController),
        );
      },
    );
  }
}
