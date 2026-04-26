import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:models/models.dart';

/// A minimal [AuthenticationRepository] fake that throws pre-configured errors
/// when [signUp] or [signIn] is called. Every other method throws
/// [UnimplementedError] via [Fake].
class FakeThrowingAuthRepository implements AuthenticationRepository {
  FakeThrowingAuthRepository({this.signUpError, this.signInError});

  /// If non-null, [signUp] will throw this object.
  final Object? signUpError;

  /// If non-null, [signIn] will throw this object.
  final Object? signInError;

  @override
  Future<void> signUp({required String email, required String password}) async {
    if (signUpError != null) {
      // ignore: only_throw_errors
      throw signUpError!;
    }
  }

  @override
  Future<User> signIn({
    required String email,
    required String password,
    bool keepMeSignedIn = false,
  }) async {
    if (signInError != null) {
      // ignore: only_throw_errors
      throw signInError!;
    }
    return const User(id: 'fake-id', email: 'fake@test.com');
  }

  @override
  Stream<AuthenticationStatus> get status =>
      Stream<AuthenticationStatus>.value(const UnauthenticatedStatus());

  @override
  bool canSendCode() => false;

  @override
  String get userId => 'fake-id';

  @override
  Future<MessageResponse> deleteAccount(String userId) =>
      throw UnimplementedError();

  @override
  void dispose() {}

  @override
  Future<void> sendCodeToUser() => throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> verify(String code) => throw UnimplementedError();
}
