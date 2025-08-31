import 'dart:async';

import 'package:authentication_repository/src/authentication_status.dart';
import 'package:authentication_repository/src/env/env.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_auth/clerk_auth.dart';
import 'package:models/models.dart' as entity;
import 'package:shared_preferences/shared_preferences.dart';

/// The [AuthenticationRepository] exposes a [Stream] of [AuthenticationStatus]
/// updates which will be used to notify the application when a user signs in
/// or out.
/// Since we are maintaining a [StreamController] internally, a [dispose]
/// method is exposed so that the controller can be closed when it is no longer
/// needed.
class AuthenticationRepository {
  AuthenticationRepository(this._restClient, this._preferences);

  final entity.RestClient _restClient;
  final SharedPreferences _preferences;

  final StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>();

  clerk.Auth? _auth;

  Stream<AuthenticationStatus> get status async* {
    final bool isAuthenticated = _checkInitialAuthenticationStatus();

    if (isAuthenticated) {
      yield AuthenticationStatus.authenticated();
    } else {
      yield AuthenticationStatus.unauthenticated();
    }

    // Yield the stream of authentication status changes.
    yield* _controller.stream;
  }

  Future<entity.User> signIn({
    required String email,
    required String password,
  }) async {
    await _authInit();
    final String trimmedEmail = email.trim();
    final String trimmedPassword = password.trim();
    await _auth?.attemptSignIn(
      strategy: clerk.Strategy.password,
      identifier: trimmedEmail,
      password: trimmedPassword,
    );

    String userId = _auth?.user?.id ?? '';

    if (userId.isEmpty) {
      try {
        await _restClient.signEmail(trimmedEmail);

        final entity.LoginResponse loginResponse = await _restClient.signIn(
          trimmedEmail,
          trimmedPassword,
          Strategy.password.name,
        );
        userId = loginResponse.userId;
        await _saveUserId(userId);
        await _saveToken(loginResponse.token);
      } catch (e) {
        if (!e.toString().contains('422')) {
          rethrow;
        }
      }
    } else {
      await _saveUserId(userId);
    }
    await _saveEmail(trimmedEmail);
    _controller.add(AuthenticationStatus.authenticated());
    return entity.User(id: userId, email: trimmedEmail);
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _authInit();

    final String trimmedEmail = email.trim();
    final String trimmedPassword = password.trim();

    final clerk.Client? signUpResponse = await _auth?.attemptSignUp(
      strategy: clerk.Strategy.password,
      emailAddress: trimmedEmail,
      password: trimmedPassword,
      passwordConfirmation: trimmedPassword,
    );

    final String? signUpId = signUpResponse?.id;

    if (signUpId?.isNotEmpty == true) {
      await _saveSignUpId(signUpId ?? '');

      _controller.add(AuthenticationStatus.code(trimmedEmail));
    }

    await _saveEmail(trimmedEmail);
  }

  Future<void> sendCodeToUser() async {
    final String signUpId = _preferences.getString(
          entity.StorageKeys.signUpId.key,
        ) ??
        '';

    if (signUpId.isNotEmpty) {
      await _authInit();

      await _auth?.attemptSignUp(
        strategy: clerk.Strategy.resetPasswordEmailCode,
        emailAddress: _email,
      );
    } else {
      //TODO:  this should never happen, so better come up with better handling.
      throw Exception('Signup id is empty');
    }
  }

  Future<void> verify(String code) async {
    final String signUpId = _preferences.getString(
          entity.StorageKeys.signUpId.key,
        ) ??
        '';

    if (signUpId.isNotEmpty) {
      await _authInit();

      final clerk.Client? clerkClient = await _auth?.attemptSignUp(
        strategy: clerk.Strategy.emailCode,
        code: code,
      );

      final String? userId = clerkClient?.user?.id;

      if (userId?.isNotEmpty == true) {
        await _saveUserId(userId ?? '');
        _controller.add(AuthenticationStatus.authenticated());
        await _removeSignUpId();
      } else {
        //TODO: come up with better handling.
        throw Exception('User id is empty');
      }
    } else {
      //TODO:  this should never happen, so better come up with better handling.
      _controller.add(AuthenticationStatus.unauthenticated());
    }
  }

  Future<void> signOut() async {
    await _auth?.signOut();
    _auth?.terminate();

    await _removeToken();
    await _removeEmail();
    await _removeUserId();
    _controller.add(AuthenticationStatus.unauthenticated());
  }

  void dispose() {
    _auth?.terminate();
    _controller.close();
  }

  bool _checkInitialAuthenticationStatus() {
    final String token = _preferences.getString(
          entity.StorageKeys.authToken.key,
        ) ??
        '';
    return token.isNotEmpty;
  }

  Future<bool> _saveToken(String token) {
    return _preferences.setString(entity.StorageKeys.authToken.key, token);
  }

  Future<bool> _saveUserId(String userId) {
    return _preferences.setString(entity.StorageKeys.userId.key, userId);
  }

  Future<bool> _saveSignUpId(String id) {
    return _preferences.setString(entity.StorageKeys.signUpId.key, id);
  }

  Future<bool> _saveEmail(String email) {
    return _preferences.setString(entity.StorageKeys.email.key, email);
  }

  String get _email =>
      _preferences.getString(entity.StorageKeys.email.key) ?? '';

  Future<bool> _removeToken() =>
      _preferences.remove(entity.StorageKeys.authToken.key);

  Future<bool> _removeSignUpId() => _preferences.remove(
        entity.StorageKeys.signUpId.key,
      );

  Future<bool> _removeEmail() {
    return _preferences.remove(entity.StorageKeys.email.key);
  }

  Future<bool> _removeUserId() =>
      _preferences.remove(entity.StorageKeys.userId.key);

  Future<entity.MessageResponse> deleteAccount(String userId) {
    _controller.add(AuthenticationStatus.deleting());
    return signOut().then((_) => _restClient.deleteAccount(userId));
  }

  bool canSendCode() {
    final String signUpId = _preferences.getString(
          entity.StorageKeys.signUpId.key,
        ) ??
        '';
    return signUpId.isNotEmpty;
  }

  Future<void> _authInit() async {
    if (_auth == null) {
      _auth = clerk.Auth(
        config: const clerk.AuthConfig(
          publishableKey: Env.clerkPublishableKey,
          persistor: Persistor.none,
        ),
      );

      await _auth?.initialize();
    }
  }
}
