import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock translation data for tests.
const Map<String, Object?> _enTestTranslations = <String, Object?>{
  'title': 'PortionControl',
  'submit': 'Submit',
  'app_id': 'App id',
  'app_version': 'App version',
  'build_number': 'Build number',
  'features': 'Features',
  'support_and_feedback': 'Support & Feedback',
  'telegram_group': 'Telegram Support Group',
  'developer_contact_form': 'Developer Contact Form',
  'privacy_policy': 'Privacy Policy',
  'last_updated': 'Last updated',
  'for': 'for',
  'android_app': 'Android Application',
  'location': 'Location Data',
  'third_party': 'Third-Party Services',
  'consent': 'Consent',
  'children_privacy': "Children's Privacy",
  'crashlytics': 'Crashlytics',
  'contact_us': 'Contact Us',
  'platform_specific': 'Platform-Specific Features',
  'mobile': 'Mobile (Android/iOS)',
  'macos': 'macOS',
  'web': 'Web',
  'never_updated': 'Never updated',
  'could_not_launch': 'Could not launch',
  'faq': 'Frequently Asked Questions',
  'legal_and_app_info_title': '📄 Legal & App Info',
  'developer': 'Developer',
  'email': 'Email',
  'last_updated_on_label': 'Last Updated on',
  'no': 'No',
  'yes': 'Yes',
  'cancel': 'Cancel',
  'ukrainian': 'Ukrainian',
  'english': 'English',
  'en': 'EN',
  'uk': 'UK',
  'platform': 'Platform',
  'android': 'Android',
  'ios': 'iOS',
  'windows': 'Windows',
  'linux': 'Linux',
  'unknown': 'Unknown',
  'feedback': <String, String>{
    'title': 'Feedback',
    'app_feedback': 'App Feedback',
    'what_kind': 'What kind of feedback do you want to give?',
    'what_is_your_feedback': 'What is your feedback?',
    'how_does_this_feel': 'How does this make you feel?',
    'sent': 'Your feedback has been sent successfully!',
    'bug_report': 'Bug report',
    'feature_request': 'Feature request',
    'type': 'Feedback Type',
    'rating': 'Rating',
    'bad': 'Bad',
    'neutral': 'Neutral',
    'good': 'Good',
  },
  'error': <String, String>{
    'please_check_internet':
        'An error occurred. Please check your internet connection and try '
        'again.',
    'unexpected_error': 'An unexpected error occurred. Please try again.',
    'oops': 'Oops! Something went wrong. Please try again later.',
    'cors':
        'Error: Local Environment Setup Required\nTo run this application '
        'locally on web, please use the following command:\nflutter run -d '
        'chrome --web-browser-flag "--disable-web-security"\nThis step is '
        'necessary to bypass CORS restrictions during local development. '
        'Please note that this flag should only be used in a development '
        'environment and never in production.',
    'launch_email_or_support_page': 'Could not launch email or support page.',
    'something_went_wrong': 'Something went wrong!',
    'launch_email_app_to_address':
        'Could not launch email app to send an email to {emailAddress}',
    'launch_email_failed': 'Could not launch the email application.',
  },
  'settings': <String, String>{
    'title': 'Settings',
    'language': 'Language',
    'feedback_subtitle':
        'Let us know your thoughts and suggestions. You can also report any '
        'issues with the app’s content.',
    'support_subtitle':
        'Visit our support page for help and frequently asked questions.',
  },
  'about': <String, String>{
    'title': 'About',
    'privacy_title': 'Privacy & Data',
    'privacy_description':
        '«{appName}» does not collect or store any personal data. Your '
        'approximate location is used only to show the local weather and '
        'is never shared. Outfit suggestions are generated on-device based '
        'on the weather conditions. You can read the full privacy policy '
        'below.',
    'view_privacy_policy': 'View Privacy Policy',
    'support_description':
        'Having trouble? Need help or want to suggest a feature? Join the '
        'community or contact the developer directly.',
    'contact_support': 'Contact Support',
  },
  'privacy': <String, String>{
    'policy_intro':
        "Your privacy is important to us. It is {appName}'s policy to respect "
        'your privacy and comply with any applicable law and regulation '
        'regarding any personal information we may collect about you, '
        'including across our app, «{appName}», and its associated '
        'services.',
    'information_we_collect': 'Information We Collect',
    'no_personal_data_collection':
        'We do not collect any personal information such as name, email '
        'address, or phone number.',
    'third_party_services_info':
        '«{appName}» uses third-party services that may collect information '
        'used to identify you. These services include Firebase Crashlytics '
        'and Google Analytics. The data collected by these services is '
        'used to improve app stability and user experience. You can find '
        'more information about their privacy practices at their '
        'respective websites.',
    'consent_agreement':
        'By using our services, you consent to the collection and use of your '
        'information as described in this privacy policy.',
    'security_measures': 'Security Measures',
    'security_measures_description':
        'We take reasonable measures to protect your information from '
        'unauthorized access, disclosure, or modification.',
    'children_description':
        'Our services are not directed towards children under the age of '
        '{age}. We do not knowingly collect personal information from '
        'children under {age}. While we strive to minimize data '
        'collection, third-party services we use (such as Firebase '
        'Crashlytics and Google Analytics) may collect some data. However, '
        'this data is collected anonymously and is not linked to any '
        'personal information. If you believe that a child under {age} has '
        'provided us with personal information, please contact us, and we '
        'will investigate the matter.',
    'crashlytics_description':
        '«{appName}» uses Firebase Crashlytics, a service by Google, to '
        'collect crash reports anonymously to help us improve app '
        'stability and fix bugs. The data collected by Crashlytics does '
        'not include any personal information.',
    'updates_and_notifications_description':
        'This privacy policy may be updated periodically. Any changes to the '
        'policy will be communicated to you through app updates or '
        'notifications.',
    'contact_us_invitation':
        'For any questions or concerns regarding your privacy, you may contact '
        'us using the following details:',
    'platform_specific_intro':
        '«{appName}» offers different features depending on the platform you '
        'are using (mobile, macOS, or web). Please note the following '
        'platform-specific details:',
  },
  'support': <String, String>{
    'title': 'Support',
    'intro_line':
        'Need help or want to give feedback? You’re in the right place.',
    'contact_intro': 'If you’re experiencing issues or have suggestions:',
    'contact_us_via_email_button': 'Contact Us via Email',
    'join_telegram_support_button': 'Join Telegram Support Group',
    'visit_developer_support_website_button':
        "Visit Support Page on Developer's Website",
    'email_default_body': 'Hi, I need help with...',
  },
};

