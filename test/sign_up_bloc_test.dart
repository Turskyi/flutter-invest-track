import 'package:bloc_test/bloc_test.dart';
import 'package:clerk_auth/clerk_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:models/models.dart';

import 'fakes/fake_throwing_auth_repository.dart';

const String _validEmail = 'test@test.com';
const String _validPassword = 'Password123!';

void main() {
  group('SignUpBloc', () {
    group('ClerkError handling during sign-up submission', () {
      const String serverErrorText = 'That email address is taken';
      const ClerkError clerkError = ClerkError(
        code: ClerkErrorCode.serverErrorResponse,
        message: '{arg} (ERROR RECEIVED FROM SERVER)',
        argument: serverErrorText,
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits SignUpErrorState with formatted message '
        '(not raw {arg} template) when signUp throws ClerkError',
        build: () => SignUpBloc(
          authenticationRepository: FakeThrowingAuthRepository(
            signUpError: clerkError,
          ),
        ),
        seed: () => const SignUpState(
          email: EmailAddress.dirty(_validEmail),
          password: Password.dirty(_validPassword),
          isValid: true,
        ),
        act: (SignUpBloc bloc) => bloc.add(const SignUpSubmitted()),
        expect: () => <Object>[
          isA<SignUpProgressState>(),
          isA<SignUpErrorState>()
              .having(
                (SignUpErrorState s) => s.errorMessage,
                'errorMessage',
                contains(serverErrorText),
              )
              .having(
                (SignUpErrorState s) => s.errorMessage,
                'errorMessage',
                isNot(contains('{arg}')),
              )
              .having(
                (SignUpErrorState s) => s.status,
                'status',
                FormzSubmissionStatus.failure,
              ),
        ],
      );
    });

    group('generic error handling during sign-up submission', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits SignUpErrorState with error description '
        'when signUp throws an unrecognised exception',
        build: () => SignUpBloc(
          authenticationRepository: FakeThrowingAuthRepository(
            signUpError: Exception('Unexpected failure'),
          ),
        ),
        seed: () => const SignUpState(
          email: EmailAddress.dirty(_validEmail),
          password: Password.dirty(_validPassword),
          isValid: true,
        ),
        act: (SignUpBloc bloc) => bloc.add(const SignUpSubmitted()),
        expect: () => <Object>[
          isA<SignUpProgressState>(),
          isA<SignUpErrorState>()
              .having(
                (SignUpErrorState s) => s.errorMessage,
                'errorMessage',
                contains('Unexpected failure'),
              )
              .having(
                (SignUpErrorState s) => s.status,
                'status',
                FormzSubmissionStatus.failure,
              ),
        ],
      );
    });
  });
}
