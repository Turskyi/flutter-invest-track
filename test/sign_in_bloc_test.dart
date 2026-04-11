import 'package:bloc_test/bloc_test.dart';
import 'package:clerk_auth/clerk_auth.dart' show ClerkError, ClerkErrorCode;
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:investtrack/application_services/blocs/sign_in/bloc/sign_in_bloc.dart';
import 'package:models/models.dart';

import 'fakes/fake_throwing_auth_repository.dart';

const String _validEmail = 'test@test.com';
const String _validPassword = 'Password123!';

void main() {
  group('SignInBloc', () {
    group('ClerkError handling during sign-in submission', () {
      const String serverErrorText = 'Invalid credentials';
      const ClerkError clerkError = ClerkError(
        code: ClerkErrorCode.serverErrorResponse,
        message: '{arg} (ERROR RECEIVED FROM SERVER)',
        argument: serverErrorText,
      );

      blocTest<SignInBloc, SignInState>(
        'emits SignInErrorState with formatted message '
        '(not raw {arg} template) when signIn throws ClerkError',
        build: () => SignInBloc(
          authenticationRepository: FakeThrowingAuthRepository(
            signInError: clerkError,
          ),
        ),
        seed: () => const SignInState(
          email: EmailAddress.dirty(_validEmail),
          password: Password.dirty(_validPassword),
          isValid: true,
        ),
        act: (SignInBloc bloc) => bloc.add(const SignInSubmitted()),
        expect: () => <Object>[
          isA<SignInState>().having(
            (SignInState s) => s.status,
            'status',
            FormzSubmissionStatus.inProgress,
          ),
          isA<SignInErrorState>()
              .having(
                (SignInErrorState s) => s.errorMessage,
                'errorMessage',
                contains(serverErrorText),
              )
              .having(
                (SignInErrorState s) => s.errorMessage,
                'errorMessage',
                isNot(contains('{arg}')),
              )
              .having(
                (SignInErrorState s) => s.status,
                'status',
                FormzSubmissionStatus.failure,
              ),
        ],
      );
    });
  });
}
