import 'package:authentication_repository/authentication_repository.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/di/injector.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/localization/localization_delelegate_getter.dart'
    as localization;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/app/app.dart';
import 'package:investtrack/ui/feedback/feedback_form.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investments_page.dart';
import 'package:investtrack/ui/privacy/privacy_policy_page.dart';
import 'package:investtrack/ui/sign_in/sign_in_page.dart';

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
  await injectDependencies();

  final LocalizationDelegate localizationDelegate =
      await localization.getLocalizationDelegate();

  final AuthenticationRepository authenticationRepository =
      GetIt.instance<AuthenticationRepository>();
  final InvestmentsRepository investmentsRepository =
      GetIt.I.get<InvestmentsRepository>();
  final ExchangeRateRepository exchangeRateRepository =
      GetIt.I.get<ExchangeRateRepository>();
  final AuthenticationBloc authenticationBloc =
      GetIt.instance<AuthenticationBloc>();
  final MenuBloc menuBloc = GetIt.I.get<MenuBloc>();

  final Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
    AppRoute.investments.path: (_) => BlocProvider<InvestmentsBloc>(
          create: (_) => InvestmentsBloc(
            investmentsRepository,
            exchangeRateRepository,
            authenticationBloc,
          )..add(const LoadInvestments()),
          child: const InvestmentsPage(),
        ),
    AppRoute.signIn.path: (_) => const SignInPage(),
    AppRoute.privacyPolity.path: (_) => const PrivacyPolicyPage(),
    AppRoute.addInvestment.path: (_) => BlocProvider<InvestmentsBloc>(
          create: (_) => GetIt.I.get<InvestmentsBloc>(),
          child: const AddEditInvestmentPage(),
        ),
  };

  runApp(
    LocalizedApp(
      localizationDelegate,
      BetterFeedback(
        feedbackBuilder: (
          _,
          OnSubmit onSubmit,
          ScrollController? scrollController,
        ) =>
            FeedbackForm(
          onSubmit: onSubmit,
          scrollController: scrollController,
        ),
        child: App(
          routeMap: routeMap,
          authenticationRepository: authenticationRepository,
          authenticationBloc: authenticationBloc,
          menuBloc: menuBloc,
        ),
      ),
    ),
  );
}
