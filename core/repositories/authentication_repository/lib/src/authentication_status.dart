sealed class AuthenticationStatus {
  const AuthenticationStatus();

  factory AuthenticationStatus.unknown() = UnknownAuthenticationStatus;

  factory AuthenticationStatus.deleting() = DeletingAuthenticatedUserStatus;

  factory AuthenticationStatus.authenticated({
    String userId = '',
    String email = '',
  }) {
    return AuthenticatedStatus(userId: userId, email: email);
  }

  factory AuthenticationStatus.unauthenticated() = UnauthenticatedStatus;

  factory AuthenticationStatus.code(String email) {
    return CodeAuthenticationStatus(email);
  }
}

class UnknownAuthenticationStatus extends AuthenticationStatus {
  const UnknownAuthenticationStatus();
}

class AuthenticatedStatus extends AuthenticationStatus {
  const AuthenticatedStatus({this.userId = '', this.email = ''});

  final String userId;
  final String email;
}

class DeletingAuthenticatedUserStatus extends AuthenticationStatus {
  const DeletingAuthenticatedUserStatus();
}

class UnauthenticatedStatus extends AuthenticationStatus {
  const UnauthenticatedStatus({this.message = ''});

  final String message;
}

class CodeAuthenticationStatus extends AuthenticationStatus {
  const CodeAuthenticationStatus(this.email);

  final String email;
}
