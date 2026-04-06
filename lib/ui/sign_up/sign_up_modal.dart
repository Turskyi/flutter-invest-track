import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/ui/privacy/privacy_policy_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpModal extends StatefulWidget {
  const SignUpModal({super.key});

  @override
  State<SignUpModal> createState() => _SignUpModalState();
}

class _SignUpModalState extends State<SignUpModal> {
  bool _isConsentGiven = false;

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return AlertDialog(
      title: Text(translate('sign_up_modal.title')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(translate('sign_up_modal.description')),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isConsentGiven,
                  onChanged: (bool? value) {
                    setState(() => _isConsentGiven = value ?? false);
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: translate('sign_up_modal.consent_text'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: translate('sign_in_form.consent_learn_more'),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary, // Using theme color for link
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Privacy Policy
                              _launchPrivacyPolicy(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(translate('sign_up_modal.cancel_button')),
        ),
        TextButton(
          onPressed: _isConsentGiven
              ? () {
                  Navigator.of(context).pop();
                  _redirectToWebSignUp(context);
                }
              : null,
          child: Text(translate('sign_up_modal.proceed_button')),
        ),
      ],
    );
  }

  Future<void> _redirectToWebSignUp(BuildContext context) async {
    final Uri url = Uri.parse('${constants.baseUrl}sign-up');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        _showErrorSnackbar(context, url);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackbar(context, url);
      }
    }
  }

  void _launchPrivacyPolicy(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyPage()));
  }

  void _showErrorSnackbar(BuildContext context, Uri url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            text: translate('sign_up_modal.unable_to_open'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ), // Using theme color
            children: <InlineSpan>[
              TextSpan(
                text:
                    'You can copy this link and paste it into your browser:\n',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ), // Using theme color
              ),
              TextSpan(
                text: url.toString(),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary, // Using theme color for link
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      Clipboard.setData(ClipboardData(text: url.toString())),
              ),
            ],
          ),
        ),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: url.toString())),
        ),
        duration: const Duration(seconds: 10),
      ),
    );
  }
}
