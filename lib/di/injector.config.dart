// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:authentication_repository/authentication_repository.dart'
    as _i223;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart'
    as _i636;
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart'
    as _i91;
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart'
    as _i682;
import 'package:investtrack/application_services/blocs/sign_in/bloc/sign_in_bloc.dart'
    as _i141;
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart'
    as _i445;
import 'package:investtrack/application_services/repositories/exchange_rate_repository_impl.dart'
    as _i741;
import 'package:investtrack/application_services/repositories/investments_repository_impl.dart'
    as _i233;
import 'package:investtrack/application_services/repositories/settings_repository_impl.dart'
    as _i803;
import 'package:investtrack/di/authentication_repository_module.dart' as _i828;
import 'package:investtrack/di/dio_http_client_module.dart' as _i617;
import 'package:investtrack/di/preferences_module.dart' as _i270;
import 'package:investtrack/di/rest_client_module.dart' as _i939;
import 'package:investtrack/di/retrofit_http_client_module.dart' as _i825;
import 'package:investtrack/di/user_repository_module.dart' as _i280;
import 'package:investtrack/domain_services/exchange_rate_repository.dart'
    as _i30;
import 'package:investtrack/domain_services/investments_repository.dart'
    as _i305;
import 'package:investtrack/domain_services/settings_repository.dart' as _i113;
import 'package:investtrack/infrastructure/ws/rest/interceptors/logging_interceptor.dart'
    as _i204;
import 'package:investtrack/infrastructure/ws/rest/retrofit_client/retrofit_client.dart'
    as _i651;
import 'package:models/models.dart' as _i669;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:user_repository/user_repository.dart' as _i164;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initDependencyInjection({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final userRepositoryModule = _$UserRepositoryModule();
    final dioHttpClientModule = _$DioHttpClientModule();
    final restClientModule = _$RestClientModule();
    final retrofitHttpClientModule = _$RetrofitHttpClientModule();
    final authenticationRepositoryModule = _$AuthenticationRepositoryModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.factory<_i204.LoggingInterceptor>(
      () => const _i204.LoggingInterceptor(),
    );
    gh.lazySingleton<_i164.UserRepository>(
      () =>
          userRepositoryModule.getUserRepository(gh<_i460.SharedPreferences>()),
    );
    await gh.factoryAsync<_i361.Dio>(
      () =>
          dioHttpClientModule.getDioHttpClient(gh<_i204.LoggingInterceptor>()),
      preResolve: true,
    );
    gh.lazySingleton<_i669.RestClient>(
      () => restClientModule.getRestClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i651.RetrofitClient>(
      () => retrofitHttpClientModule.getRetrofitHttpClient(gh<_i361.Dio>()),
    );
    gh.factory<_i30.ExchangeRateRepository>(
      () => _i741.ExchangeRateRepositoryImpl(gh<_i669.RestClient>()),
    );
    gh.lazySingleton<_i223.AuthenticationRepository>(
      () => authenticationRepositoryModule.getAuthenticationRepository(
        gh<_i651.RetrofitClient>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i305.InvestmentsRepository>(
      () => _i233.InvestmentsRepositoryImpl(
        gh<_i669.RestClient>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i113.SettingsRepository>(
      () => _i803.SettingsRepositoryImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i682.MenuBloc>(
      () => _i682.MenuBloc(gh<_i113.SettingsRepository>()),
    );
    gh.factory<_i636.AuthenticationBloc>(
      () => _i636.AuthenticationBloc(
        authenticationRepository: gh<_i223.AuthenticationRepository>(),
        userRepository: gh<_i164.UserRepository>(),
      ),
    );
    gh.factory<_i141.SignInBloc>(
      () => _i141.SignInBloc(
        authenticationRepository: gh<_i223.AuthenticationRepository>(),
      ),
    );
    gh.factory<_i445.SignUpBloc>(
      () => _i445.SignUpBloc(
        authenticationRepository: gh<_i223.AuthenticationRepository>(),
      ),
    );
    gh.factory<_i91.InvestmentsBloc>(
      () => _i91.InvestmentsBloc(
        gh<_i305.InvestmentsRepository>(),
        gh<_i30.ExchangeRateRepository>(),
        gh<_i636.AuthenticationBloc>(),
      ),
    );
    return this;
  }
}

class _$SharedPreferencesModule extends _i270.SharedPreferencesModule {}

class _$UserRepositoryModule extends _i280.UserRepositoryModule {}

class _$DioHttpClientModule extends _i617.DioHttpClientModule {}

class _$RestClientModule extends _i939.RestClientModule {}

class _$RetrofitHttpClientModule extends _i825.RetrofitHttpClientModule {}

class _$AuthenticationRepositoryModule
    extends _i828.AuthenticationRepositoryModule {}
