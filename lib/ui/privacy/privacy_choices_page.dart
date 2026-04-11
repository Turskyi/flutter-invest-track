import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/privacy/privacy_home_button.dart';
import 'package:investtrack/ui/privacy/sign_in_to_delete_button.dart';
import 'package:investtrack/ui/sign_in/language_selector_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyChoicesPage extends StatelessWidget {
  const PrivacyChoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final Color linkColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        leading: kIsWeb ? const PrivacyHomeButton() : null,
        title: Text(translate('privacy_choices.title')),
        actions: const <Widget>[SafeArea(child: LanguageSelectorButton())],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: constants.maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  translate('privacy_choices.heading'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(translate('privacy_choices.intro')),
                const SizedBox(height: 24),
                _PrivacySection(
                  title: translate('privacy_choices.section_what_we_collect'),
                  child: Text(
                    translate('privacy_choices.what_we_collect_body'),
                  ),
                ),
                const SizedBox(height: 24),
                _PrivacySection(
                  title: translate('privacy_choices.section_data_sharing'),
                  child: Text(translate('privacy_choices.data_sharing_body')),
                ),
                const SizedBox(height: 24),
                _PrivacySection(
                  title: translate('privacy_choices.section_delete_account'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(translate('privacy_choices.delete_account_intro')),
                      const SizedBox(height: 8),
                      Text(translate('privacy_choices.delete_step_1')),
                      Text(translate('privacy_choices.delete_step_2')),
                      Text(translate('privacy_choices.delete_step_3')),
                      const SizedBox(height: 8),
                      Text(
                        translate('privacy_choices.delete_warning'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Center(child: SignInToDeleteButton()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _PrivacySection(
                  title: translate('privacy_choices.section_contact'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(translate('privacy_choices.contact_intro')),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text: translate(
                            'privacy_choices.contact_email_label',
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'privacy@${constants.companyDomain}',
                              style: TextStyle(
                                color: linkColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: 'privacy@${constants.companyDomain}',
                                  );
                                  launchUrl(emailUri);
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text: translate(
                            'privacy_choices.privacy_policy_prefix',
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: translate(
                                'privacy_choices.privacy_policy_link',
                              ),
                              style: TextStyle(
                                color: linkColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(
                                  context,
                                ).pushNamed(AppRoute.privacyPolity.path),
                            ),
                            TextSpan(
                              text: translate(
                                'privacy_choices.privacy_policy_suffix',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
