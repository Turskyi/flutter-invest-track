import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/ui/app/app_view.dart';
import 'package:nested/nested.dart';
import 'package:user_repository/user_repository.dart';

/// We are injecting a single instance of the [AuthenticationRepository] and
/// [UserRepository] into the [App] widget
/// It contains the root [App] widget for the entire application.
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
class App extends StatefulWidget {
  const App({
    required this.authenticationRepository,
    required this.authenticationBloc,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;

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
              return GetIt.I.get<MenuBloc>()
                ..add(const LoadingInitialMenuStateEvent());
            },
          ),
        ],
        child: AppView(authenticationBloc: widget.authenticationBloc),
      ),
    );
  }

  @override
  void dispose() {
    widget.authenticationRepository.dispose();
    super.dispose();
  }
}