import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color linkColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Privacy Policy For "${constants.appName}" App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Last Updated: $_updateDate'),
            const SizedBox(height: 20),
            const Text(
              'Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome to the ${constants.appName} mobile application. '
              'This Privacy Policy outlines our practices regarding the '
              'collection, use, and disclosure of information that we '
              'receive through our app. '
              'Our primary goal is to provide you with a convenient tool while '
              'respecting your privacy.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Information We Collect.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We collect the following personal data when you use the app:',
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: '- Email: Collected through ',
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
                  const TextSpan(
                    text: ' for authentication purposes.',
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: '- User ID: A unique identifier generated by ',
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
                  const TextSpan(
                    text: ' to associate your account with your data.',
                  ),
                ],
              ),
            ),
            const Text(
              '- Investments: Content of your personal investment records are '
              'stored in our backend database.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Data Storage and Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Your investment records and related data are securely '
                    'stored in ',
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
                  const TextSpan(
                    text: ', a widely used, industry-standard serverless SQL '
                        'database. '
                        '${constants.remoteDbServiceName} is known for its '
                        'robust security features, '
                        'and we use it to ensure your data is stored safely.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Additionally, you can delete your data anytime through '
                    'the app or by visiting our ',
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Account Deletion Instructions',
                    style: TextStyle(color: linkColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchURL(
                            context: context,
                            url: constants.deletionInstructionsLink,
                          ),
                  ),
                  const TextSpan(
                    text: ' page for '
                        'detailed steps on how to delete your account and all '
                        'associated data.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sharing of Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We do not share or sell your personal data to any third parties '
              'except in the following circumstances:',
            ),
            const SizedBox(height: 10),
            const Text(
              '- When required by law or to comply with legal processes.',
            ),
            const Text(
              '- When necessary to protect the rights, safety, and property of '
              'our company or other users.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Rights and Choices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'You have the following rights regarding your personal data:',
            ),
            const SizedBox(height: 10),
            const Text(
              '- Access: You can request access to the personal data we store '
              'about you.',
            ),
            const Text(
              '- Deletion: You can request that we delete your personal data.',
            ),
            const Text(
              '- Modification: You can request corrections or updates to your '
              'personal data if it is inaccurate.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Changes to This Privacy Policy.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We may update this Privacy Policy from time to time. When we '
              'do, we will notify you through the app or by other means so you '
              'can review the updated policy before continuing to use the app.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions or concerns about this Privacy Policy '
              'or your personal data, feel free to contact us at:',
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Email: ',
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
            const Text('Thank you for using ${constants.appName}!'),
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
            text: 'Could not launch ${url.path}. ',
            style: const TextStyle(color: Colors.white),
            children: <InlineSpan>[
              const TextSpan(
                text:
                    'You can copy this link and paste it into your browser:\n',
              ),
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
          label: 'Copy',
          onPressed: () => Clipboard.setData(
            ClipboardData(text: url.toString()),
          ),
        ),
        duration: const Duration(seconds: 10),
      ),
    );
  }
}

const String _updateDate = 'December 2024';
