import 'package:authentication_repository/authentication_repository.dart';
import 'package:models/models.dart' as entity;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group('AuthenticationRepository', () {
    late _FakePreferences preferences;
    late AuthenticationRepository repository;

    setUp(() {
      preferences = _FakePreferences();
      repository = AuthenticationRepository(
        const _FakeRestClient(),
        preferences,
      );
    });

    tearDown(() {
      repository.dispose();
    });

    group('status', () {
      test(
        'emits UnauthenticatedStatus when no auth token is stored',
        () async {
          await expectLater(
            repository.status,
            emits(isA<UnauthenticatedStatus>()),
          );
        },
      );

      test(
        'emits AuthenticatedStatus when an auth token is stored',
        () async {
          await preferences.setString(
            entity.StorageKeys.authToken.key,
            'stored-token',
          );
          final AuthenticationRepository repoWithToken =
              AuthenticationRepository(
            const _FakeRestClient(),
            preferences,
          );

          await expectLater(
            repoWithToken.status,
            emits(isA<AuthenticatedStatus>()),
          );

          repoWithToken.dispose();
        },
      );
    });

    group('canSendCode', () {
      test('returns false when no sign-up ID is stored', () {
        expect(repository.canSendCode(), isFalse);
      });

      test('returns true when a sign-up ID is stored', () async {
        await preferences.setString(
          entity.StorageKeys.signUpId.key,
          'sign-up-id-123',
        );

        expect(repository.canSendCode(), isTrue);
      });
    });

    group('signOut', () {
      test('clears auth token from storage', () async {
        await preferences.setString(
          entity.StorageKeys.authToken.key,
          'token',
        );

        await repository.signOut();

        expect(
          preferences.getString(entity.StorageKeys.authToken.key),
          isNull,
        );
      });

      test('clears user ID from storage', () async {
        await preferences.setString(
          entity.StorageKeys.userId.key,
          'user-123',
        );

        await repository.signOut();

        expect(
          preferences.getString(entity.StorageKeys.userId.key),
          isNull,
        );
      });

      test('clears email from storage', () async {
        await preferences.setString(
          entity.StorageKeys.email.key,
          'user@example.com',
        );

        await repository.signOut();

        expect(
          preferences.getString(entity.StorageKeys.email.key),
          isNull,
        );
      });

      test('emits UnauthenticatedStatus', () async {
        final List<AuthenticationStatus> emitted = <AuthenticationStatus>[];

        // status yields the initial event synchronously inside the async*
        // generator, so listen before calling signOut.
        repository.status.listen(emitted.add);

        // Allow the async* generator to yield its initial event.
        await Future<void>.delayed(Duration.zero);

        await repository.signOut();

        expect(emitted.last, isA<UnauthenticatedStatus>());
      });
    });
  });
}

// ---------------------------------------------------------------------------
// Test doubles – in-memory fakes that avoid Flutter platform channels.
// ---------------------------------------------------------------------------

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

class _FakeRestClient implements entity.RestClient {
  const _FakeRestClient();

  @override
  Future<entity.LoginResponse> signEmail(String identifier) async =>
      _FakeLoginResponse();

  @override
  Future<entity.LoginResponse> signIn(
    String identifier,
    String password,
    String strategy,
  ) async =>
      _FakeLoginResponse();

  @override
  Future<entity.LogoutResponse> signOut() async => const _FakeLogoutResponse();

  @override
  Future<entity.InvestmentResult> createInvestment(
    entity.Investment investment,
  ) =>
      throw UnimplementedError();

  @override
  Future<entity.InvestmentResult> updateInvestment(
    entity.Investment investment,
  ) =>
      throw UnimplementedError();

  @override
  Future<entity.MessageResponse> deleteInvestment(
    String userId,
    int investmentId,
  ) =>
      throw UnimplementedError();

  @override
  Future<entity.Investments> getInvestments(
    String userId,
    int page,
    int itemsPerPage,
  ) =>
      throw UnimplementedError();

  @override
  Future<entity.MessageResponse> deleteAccount(String userId) =>
      throw UnimplementedError();

  @override
  Future<entity.ExchangeRate> getExchangeRate(String fromCurrency) =>
      throw UnimplementedError();

  @override
  Future<entity.PriceChange> fetchPriceChange(String ticker) =>
      throw UnimplementedError();

  @override
  Future<entity.ChangePercentage> fetchChangePercentage(String ticker) =>
      throw UnimplementedError();
}

class _FakeLoginResponse extends entity.LoginResponse {
  _FakeLoginResponse() : super(userId: 'fake-user-id', token: 'fake-token');
}

class _FakeLogoutResponse implements entity.LogoutResponse {
  const _FakeLogoutResponse();
}
