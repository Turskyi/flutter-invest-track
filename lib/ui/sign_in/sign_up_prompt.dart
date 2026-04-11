import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/ui/sign_up/sign_up_page.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({required this.email, required this.password, super.key});

  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return Column(
      children: <Widget>[
        Text(translate('sign_in_form.sign_up_prompt_text_1')),
        const SizedBox(height: 8),
        ElevatedButton(
          key: const Key('signInForm_sigh_up_raisedButton'),
          onPressed: () => Navigator.of(
            context,
          ).push<void>(SignUpPage.route(email: email, password: password)),
          child: Text(translate('sign_in_form.sign_up_prompt_text_2')),
        ),
      ],
    );
  }
}
