import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:investtrack/application_services/blocs/theme/theme_bloc.dart';
import 'package:investtrack/ui/sign_up/code_form.dart';
import 'package:investtrack/ui/widgets/public_theme_wrapper.dart';
import 'package:nested/nested.dart';

import 'flutter_translate_test_utils.dart';
import 'mocks/mock_repositories.dart';

void main() {
  group('CodeForm', () {
    late LocalizationDelegate localizationDelegate;

    setUp(() async {
      localizationDelegate = await setUpFlutterTranslateForTests();
    });

    Widget buildSubject({String email = 'test@example.com'}) {
      return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<SignUpBloc>(
            create: (_) => SignUpBloc(
              authenticationRepository: MockAuthenticationRepository(),
            ),
          ),
          BlocProvider<ThemeBloc>(
            create: (_) => ThemeBloc(MockSettingsRepository()),
          ),
        ],
        child: LocalizedApp(
          localizationDelegate,
          MaterialApp(
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              localizationDelegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              body: PublicThemeWrapper(child: CodeForm(email: email)),
            ),
          ),
        ),
      );
    }

    testWidgets('renders email correctly', (WidgetTester tester) async {
      const String email = 'user@example.com';
      await tester.pumpWidget(buildSubject(email: email));
      await tester.pumpAndSettle();

      expect(find.text(email), findsOneWidget);
    });

    testWidgets('entering code updates state', (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final Finder field = find.byKey(const Key('codeForm_code_textField'));
      await tester.enterText(field, '123456');
      await tester.pumpAndSettle();

      final EditableText editableText = tester.widget<EditableText>(
        find.descendant(of: field, matching: find.byType(EditableText)),
      );
      expect(editableText.controller.text, '123456');
    });
  });
}
