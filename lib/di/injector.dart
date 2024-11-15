import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:investtrack/di/injector.config.dart';

@InjectableInit(initializerName: 'initDependencyInjection')
Future<GetIt> injectDependencies() => GetIt.I.initDependencyInjection();
