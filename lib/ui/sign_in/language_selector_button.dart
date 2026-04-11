import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:models/models.dart';

/// A button that allows the user to switch the app language.
///
/// Displays the flag and name of the currently active language and opens a
/// dropdown menu with all supported [Language] options.
class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentCode = LocalizedApp.of(
      context,
    ).delegate.currentLocale.languageCode;
    final Language current = Language.fromIsoLanguageCode(currentCode);

    return PopupMenuButton<Language>(
      tooltip: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(current.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 4),
            Text(current.name, style: Theme.of(context).textTheme.bodyMedium),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      onSelected: (Language language) {
        changeLocale(context, language.isoLanguageCode);
      },
      itemBuilder: (BuildContext context) => Language.values
          .map(
            (Language language) => PopupMenuItem<Language>(
              value: language,
              child: Row(
                children: <Widget>[
                  Text(language.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(language.name),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
