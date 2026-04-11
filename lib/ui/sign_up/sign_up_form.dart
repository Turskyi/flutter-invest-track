import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:formz/formz.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/sign_up/sign_up_continue_button.dart';
import 'package:investtrack/ui/sign_up/sign_up_email_input.dart';
import 'package:investtrack/ui/sign_up/sign_up_password_input.dart';
import 'package:investtrack/ui/widgets/app_version_text.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({required this.email, required this.password, super.key});

  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return BlocListener<SignUpBloc, SignUpState>(
      listener: _signUpStateListener,
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: constants.maxWidth),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  translate('sign_up_form.title'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  translate('sign_up_form.subtitle'),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                SignUpEmailInput(initialValue: email),
                const Padding(padding: EdgeInsets.all(12)),
                SignUpPasswordInput(initialValue: password),
                const Padding(padding: EdgeInsets.all(12)),
                const SignUpContinueButton(),
                const Padding(padding: EdgeInsets.all(24)),
                Text(translate('sign_up_form.sign_in_prompt_text_1')),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoute.signIn.path,
                  ),
                  child: Text(translate('sign_up_form.sign_in_prompt_text_2')),
                ),
                const SizedBox(height: 24),
                const AppVersionText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUpStateListener(BuildContext context, SignUpState state) {
    if (state.status.isFailure || state is SignUpErrorState) {
      Widget contentWidget;
      const String officialWebsiteUrl = constants.website;
      if (kIsWeb) {
        contentWidget = SelectableText.rich(
          TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: translate('sign_up_form.error_sign_up_unavailable_web_1'),
                style: const TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: officialWebsiteUrl,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final Uri url = Uri.parse(officialWebsiteUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, webOnlyWindowName: '_blank');
                    } else {
                      debugPrint('Could not launch $officialWebsiteUrl');
                    }
                  },
              ),
            ],
          ),
        );
      } else {
        String errorMessage;
        if (state is SignUpErrorState) {
          errorMessage = state.errorMessage;
        } else {
          errorMessage = translate('sign_up_form.error_sign_up_failure');
        }
        contentWidget = SelectableText(errorMessage);
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: contentWidget,
            duration: const Duration(seconds: 10),
          ),
        );
    }
  }
}
