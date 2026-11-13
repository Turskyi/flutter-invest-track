import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/app_database.dart';
import 'package:investtrack/services/home_widget_service.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

class MockHomeWidgetService extends Mock implements HomeWidgetService {
  @override
  Future<void> updateHomeWidget({
    required AppDatabase appDatabase,
    required String userId,
    required AppTheme appTheme,
    required SettingsRepository settingsRepository,
  }) async {}

  @override
  Future<void> setAppGroupId({required String appGroupId}) async {}

  @override
  Future<bool?> saveWidgetData<T>({
    required String id,
    required T? data,
  }) async => true;

  @override
  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  }) async => true;
}
