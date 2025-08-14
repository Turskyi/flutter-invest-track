import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:investtrack/application_services/blocs/authentication/authentication.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/app/app.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investments_page.dart';
import 'package:investtrack/ui/privacy/privacy_policy_page.dart';
import 'package:investtrack/ui/sign_in/sign_in_page.dart';
import 'package:mockito/mockito.dart';
import 'package:user_repository/user_repository.dart';

void main() {
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
      App(
        routeMap: routeMap,
        authenticationRepository: authenticationRepository,
        authenticationBloc: authenticationBloc,
        menuBloc: menuBloc, // Provide the mock MenuBloc
      ),
    );

    // Verify that the sign-in page is displayed.
    expect(find.byType(SignInPage), findsOneWidget);
  });
}

// Define the mock classes
class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {
  @override
  Stream<AuthenticationStatus> get status =>
      Stream<AuthenticationStatus>.value(const AuthenticatedStatus());
}

class MockUserRepository extends Mock implements UserRepository {}

class MockInvestmentsRepository extends Mock implements InvestmentsRepository {}

class MockExchangeRepository extends Mock implements ExchangeRateRepository {}

class MockMenuBloc extends Mock implements MenuBloc {}
