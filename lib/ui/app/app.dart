import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/ui/app/app_view.dart';
import 'package:nested/nested.dart';

/// The root [App] widget for the entire application.
/// [App] is responsible for creating/providing the [AuthenticationBloc] which
/// will be consumed by the [AppView]. This decoupling will enable us to
/// easily test both the [App] and [AppView] widgets.
/// [RepositoryProvider] is used to provide the single instance of
/// [AuthenticationRepository] to the entire application.
/// By default, [BlocProvider] is lazy and does not call create until the first
/// time the Bloc is accessed. Since [AuthenticationBloc] should always
/// subscribe to the [AuthenticationStatus] stream immediately (via the
/// [AuthenticationSubscriptionRequested] event), we can explicitly opt out of
/// this behavior by setting `lazy: false`.
/// The implementation of the way we dispose repository was inspired by
/// https://github.com/felangel/bloc/blob/master/examples/flutter_login/lib/app.dart
/// from https://bloclibrary.dev/tutorials/flutter-login/.
class App extends StatefulWidget {
  const App({
    required this.routeMap,
    required this.authenticationRepository,
    required this.authenticationBloc,
    required this.menuBloc,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;
  final MenuBloc menuBloc;
  final Map<String, WidgetBuilder> routeMap;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationRepository>.value(
      value: widget.authenticationRepository,
      child: MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<AuthenticationBloc>(
            // By default, BlocProvider is lazy and does not call create until
            // the first time the Bloc is accessed. Since AuthenticationBloc
            // should always subscribe to the AuthenticationStatus stream
            // immediately (via the AuthenticationSubscriptionRequested event),
            // we can explicitly opt out of this behavior by setting `lazy:
            // false`.
            lazy: false,
            create: (_) => widget.authenticationBloc
              ..add(const AuthenticationSubscriptionRequested()),
          ),
          BlocProvider<MenuBloc>(
            create: (_) {
              return widget.menuBloc..add(const LoadingInitialMenuStateEvent());
            },
          ),
        ],
        child: AppView(
          routeMap: widget.routeMap,
          authenticationBloc: widget.authenticationBloc,
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.authenticationRepository.dispose();
    super.dispose();
  }
}
