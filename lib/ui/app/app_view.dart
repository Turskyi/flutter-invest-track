import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/theme/theme_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/res/theme/app_themes.dart' as app_themes;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/router/public_routes.dart';
import 'package:investtrack/ui/app/current_route_observer.dart';
import 'package:investtrack/ui/investments/investments_page.dart';
import 'package:investtrack/ui/not_found_page.dart';
import 'package:investtrack/ui/sign_in/sign_in_page.dart';
import 'package:investtrack/ui/sign_up/code_page.dart';
import 'package:models/models.dart';

/// [AppView] is a [StatefulWidget] because it maintains a [GlobalKey] which is
/// used to access the [NavigatorState]. By default, [AppView] will render the
/// [SplashPage] and it uses [BlocListener] to navigate to different pages
/// based on changes in the [AuthenticationState].
/// Upon a successful `signIn` request, the state of the [AuthenticationBloc]
/// will change to authenticated and the user will be navigated to the
/// [InvestmentsPage] where we display the user’s investments as well as a
/// button to sign out.
@immutable
class AppView extends StatefulWidget {
  const AppView({
    required this.routeMap,
    required this.authenticationBloc,
    super.key,
  });

  final AuthenticationBloc authenticationBloc;
  final Map<String, WidgetBuilder> routeMap;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final CurrentRouteObserver _currentRouteObserver = CurrentRouteObserver();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  late final String _initialRoute;

  @override
  void initState() {
    super.initState();
    _initialRoute = _resolveInitialRoute();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (BuildContext context, ThemeState themeState) {
        final ThemeData themeData = switch (themeState.theme) {
          AppTheme.vibrant => app_themes.vibrantTheme,
          AppTheme.stealth => app_themes.stealthTheme,
        };
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: constants.appName,
          initialRoute: _initialRoute,
          routes: widget.routeMap,
          onGenerateRoute: (RouteSettings settings) {
            final String routeName = settings.name ?? '';

            // Append slash if missing.
            final String normalizedRouteName = routeName.startsWith('/')
                ? routeName
                : '/$routeName';

            // Handle routes not covered in routeMap
            if (widget.routeMap.containsKey(normalizedRouteName)) {
              // Safely retrieve the widget builder from the route map.
              final WidgetBuilder? widgetBuilder =
                  widget.routeMap[normalizedRouteName];

              if (widgetBuilder != null) {
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => widgetBuilder(context),
                );
              }
            }

            // Fallback for unknown routes
            return MaterialPageRoute<void>(
              builder: (BuildContext _) => const NotFoundPage(),
            );
          },
          theme: themeData,
          navigatorKey: _navigatorKey,
          navigatorObservers: <NavigatorObserver>[_currentRouteObserver],
          builder: (BuildContext _, Widget? child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: _authenticationStateListener,
              child: child,
            );
          },
        );
      },
    );
  }

  void _authenticationStateListener(
    BuildContext context,
    AuthenticationState state,
  ) {
    final AuthenticationStatus status = state.status;

    switch (status) {
      case CodeAuthenticationStatus():
        _navigator?.pushAndRemoveUntil<void>(
          CodePage.route(email: status.email),
          (Route<Object?> _) => false,
        );
      case DeletingAuthenticatedUserStatus():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translate('app.account_deletion_in_progress')),
          ),
        );
      case AuthenticatedStatus():
        _navigator?.pushAndRemoveUntil<void>(
          InvestmentsPage.route(widget.authenticationBloc),
          (Route<void> route) => false,
        );
      case UnauthenticatedStatus():
        if (_isCurrentRoutePublic()) {
          _showStatusMessage(context, status.message);
        } else {
          _navigator?.pushAndRemoveUntil<void>(
            SignInPage.route(),
            (Route<void> route) => false,
          );
          _showStatusMessage(context, status.message);
        }
      case UnknownAuthenticationStatus():
        break;
    }
  }

  String _resolveInitialRoute() {
    final String defaultRouteName =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    final String normalizedRouteName = defaultRouteName.startsWith('/')
        ? defaultRouteName
        : '/$defaultRouteName';

    if (defaultRouteName.isNotEmpty &&
        defaultRouteName != Navigator.defaultRouteName &&
        widget.routeMap.containsKey(normalizedRouteName)) {
      return normalizedRouteName;
    } else {
      return AppRoute.signIn.path;
    }
  }

  bool _isCurrentRoutePublic() {
    final String? routeName = _currentRouteObserver.currentRouteName;
    return routeName != null && publicRoutePaths.contains(routeName);
  }

  void _showStatusMessage(BuildContext context, String message) {
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
    }
  }
}
