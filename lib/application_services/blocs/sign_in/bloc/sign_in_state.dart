part of 'sign_in_bloc.dart';

/// The [EmailAddress] and [Password] models are used as part of the
/// [SignInState] and the status is also part of `package:formz`.
final class SignInState extends Equatable {
  const SignInState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const EmailAddress.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.keepMeSignedIn = false,
  });

  final FormzSubmissionStatus status;
  final EmailAddress email;
  final Password password;
  final bool isValid;
  final bool keepMeSignedIn;

  SignInState copyWith({
    FormzSubmissionStatus? status,
    EmailAddress? email,
    Password? password,
    bool? isValid,
    bool? keepMeSignedIn,
  }) => SignInState(
    status: status ?? this.status,
    email: email ?? this.email,
    password: password ?? this.password,
    isValid: isValid ?? this.isValid,
    keepMeSignedIn: keepMeSignedIn ?? this.keepMeSignedIn,
  );

  @override
  List<Object> get props => <Object>[status, email, password, keepMeSignedIn];
}

final class SignInErrorState extends SignInState {
  const SignInErrorState({
    super.status,
    super.email,
    super.password,
    super.isValid,
    super.keepMeSignedIn,
    this.errorMessage = 'Authentication Failure',
  });

  final String errorMessage;

  @override
  SignInErrorState copyWith({
    FormzSubmissionStatus? status,
    EmailAddress? email,
    Password? password,
    bool? isValid,
    bool? keepMeSignedIn,
    String? errorMessage,
  }) => SignInErrorState(
    status: status ?? this.status,
    email: email ?? this.email,
    password: password ?? this.password,
    isValid: isValid ?? this.isValid,
    keepMeSignedIn: keepMeSignedIn ?? this.keepMeSignedIn,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object> get props => <Object>[
    status,
    email,
    password,
    isValid,
    keepMeSignedIn,
    errorMessage,
  ];
}
