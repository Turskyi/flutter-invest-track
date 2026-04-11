import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/router/app_route.dart';

class SignInToDeleteButton extends StatelessWidget {
  const SignInToDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: const Icon(Icons.login),
      label: Text(translate('privacy_choices.sign_in_button')),
      onPressed: () => _navigateToSignIn(context),
    );
  }

  void _navigateToSignIn(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoute.signIn.path,
      (Route<Object?> _) => false,
    );
  }
}
