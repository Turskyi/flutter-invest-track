import 'package:flutter/material.dart';
import 'package:investtrack/application_services/repositories/settings_repository_impl.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/app_database.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/services/home_widget_service.dart';
import 'package:investtrack/services/home_widget_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const String kWidgetUpdateTask = 'com.investtracks.widgetUpdateTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((
    String task,
    Map<String, Object?>? inputData,
  ) async {
    try {
      final Object? rawUserId = inputData?[constants.kUserIdKey];
      final String? inputUserId = rawUserId is String ? rawUserId : null;
      if (inputUserId == null || inputUserId.isEmpty) {
        debugPrint(
          'WidgetBackgroundWorker warning: missing userId in inputData. '
          'Aborting background widget update.',
        );
        return false;
      }
      final String userId = inputUserId;

      // Manual dependency construction (Dependency Injection without
      // service locator).
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final AppDatabase appDatabase = AppDatabase();
      final SettingsRepository settingsRepository = SettingsRepositoryImpl(
        prefs,
      );
      final HomeWidgetService homeWidgetService = const HomeWidgetServiceImpl();

      await homeWidgetService.updateHomeWidget(
        appDatabase: appDatabase,
        userId: userId,
        appTheme: settingsRepository.getAppTheme(),
        settingsRepository: settingsRepository,
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('WidgetBackgroundWorker error: $e\n$stackTrace');
      return false;
    }
  });
}
