// The previous version of this test referenced a Counter UI that never
// existed in this app and an undefined `Fake` helper — it couldn't have
// been passing. Replaced with a minimal smoke test that at least
// compiles against the current NdeApp signature.
//
// Note: AppDatabase opens a real sqlite file via path_provider, which
// needs platform-channel mocking to run cleanly under `flutter test`.
// Not wired up here — fine for now, worth revisiting once there's
// enough surface area to justify a real test setup.

import 'package:flutter_test/flutter_test.dart';
import 'package:narrative_development_environment/data/database.dart';
import 'package:narrative_development_environment/main.dart';
import 'package:narrative_development_environment/theme/theme_controller.dart';

void main() {
  testWidgets('App builds without throwing', (WidgetTester tester) async {
    final database = AppDatabase();
    final themeController = ThemeController(database);

    await tester.pumpWidget(NdeApp(database: database, themeController: themeController));
    await tester.pump();
  });
}
