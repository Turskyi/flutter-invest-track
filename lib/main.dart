import 'package:authentication_repository/authentication_repository.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/application_services/blocs/theme/theme_bloc.dart';
import 'package:investtrack/di/injector.dart' as di;
import 'package:investtrack/di/injector.dart';
import 'package:investtrack/localization/localization_delelegate_getter.dart'
    as localization;
import 'package:investtrack/router/routes.dart' as router;
import 'package:investtrack/ui/app/app.dart';
import 'package:investtrack/ui/feedback/feedback_form.dart';

/// The [main] is the ultimate detail — the lowest-level policy.
/// It is the initial entry point of the system.
/// Nothing, other than the operating system, depends on it.
/// Here we should [injectDependencies] by a dependency injection framework.
/// The [main] is a dirty low-level module in the outermost circle of the onion
/// architecture.
/// Think of [main] as a plugin to the [App] — a plugin that sets
/// up the initial conditions and configurations, gathers all the outside
/// resources, and then hands control over to the high-level policy of the
/// [App].
/// When [main] is released, it has utterly no effect on any of the other
/// components in the system. They don’t know about [main], and they don’t care
/// when it changes.
Future<void> main() async {
  // Ensure that the Flutter engine is initialized, to avoid errors with
  // `SharedPreferences` dependencies initialization.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection and wait for `SharedPreferences`.
  final GetIt dependencies = await di.injectDependencies();

  final LocalizationDelegate localizationDelegate = await localization
      .getLocalizationDelegate();

  final AuthenticationRepository authenticationRepository = dependencies
      .get<AuthenticationRepository>();

  final AuthenticationBloc authenticationBloc = dependencies
      .get<AuthenticationBloc>();
  final MenuBloc menuBloc = dependencies.get<MenuBloc>();
  final ThemeBloc themeBloc = dependencies.get<ThemeBloc>();

  final InvestmentsBloc investmentsBloc = dependencies.get<InvestmentsBloc>(
    param1: false,
  );

  final Map<String, WidgetBuilder> routeMap = router.getRouteMap(
    investmentsBloc: investmentsBloc,
    authenticationBloc: authenticationBloc,
  );

  runApp(
    LocalizedApp(
      localizationDelegate,
      BetterFeedback(
        feedbackBuilder:
            (
              BuildContext _,
              OnSubmit onSubmit,
              ScrollController? scrollController,
            ) {
              return FeedbackForm(
                onSubmit: onSubmit,
                scrollController: scrollController,
              );
            },
        child: App(
          routeMap: routeMap,
          authenticationRepository: authenticationRepository,
          authenticationBloc: authenticationBloc,
          menuBloc: menuBloc,
          themeBloc: themeBloc,
        ),
      ),
    ),
  );
}
