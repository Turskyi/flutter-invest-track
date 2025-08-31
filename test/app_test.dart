import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:investtrack/application_services/blocs/authentication/authentication.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/localization/localization_delelegate_getter.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/app/app.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investments_page.dart';
import 'package:investtrack/ui/privacy/privacy_policy_page.dart';
import 'package:investtrack/ui/sign_in/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/user_repository.dart';

import 'flutter_translate_test_utils.dart';
import 'mocks/mock_blocs.dart';
import 'mocks/mock_repositories.dart';

void main() {
  late LocalizationDelegate localizationDelegate;
  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await setUpFlutterTranslateForTests();
    localizationDelegate = await getLocalizationDelegate();
  });
  // Set up the mock dependencies.
  final MockAuthenticationRepository authenticationRepository =
      MockAuthenticationRepository();
  final MockUserRepository userRepository = MockUserRepository();
  final MockInvestmentsRepository investmentsRepository =
      MockInvestmentsRepository();
  final MockExchangeRepository exchangeRateRepository =
      MockExchangeRepository();
  final AuthenticationBloc authenticationBloc = AuthenticationBloc(
    authenticationRepository: authenticationRepository,
    userRepository: userRepository,
  );
  final MockMenuBloc menuBloc = MockMenuBloc();

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

  // Register the mock dependencies with GetIt.
  GetIt.instance.registerSingleton<AuthenticationRepository>(
    authenticationRepository,
  );
  GetIt.instance.registerSingleton<AuthenticationBloc>(authenticationBloc);
  GetIt.instance.registerSingleton<UserRepository>(userRepository);
  GetIt.instance.registerSingleton<MenuBloc>(menuBloc);

  testWidgets('App loads and displays the sign-in page', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      prepareWidgetForTesting(
        LocalizedApp(
          localizationDelegate,
          App(
            routeMap: routeMap,
            authenticationRepository: authenticationRepository,
            authenticationBloc: authenticationBloc,
            menuBloc: menuBloc, // Provide the mock MenuBloc
          ),
        ),
        localizationDelegate,
      ),
    );
  });
}
