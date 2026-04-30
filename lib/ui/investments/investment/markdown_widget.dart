import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownWidget extends StatelessWidget {
  const MarkdownWidget({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Markdown(
      shrinkWrap: true,
      data: content,
      styleSheet: MarkdownStyleSheet.fromTheme(themeData).copyWith(
        p: themeData.textTheme.bodyLarge,
        listBullet: TextStyle(color: themeData.colorScheme.tertiary),
        a: const TextStyle(
          // Green for links.
          color: Colors.green,
          decoration: TextDecoration.underline,
        ),
      ),
      onTapLink: (String text, String? href, String title) async {
        if (href != null) {
          final Uri uri = Uri.parse(href);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            // Handle error
            debugPrint('Could not launch $href');
          }
        }
      },
    );
  }
}
