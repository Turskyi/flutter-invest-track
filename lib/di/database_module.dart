import 'package:injectable/injectable.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/app_database.dart';

@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();
}