Future<LocalizationDelegate> setUpFlutterTranslateForTests({
  Locale startLocale = const Locale('en'),
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});

  final String englishLanguageCode = Language.en.isoLanguageCode;
  final LocalizationDelegate delegate = await LocalizationDelegate.create(
    fallbackLocale: englishLanguageCode,
    supportedLocales: <String>[englishLanguageCode],
  );

  // Manually load translations for the starting locale into the static
  // Localization instance.
  // This is the key to bypassing the file loading for the actual translation
  // content.
  if (startLocale.languageCode == englishLanguageCode) {
    Localization.load(_enTestTranslations);
  } else {
    // Load fallback or throw error if startLocale is not one of your test
    // locales.
    Localization.load(_enTestTranslations);
  }

  // Ensure the delegate's internal state reflects this locale.
  // The call to Localization.load above primes the static instance.
  // The changeLocale method in the delegate will use this primed instance
  // if its internal logic calls Localization.instance.
  // Or, more directly, it also calls Localization.load itself.
  await delegate.changeLocale(startLocale);

  return delegate;
}

// Helper to wrap a widget with necessary providers for testing
Widget prepareWidgetForTesting(
  Widget child,
  LocalizationDelegate localizationDelegate,
) {
  return MaterialApp(
    localizationsDelegates: <LocalizationsDelegate<Object?>>[
      localizationDelegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: localizationDelegate.supportedLocales,
    locale: localizationDelegate.currentLocale,
    home: Material(child: child),
  );
}
