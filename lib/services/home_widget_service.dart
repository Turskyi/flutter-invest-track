import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/app_database.dart';
import 'package:models/models.dart';

abstract class HomeWidgetService {
  Future<void> setAppGroupId({required String appGroupId});

  Future<bool?> saveWidgetData<T>({required String id, required T? data});

  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  });

  Future<void> updateHomeWidget({
    required AppDatabase appDatabase,
    required String userId,
    required AppTheme appTheme,
    required SettingsRepository settingsRepository,
  });

  Future<void> requestPinWidget({
    String? name,
    String? androidName,
    String? qualifiedAndroidName,
  });
}
