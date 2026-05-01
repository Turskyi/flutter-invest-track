import 'dart:async';
import 'dart:io';

import 'package:authentication_repository/src/authentication_status.dart';
import 'package:authentication_repository/src/env/env.dart';
import 'package:authentication_repository/src/shared_prefs_persistor.dart';
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

  String? _inMemoryToken;
  String? _inMemoryUserId;
  String? _inMemoryEmail;

  Stream<AuthenticationStatus> get status async* {
    if (_auth == null) {
      await _authInit();
    }
    final bool isAuthenticated = _checkInitialAuthenticationStatus();

    if (isAuthenticated) {
      yield AuthenticationStatus.authenticated(userId: userId, email: _email);
    } else {
      yield AuthenticationStatus.unauthenticated();
    }

    // Yield the stream of authentication status changes.
    yield* _controller.stream;
  }

  Future<entity.User> signIn({
    required String email,
    required String password,
    bool keepMeSignedIn = false,
  }) async {
    await _saveKeepMeSignedIn(keepMeSignedIn);
    await _authInit(forceReinit: true);

    // If already signed in, sign out first to ensure a clean state and avoid
    // the "already signed in" error from Clerk.
    if (_auth?.session != null) {
      await _auth?.signOut();
    }

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
        // A 422 (Unprocessable Entity) response from the REST sign-in endpoint
        // means the user is already registered via Clerk, so the REST call is
        // semantically invalid - but the Clerk session was already established
        // above, making it safe to continue the sign-in flow.
        if (!e.toString().contains('${HttpStatus.unprocessableEntity}')) {
          rethrow;
        }
      }
    } else {
      await _saveUserId(userId);
    }

    await _saveEmail(trimmedEmail);
    _controller.add(
      AuthenticationStatus.authenticated(userId: userId, email: trimmedEmail),
    );
    return entity.User(id: userId, email: trimmedEmail);
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _authInit();

    final String trimmedEmail = email.trim();
    final String trimmedPassword = password.trim();
    await _auth?.attemptSignUp(
      strategy: clerk.Strategy.password,
      emailAddress: trimmedEmail,
      password: trimmedPassword,
      passwordConfirmation: trimmedPassword,
    );

    // Trigger the email verification code to be sent.
    final clerk.Client? signUpResponse = await _auth?.attemptSignUp(
      strategy: clerk.Strategy.emailCode,
    );
    final String? signUpId = signUpResponse?.signUp?.id;
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
        strategy: clerk.Strategy.emailCode,
        emailAddress: _email,
      );
    } else {
      throw StateError(
        'sendCodeToUser() called without an active sign-up session.',
      );
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
        final String resolvedUserId = userId ?? '';
        await _saveUserId(resolvedUserId);
        _controller.add(
          AuthenticationStatus.authenticated(
            userId: resolvedUserId,
            email: _email,
          ),
        );
        await _removeSignUpId();
      } else {
        _controller.add(AuthenticationStatus.unauthenticated());
        throw const entity.InvestTrackException(
          'Verification succeeded but no user ID was returned.',
        );
      }
    } else {
      throw StateError(
        'verify() called without an active sign-up session.',
      );
    }
  }

  Future<void> signOut() async {
    await _auth?.signOut();
    _auth?.terminate();

    await _removeToken();
    await _removeEmail();
    await _removeUserId();
    await _removeKeepMeSignedIn();
    _controller.add(AuthenticationStatus.unauthenticated());
  }

  void dispose() {
    _auth?.terminate();
    _controller.close();
  }

  bool _checkInitialAuthenticationStatus() {
    final String token = _inMemoryToken ??
        _preferences.getString(entity.StorageKeys.authToken.key) ??
        '';

    // Check if we have a valid session in Clerk as well.
    final bool hasClerkSession = _auth?.session != null;

    return token.isNotEmpty || hasClerkSession;
  }

  Future<bool> _saveToken(String token) {
    if (_keepMeSignedIn) {
      return _preferences.setString(entity.StorageKeys.authToken.key, token);
    } else {
      _inMemoryToken = token;
      return Future<bool>.value(true);
    }
  }

  Future<bool> _saveUserId(String userId) {
    if (_keepMeSignedIn) {
      return _preferences.setString(entity.StorageKeys.userId.key, userId);
    } else {
      _inMemoryUserId = userId;
      return Future<bool>.value(true);
    }
  }

  Future<bool> _saveSignUpId(String id) {
    return _preferences.setString(entity.StorageKeys.signUpId.key, id);
  }

  Future<bool> _saveEmail(String email) {
    if (_keepMeSignedIn) {
      return _preferences.setString(entity.StorageKeys.email.key, email);
    } else {
      _inMemoryEmail = email;
      return Future<bool>.value(true);
    }
  }

  Future<bool> _saveKeepMeSignedIn(bool value) {
    return _preferences.setBool(entity.StorageKeys.keepMeSignedIn.key, value);
  }

  String get _email {
    return _inMemoryEmail ??
        _preferences.getString(entity.StorageKeys.email.key) ??
        '';
  }

  String get userId {
    return _inMemoryUserId ??
        _preferences.getString(entity.StorageKeys.userId.key) ??
        '';
  }

  bool get _keepMeSignedIn {
    return _preferences.getBool(entity.StorageKeys.keepMeSignedIn.key) ?? false;
  }

  Future<bool> _removeToken() {
    _inMemoryToken = null;
    return _preferences.remove(entity.StorageKeys.authToken.key);
  }

  Future<bool> _removeSignUpId() => _preferences.remove(
        entity.StorageKeys.signUpId.key,
      );

  Future<bool> _removeEmail() {
    _inMemoryEmail = null;
    return _preferences.remove(entity.StorageKeys.email.key);
  }

  Future<bool> _removeUserId() {
    _inMemoryUserId = null;
    return _preferences.remove(entity.StorageKeys.userId.key);
  }

  Future<bool> _removeKeepMeSignedIn() =>
      _preferences.remove(entity.StorageKeys.keepMeSignedIn.key);

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

  Future<void> _authInit({bool forceReinit = false}) async {
    if (forceReinit && _auth != null) {
      _auth?.terminate();
      _auth = null;
    }

    if (_auth == null) {
      _auth = clerk.Auth(
        config: clerk.AuthConfig(
          publishableKey: Env.clerkPublishableKey,
          persistor: _keepMeSignedIn
              ? SharedPrefsPersistor(_preferences)
              : Persistor.none,
        ),
      );
      await _auth?.initialize();
    }
  }
}
