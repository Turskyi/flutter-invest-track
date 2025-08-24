import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
        final double logoSize = 96.0;
        final TextTheme textTheme = Theme.of(context).textTheme;
        return Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: constants.maxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 120, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Hero(
                    tag: hero_tags.appLogo,
                    child: Image.asset(
                      '${constants.imagePath}logo.png',
                      width: logoSize,
                      height: logoSize,
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
                        fontSize: textTheme.headlineLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    translate('sign_in_form.welcome_message'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textTheme.titleMedium?.fontSize,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: translate('sign_in_form.email_label'),
                    icon: Icons.email,
                    child: const EmailInput(),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: translate('sign_in_form.password_label'),
                    icon: Icons.lock,
                    child: const PasswordInput(),
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
                            text:
                                '${translate('sign_in_form.'
                                'consent_prompt_data_collection')}\n',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: <InlineSpan>[
                              TextSpan(
                                text: translate(
                                  'sign_in_form.consent_learn_more',
                                ),
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
            ),
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
              TextSpan(
                text: translate('sign_in_form.error_sign_in_unavailable_web_1'),
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
        if (state is SignInErrorState) {
          errorMessage = state.errorMessage;
        } else {
          errorMessage = translate('sign_in_form.error_authentication_failure');
        }
        contentWidget = SelectableText.rich(
          TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: _buildErrorTextSpans(errorMessage, context),
          ),
        );
      }

      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(translate('sign_in_form.error_dialog_title')),
            content: contentWidget,
            actions: <Widget>[
              TextButton(
                onPressed: Navigator.of(dialogContext).pop,
                child: Text(translate('sign_in_form.error_dialog_ok_button')),
              ),
            ],
          );
        },
      );
    }
  }

  List<InlineSpan> _buildErrorTextSpans(
    String errorMessage,
    BuildContext context,
  ) {
    final List<InlineSpan> spans = <InlineSpan>[];
    final RegExp urlRegExp = RegExp(
      r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+(?<![.,!?;:])',
      // (?<![.,!?;:]) is a negative lookbehind.
      // It asserts that the character immediately preceding the current
      // position (i.e., the last character matched by the main URL part)
      // is NOT one of the characters inside the square brackets: '.', ',',
      // '!', '?', ';', ':'.
    );

    final Iterable<RegExpMatch> matches = urlRegExp.allMatches(errorMessage);

    int currentPosition = 0;
    for (final RegExpMatch match in matches) {
      if (match.start > currentPosition) {
        spans.add(
          TextSpan(text: errorMessage.substring(currentPosition, match.start)),
        );
      }
      final String url = match.group(0) ?? '';

      spans.add(
        TextSpan(
          text: url,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
            },
        ),
      );
      currentPosition = match.end;
    }

    if (currentPosition < errorMessage.length) {
      spans.add(TextSpan(text: errorMessage.substring(currentPosition)));
    }
    return spans;
  }
}
