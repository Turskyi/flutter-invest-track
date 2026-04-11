import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:investtrack/ui/sign_up/code_input.dart';

import 'mocks/mock_repositories.dart';

void main() {
  group('CodeInput', () {
    Widget buildSubject() {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<SignUpBloc>(
            create: (_) => SignUpBloc(
              authenticationRepository: MockAuthenticationRepository(),
            ),
            child: const CodeInput(),
          ),
        ),
      );
    }

    testWidgets('tapping the code area focuses the hidden input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSubject());

      await tester.tap(find.byKey(const Key('codeInput_box_0')));
      await tester.pump();

      final TextField textField = tester.widget<TextField>(
        find.byKey(const Key('codeInput_textField')),
      );

      expect(textField.focusNode?.hasFocus, isTrue);
    });

    testWidgets('renders digits in visual boxes and limits to 6', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSubject());

      final Finder field = find.byKey(const Key('codeInput_textField'));

      await tester.showKeyboard(field);
      await tester.enterText(field, '1234567');
      await tester.pump();

      final TextField textField = tester.widget<TextField>(field);

      expect(textField.controller?.text, '123456');
      expect(find.text('1'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('7'), findsNothing);
    });
  });
}
