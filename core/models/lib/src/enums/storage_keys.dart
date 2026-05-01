enum StorageKeys {
  authToken('auth_token'),
  signUpId('sign_up_id'),
  userId('user_id'),
  email('email'),
  languageIsoCode('language_iso_code'),
  appTheme('app_theme'),
  keepMeSignedIn('keep_me_signed_in');

  const StorageKeys(this.key);

  final String key;
}
