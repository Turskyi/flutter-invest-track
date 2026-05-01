import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/sign_up/sign_up_continue_button.dart';
import 'package:investtrack/ui/sign_up/sign_up_email_input.dart';
import 'package:investtrack/ui/sign_up/sign_up_password_input.dart';
import 'package:investtrack/ui/widgets/app_version_text.dart';
import 'package:investtrack/ui/widgets/input_field.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({required this.email, required this.password, super.key});

  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
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
                  style: TextStyle(
                    fontSize: textTheme.headlineSmall?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  translate('sign_up_form.subtitle'),
                  style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize),
                ),
                const SizedBox(height: 24),
                InputField(
                  label: translate('sign_in_form.email_label'),
                  icon: Icons.email,
                  child: SignUpEmailInput(initialValue: email),
                ),
                const SizedBox(height: 20),
                InputField(
                  label: translate('sign_in_form.password_label'),
                  icon: Icons.lock,
                  child: SignUpPasswordInput(initialValue: password),
                ),
                const SizedBox(height: 20),
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
    if (state is SignUpErrorState) {
      Widget contentWidget;
      const String officialWebsiteUrl = constants.website;
      if (kIsWeb) {
        contentWidget = SelectableText.rich(
          TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: translate('sign_up_form.error_sign_up_unavailable_web_1'),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              TextSpan(
                text: officialWebsiteUrl,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await _launchUrl(officialWebsiteUrl);
                  },
              ),
            ],
          ),
        );
      } else {
        String errorMessage;
        errorMessage = state.errorMessage.replaceAll(
          ' (ERROR RECEIVED FROM SERVER)',
          '',
        );
        contentWidget = SelectableText(errorMessage);
      }

      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: contentWidget,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank');
    } else {
      debugPrint('Could not launch $urlString');
    }
  }
}
