import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/ui/sign_in/language_selector_button.dart';
import 'package:investtrack/ui/support/support_channel.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: Text(translate('support.title')),
        actions: const <Widget>[SafeArea(child: LanguageSelectorButton())],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              translate('support.subtitle'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SupportChannel(
              icon: Icons.email_outlined,
              label: translate('support.email_label'),
              action: constants.supportEmail,
              onTap: () => _launchUrl(
                context: context,
                uri: Uri(scheme: 'mailto', path: constants.supportEmail),
              ),
            ),
            SupportChannel(
              icon: Icons.send_outlined,
              label: translate('support.telegram_label'),
              action: translate('support.telegram_action'),
              onTap: () => _launchUrl(
                context: context,
                uri: Uri.parse(constants.telegramSupportUrl),
              ),
            ),
            SupportChannel(
              icon: Icons.bug_report_outlined,
              label: translate('support.github_label'),
              action: translate('support.github_action'),
              onTap: () => _launchUrl(
                context: context,
                uri: Uri.parse(constants.githubIssuesUrl),
              ),
            ),
            SupportChannel(
              icon: Icons.language_outlined,
              label: translate('support.website_label'),
              action: translate('support.website_action'),
              onTap: () => _launchUrl(
                context: context,
                uri: Uri.parse(constants.website),
              ),
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
        await launchUrl(uri, mode: LaunchMode.externalApplication);
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
        content: Text(translate('support.error_could_not_launch')),
        action: SnackBarAction(
          label: translate('support.error_copy_action'),
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: uri.toString())),
        ),
        duration: const Duration(seconds: 6),
      ),
    );
  }
}
