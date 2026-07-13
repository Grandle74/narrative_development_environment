import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/database.dart';
import 'features/characters/character_list_screen.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  final database = AppDatabase();
  runApp(NdeApp(database: database));
}

class NdeApp extends StatelessWidget {
  const NdeApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
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
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: CharacterListScreen(database: database),
    );
  }
}
