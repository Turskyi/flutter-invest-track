import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:models/models.dart';

Future<LocalizationDelegate> getLocalizationDelegate() async {
  // Get the singleton instance of the `PlatformDispatcher`.
  final PlatformDispatcher platformDispatcher = PlatformDispatcher.instance;

  // Get the current locale from the `PlatformDispatcher`.
  final Locale deviceLocale = platformDispatcher.locale;

  // Get the language code from the `Locale`.
  final String deviceIsoLanguageCode = deviceLocale.languageCode;
  final String fallbackLocale = Language.fromIsoLanguageCode(
    deviceIsoLanguageCode,
  ).isoLanguageCode;
  final LocalizationDelegate localizationDelegate =
      await LocalizationDelegate.create(
        fallbackLocale: fallbackLocale,
        supportedLocales: Language.values
            .map((Language language) => language.isoLanguageCode)
            .toList(),
      );

  // Apply subdomain override on Web.
  final String? subdomainCode = _getSubdomainLanguageCode();

  if (subdomainCode != null) {
    final Locale subdomainLocale = Locale(subdomainCode);

    if (localizationDelegate.currentLocale.languageCode != subdomainCode) {
      await localizationDelegate.changeLocale(subdomainLocale);
    }
  }

  return localizationDelegate;
}

String? _getSubdomainLanguageCode() {
  if (kIsWeb) {
    final String host = Uri.base.host;
    final List<String> hostParts = host.split('.');

    // Check for at least [subdomain, domain, tld] e.g. uk.investtracks.com
    if (hostParts.length >= 3) {
      final String subdomain = hostParts.first.toLowerCase();

      final bool isSupported = Language.values.any(
        (Language l) => l.isoLanguageCode == subdomain,
      );

      if (isSupported) {
        return subdomain;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } else {
    return null;
  }
}
