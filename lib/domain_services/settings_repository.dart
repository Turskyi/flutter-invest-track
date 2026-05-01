import 'package:models/models.dart';

abstract interface class SettingsRepository {
  const SettingsRepository();

  Language getLanguage();

  AppTheme getAppTheme();

  Future<bool> saveLanguageIsoCode(String languageIsoCode);

  Future<bool> saveAppTheme(AppTheme theme);
}
