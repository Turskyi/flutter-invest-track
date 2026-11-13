import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/application_services/blocs/theme/theme_bloc.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/services/home_widget_service.dart';
import 'package:investtrack/ui/app/app_view.dart';
import 'package:nested/nested.dart';

/// The root [App] widget for the entire application.
/// [App] is responsible for creating/providing the [AuthenticationBloc] which
/// will be consumed by the [AppView]. This decoupling will enable us to
/// easily test both the [App] and [AppView] widgets.
/// [RepositoryProvider] shares the authentication and settings repositories
/// throughout the application.
/// By default, [BlocProvider] is lazy and does not call create until the first
/// time the Bloc is accessed. Since [AuthenticationBloc] should always
/// subscribe to the [AuthenticationStatus] stream immediately (via the
/// [AuthenticationSubscriptionRequested] event), we can explicitly opt out of
/// this behavior by setting `lazy: false`.
/// The implementation of the way we dispose repository was inspired by
/// https://github.com/felangel/bloc/blob/master/examples/flutter_login/lib/app.dart
/// from https://bloclibrary.dev/tutorials/flutter-login/.
///
/// App remains separate from main to preserve Onion Architecture
/// boundaries and keep the root widget tree testable. Inlining App into main
/// would couple low-level system bootstrapping with high-level composition.
class App extends StatelessWidget {
  const App({
    required this.routeMap,
    required this.authenticationRepository,
    required this.authenticationBloc,
    required this.menuBloc,
    required this.themeBloc,
    required this.investmentsRepository,
    required this.exchangeRateRepository,
    required this.homeWidgetService,
    required this.settingsRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;
  final MenuBloc menuBloc;
  final ThemeBloc themeBloc;
  final InvestmentsRepository investmentsRepository;
  final ExchangeRateRepository exchangeRateRepository;
  final HomeWidgetService homeWidgetService;
  final SettingsRepository settingsRepository;
  final Map<String, WidgetBuilder> routeMap;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<SettingsRepository>.value(
      value: settingsRepository,
      child: RepositoryProvider<AuthenticationRepository>(
        create: (BuildContext _) => authenticationRepository,
        dispose: (AuthenticationRepository repository) => repository.dispose(),
        child: MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<AuthenticationBloc>(
              // Create the bloc eagerly to observe authentication state.
              lazy: false,
              create: (BuildContext _) {
                return authenticationBloc
                  ..add(const AuthenticationSubscriptionRequested());
              },
            ),
            BlocProvider<MenuBloc>(
              create: (BuildContext _) {
                return menuBloc..add(const LoadingInitialMenuStateEvent());
              },
            ),
            BlocProvider<ThemeBloc>(create: (BuildContext _) => themeBloc),
          ],
          child: AppView(
            routeMap: routeMap,
            authenticationBloc: authenticationBloc,
            investmentsRepository: investmentsRepository,
            exchangeRateRepository: exchangeRateRepository,
            homeWidgetService: homeWidgetService,
            settingsRepository: settingsRepository,
          ),
        ),
      ),
    );
  }
}
