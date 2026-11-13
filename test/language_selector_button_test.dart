import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/repositories/settings_repository_impl.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/localization/localization_delelegate_getter.dart'
    as localization;
import 'package:investtrack/ui/sign_in/language_selector_button.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flutter_translate_test_utils.dart';

void main() {
  late LocalizationDelegate localizationDelegate;
  late SettingsRepository settingsRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    localizationDelegate = await setUpFlutterTranslateForTests();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    settingsRepository = SettingsRepositoryImpl(preferences);
  });

  Widget buildSubject() => RepositoryProvider<SettingsRepository>.value(
    value: settingsRepository,
    child: prepareWidgetForTesting(
      LocalizedApp(localizationDelegate, const LanguageSelectorButton()),
      localizationDelegate,
    ),
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

  testWidgets('restores the selected locale after app restart', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<Language>));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Language.uk.name).last);
    await tester.pumpAndSettle();

    final SharedPreferences relaunchedPreferences =
        await SharedPreferences.getInstance();
    final SettingsRepository relaunchedSettingsRepository =
        SettingsRepositoryImpl(relaunchedPreferences);

    expect(relaunchedSettingsRepository.getLanguage(), Language.uk);

    final LocalizationDelegate startupDelegate = await localization
        .getLocalizationDelegate(
          preferredLanguage: relaunchedSettingsRepository.getLanguage(),
        );

    expect(
      startupDelegate.currentLocale.languageCode,
      Language.uk.isoLanguageCode,
    );
  });
}
