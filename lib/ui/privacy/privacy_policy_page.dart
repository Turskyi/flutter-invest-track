import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final Color linkColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: Text(translate('privacy_policy.title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              translate('privacy_policy.page_heading'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${translate('privacy_policy.last_updated_prefix')}'
              '${translate('privacy_policy.last_updated_value')}',
            ),
            const SizedBox(height: 20),
            Text(
              translate('privacy_policy.section_introduction'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.intro_body')),
            const SizedBox(height: 20),
            Text(
              translate('privacy_policy.section_collect'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.collect_intro')),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: translate('privacy_policy.collect_email_prefix'),
                children: <InlineSpan>[
                  TextSpan(
                    text: constants.authServiceName,
                    style: TextStyle(color: linkColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(
                        context: context,
                        url: constants.authServiceLink,
                      ),
                  ),
                  TextSpan(
                    text: translate('privacy_policy.collect_email_suffix'),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: translate('privacy_policy.collect_user_id_prefix'),
                children: <InlineSpan>[
                  TextSpan(
                    text: constants.authServiceName,
                    style: TextStyle(color: linkColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(
                        context: context,
                        url: constants.authServiceLink,
                      ),
                  ),
                  TextSpan(
                    text: translate('privacy_policy.collect_user_id_suffix'),
                  ),
                ],
              ),
            ),
            Text(translate('privacy_policy.collect_investments')),
            const SizedBox(height: 20),
            Text(
              translate('privacy_policy.section_storage'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: translate('privacy_policy.storage_prefix'),
                children: <InlineSpan>[
                  TextSpan(
                    text: constants.remoteDbServiceName,
                    style: TextStyle(color: linkColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(
                        context: context,
                        url: constants.remoteDbServiceLink,
                      ),
                  ),
                  TextSpan(text: translate('privacy_policy.storage_suffix')),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: translate('privacy_policy.storage_deletion_prefix'),
                children: <InlineSpan>[
                  TextSpan(
                    text: translate('privacy_policy.storage_deletion_link'),
                    style: TextStyle(color: linkColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(
                        context: context,
                        url: constants.deletionInstructionsLink,
                      ),
                  ),
                  TextSpan(
                    text: translate('privacy_policy.storage_deletion_suffix'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              translate('privacy_policy.section_sharing'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.sharing_intro')),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.sharing_law')),
            Text(translate('privacy_policy.sharing_protection')),
            const SizedBox(height: 20),
            Text(
              translate('privacy_policy.section_rights'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.rights_intro')),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.rights_access')),
            Text(translate('privacy_policy.rights_deletion')),
            Text(translate('privacy_policy.rights_modification')),
            const SizedBox(height: 20),
            Text(
              translate('privacy_policy.section_changes'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.changes_body')),
            const SizedBox(height: 20),
            Text(
              translate('privacy_policy.section_contact'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.contact_intro')),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: translate('privacy_policy.contact_email_label'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'privacy@${constants.domain}',
                    style: TextStyle(
                      color: linkColor,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'privacy@${constants.companyDomain}',
                        );
                        launchUrl(emailLaunchUri);
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(translate('privacy_policy.thank_you')),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL({
    required BuildContext context,
    required String url,
  }) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        _showErrorSnackbar(context: context, url: uri);
      }
    } catch (_) {
      if (context.mounted) {
        _showErrorSnackbar(context: context, url: uri);
      }
    }
  }

  void _showErrorSnackbar({required BuildContext context, required Uri url}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            text:
                '${translate('privacy_policy.error_could_not_launch')}'
                '${url.path}. ',
            style: const TextStyle(color: Colors.white),
            children: <InlineSpan>[
              TextSpan(text: translate('privacy_policy.error_copy_link')),
              TextSpan(
                text: url.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
          label: translate('privacy_policy.error_copy_action'),
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: url.toString())),
        ),
        duration: const Duration(seconds: 10),
      ),
    );
  }
}
