// ignore_for_file: avoid_print
import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:models/models.dart' as entity;
import 'package:shared_preferences/shared_preferences.dart';

/// A minimal stand-alone illustration of [AuthenticationRepository].
///
/// In a real application:
/// - Obtain a [SharedPreferences] instance via
///   `SharedPreferences.getInstance()` after calling
///   `WidgetsFlutterBinding.ensureInitialized()`.
/// - Provide a concrete [RestClient] implementation (e.g. backed by Dio /
///   Retrofit) to communicate with your back-end.
///
/// This example wires up a fake [RestClient] and an in-memory preferences stub
/// so that the flow can be shown without real network calls or Flutter.
void main() async {
  // 1. Build the repository with its two required collaborators.
  //
  //    Replace [_FakeRestClient] and [_FakePreferences] with real
  //    implementations from your dependency-injection graph.
  final AuthenticationRepository repository = AuthenticationRepository(
    const _FakeRestClient(),
    _FakePreferences(),
  );

  // 2. Subscribe to the authentication-status stream before performing any
  //    operations so that the initial status is captured.
  final StreamSubscription<AuthenticationStatus> subscription =
      repository.status.listen(
    (AuthenticationStatus status) {
      switch (status) {
        case AuthenticatedStatus():
          print('Status → authenticated');
        case UnauthenticatedStatus():
          print('Status → unauthenticated');
        case CodeAuthenticationStatus(email: final String email):
          print('Status → verification code sent to $email');
        case DeletingAuthenticatedUserStatus():
          print('Status → deleting account…');
        case UnknownAuthenticationStatus():
          print('Status → unknown');
      }
    },
  );

  // 3. Sign in with email + password.
  try {
    final entity.User user = await repository.signIn(
      email: 'investor@example.com',
      password: 'P@ssw0rd!',
    );
    print('Signed in as ${user.email} (id: ${user.id})');
  } catch (e) {
    print('Sign-in failed: $e');
  }

  // 4. Sign out.
  await repository.signOut();

  // 5. Clean up resources when the repository is no longer needed.
  await subscription.cancel();
  repository.dispose();
}

// ---------------------------------------------------------------------------
// Stubs used only by this example – not part of the package API.
// ---------------------------------------------------------------------------

// Minimal concrete implementations of the abstract response types needed
// to satisfy the RestClient interface in this example.
class _LoginResponse extends entity.LoginResponse {
  const _LoginResponse() : super(userId: 'demo-user-id', token: 'demo-token');
}

class _LogoutResponse implements entity.LogoutResponse {
  const _LogoutResponse();
}

class _FakeRestClient implements entity.RestClient {
  const _FakeRestClient();

  @override
  Future<entity.LoginResponse> signEmail(String identifier) async =>
      const _LoginResponse();

  @override
  Future<entity.LoginResponse> signIn(
    String identifier,
    String password,
    String strategy,
  ) async =>
      const _LoginResponse();

  @override
  Future<entity.LogoutResponse> signOut() async => const _LogoutResponse();

  @override
  Future<entity.InvestmentResult> createInvestment(
    entity.Investment investment,
  ) async =>
      throw UnimplementedError();

  @override
  Future<entity.InvestmentResult> updateInvestment(
    entity.Investment investment,
  ) async =>
      throw UnimplementedError();

  @override
  Future<entity.MessageResponse> deleteInvestment(
    String userId,
    int investmentId,
  ) async =>
      throw UnimplementedError();

  @override
  Future<entity.Investments> getInvestments(
    String userId,
    int page,
    int itemsPerPage,
  ) async =>
      throw UnimplementedError();

  @override
  Future<entity.MessageResponse> deleteAccount(String userId) async =>
      throw UnimplementedError();

  @override
  Future<entity.ExchangeRate> getExchangeRate(String fromCurrency) async =>
      throw UnimplementedError();

  @override
  Future<entity.PriceChange> fetchPriceChange(String ticker) async =>
      throw UnimplementedError();

  @override
  Future<entity.ChangePercentage> fetchChangePercentage(String ticker) async =>
      throw UnimplementedError();
}

class _FakePreferences implements SharedPreferences {
  final Map<String, Object> _store = <String, Object>{};

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _store.remove(key);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
        '${invocation.memberName} is not implemented in _FakePreferences',
      );
}
