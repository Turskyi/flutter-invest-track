import 'package:authentication_repository/authentication_repository.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {
  @override
  Stream<AuthenticationStatus> get status =>
      Stream<AuthenticationStatus>.value(const AuthenticatedStatus());
}

class MockUserRepository extends Mock implements UserRepository {}

class MockInvestmentsRepository extends Mock implements InvestmentsRepository {}

class MockExchangeRepository extends Mock implements ExchangeRateRepository {}
