import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/ui/sign_in/language_selector_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketingUrlPage extends StatelessWidget {
  const MarketingUrlPage({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: Text(translate('marketing.title')),
        actions: const <Widget>[SafeArea(child: LanguageSelectorButton())],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              translate('marketing.hero_title'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              translate('marketing.hero_subtitle'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              translate('marketing.section_why_title'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(translate('marketing.feature_1')),
            const SizedBox(height: 8),
            Text(translate('marketing.feature_2')),
            const SizedBox(height: 8),
            Text(translate('marketing.feature_3')),
            const SizedBox(height: 24),
            Text(
              translate('marketing.section_story_title'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(translate('marketing.story_paragraph_1')),
            const SizedBox(height: 10),
            Text(translate('marketing.story_paragraph_2')),
            const SizedBox(height: 24),
            Text(
              translate('marketing.section_actions_title'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _launchUrl(
                      context: context,
                      uri: Uri.parse('${constants.website}/sign-up'),
                    );
                  },
                  child: Text(translate('marketing.sign_up_button')),
                ),
                OutlinedButton(
                  onPressed: () {
                    _launchUrl(
                      context: context,
                      uri: Uri.parse('${constants.website}/sign-in'),
                    );
                  },
                  child: Text(translate('marketing.sign_in_button')),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              translate('marketing.section_contact_title'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(translate('marketing.contact_intro')),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.alternate_email),
              title: Text(translate('marketing.contact_instagram_title')),
              subtitle: Text(translate('marketing.contact_instagram_subtitle')),
              onTap: () {
                _launchUrl(
                  context: context,
                  uri: Uri.parse('https://instagram.com/vitalikhomenkoo'),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.send_outlined),
              title: Text(translate('marketing.contact_telegram_title')),
              subtitle: Text(translate('marketing.contact_telegram_subtitle')),
              onTap: () {
                _launchUrl(
                  context: context,
                  uri: Uri.parse(constants.telegramSupportUrl),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.support_agent_outlined),
              title: Text(translate('marketing.contact_support_title')),
              subtitle: Text(translate('marketing.contact_support_subtitle')),
              onTap: () {
                _launchUrl(
                  context: context,
                  uri: Uri.parse(
                    'https://${constants.companyDomain}/#/support',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl({
    required BuildContext context,
    required Uri uri,
  }) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        _showErrorSnackbar(context: context, uri: uri);
      }
    } catch (_) {
      if (context.mounted) {
        _showErrorSnackbar(context: context, uri: uri);
      }
    }
  }

  void _showErrorSnackbar({required BuildContext context, required Uri uri}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translate('marketing.error_could_not_launch')),
        action: SnackBarAction(
          label: translate('marketing.error_copy_action'),
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: uri.toString())),
        ),
        duration: const Duration(seconds: 6),
      ),
    );
  }
}
