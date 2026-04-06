import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/ui/sign_in/language_selector_button.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flutter_translate_test_utils.dart';

void main() {
  late LocalizationDelegate localizationDelegate;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    localizationDelegate = await setUpFlutterTranslateForTests();
  });

  Widget buildSubject() => prepareWidgetForTesting(
    LocalizedApp(localizationDelegate, const LanguageSelectorButton()),
    localizationDelegate,
  );

  testWidgets('shows English flag and name by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text(Language.en.flag), findsOneWidget);
    expect(find.text(Language.en.name), findsOneWidget);
  });

  testWidgets('shows a dropdown arrow icon', (WidgetTester tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
  });

  testWidgets('popup menu lists all supported languages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<Language>));
    await tester.pumpAndSettle();

    for (final Language language in Language.values) {
      expect(find.text(language.name), findsWidgets);
    }
  });

  testWidgets('switches locale when a language is selected', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<Language>));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Language.uk.name).last);
    await tester.pumpAndSettle();

    expect(
      localizationDelegate.currentLocale.languageCode,
      Language.uk.isoLanguageCode,
    );
  });
}
