import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:investtrack/application_services/blocs/sign_in/bloc/sign_in_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/res/constants/hero_tags.dart' as hero_tags;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/sign_in/continue_button.dart';
import 'package:investtrack/ui/sign_in/email_input.dart';
import 'package:investtrack/ui/sign_in/password_input.dart';
import 'package:investtrack/ui/sign_in/sign_up_prompt.dart';
import 'package:investtrack/ui/widgets/input_field.dart';
import 'package:url_launcher/url_launcher.dart';

/// The [SignInForm] handles notifying the [SignInBloc] of user events and
/// also responds to state changes using [BlocBuilder] and [BlocListener].
/// [BlocListener] is used to show a [SnackBar] if the login submission fails.
/// In addition, [BlocBuilder] widgets are used to wrap each of the [TextField]
/// widgets and make use of the `buildWhen` property in order to optimize for
/// rebuilds. The `onChanged` callback is used to notify the [SignInBloc] of
/// changes to the email/password.
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm>
    with SingleTickerProviderStateMixin {
  bool _isConsentGiven = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: _signInStateListener,
      builder: (BuildContext context, SignInState state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 120, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(
                tag: hero_tags.appLogo,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 96,
                  height: 96,
                ),
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: Tween<double>(begin: 0.4, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Text(
                  constants.appName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to InvestTrack - your companion in smart investments.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const InputField(
                label: 'Email',
                icon: Icons.email,
                child: EmailInput(),
              ),
              const SizedBox(height: 20),
              const InputField(
                label: 'Password',
                icon: Icons.lock,
                child: PasswordInput(),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _isConsentGiven,
                    onChanged: (bool? value) {
                      setState(() => _isConsentGiven = value ?? false);
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I consent to the collection of my data.\n',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Learn more.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _launchPrivacyPolicy,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ContinueButton(
                onPressed: _isConsentGiven
                    ? () => context.read<SignInBloc>().add(
                          const SignInSubmitted(),
                        )
                    : null,
              ),
              const SizedBox(height: 20),
              SignUpPrompt(
                email: state.email.value,
                password: state.password.value,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchPrivacyPolicy() {
    Navigator.pushNamed(context, AppRoute.privacyPolity.path);
  }

  void _signInStateListener(BuildContext context, SignInState state) {
    if (state.status.isFailure || state is SignInErrorState) {
      Widget contentWidget;
      const String officialWebsiteUrl = constants.website;
      if (kIsWeb) {
        contentWidget = SelectableText.rich(
          TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              const TextSpan(
                text: 'Sign in is not available here. Please use our official '
                    'website: ',
                style: TextStyle(color: Colors.black),
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
        if (state is SignInErrorState) {
          errorMessage = state.errorMessage;
        } else {
          errorMessage = 'Authentication Failure';
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
