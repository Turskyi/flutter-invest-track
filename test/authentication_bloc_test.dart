import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';
import 'package:user_repository/user_repository.dart';

import 'authentication_bloc_test.mocks.dart';

@GenerateMocks(<Type>[AuthenticationRepository, UserRepository])
void main() {
  group('AuthenticationBloc', () {
    late MockAuthenticationRepository authenticationRepository;
    late MockUserRepository userRepository;
    late StreamController<AuthenticationStatus> controller;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      userRepository = MockUserRepository();
      controller = StreamController<AuthenticationStatus>();
      when(
        authenticationRepository.status,
      ).thenAnswer((Invocation _) => controller.stream);
    });

    tearDown(() {
      controller.close();
    });

    test('initial state is AuthenticationState.unknown()', () {
      final AuthenticationBloc authenticationBloc = AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      );
      expect(authenticationBloc.state, const AuthenticationState.unknown());
      authenticationBloc.close();
    });

    group('AuthenticationSubscriptionRequested', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [unauthenticated] when status is unauthenticated',
        build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (AuthenticationBloc bloc) {
          bloc.add(const AuthenticationSubscriptionRequested());
          controller.add(const UnauthenticatedStatus());
        },
        expect: () => <AuthenticationState>[
          const AuthenticationState.unauthenticated(),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [authenticated] when status is authenticated (REGRESSION TEST)',
        build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        setUp: () {
          // Simulate UserRepository returning anonymous user (not yet
          // persisted)
          when(userRepository.getUser()).thenReturn(User.anonymous);
        },
        act: (AuthenticationBloc bloc) {
          bloc.add(const AuthenticationSubscriptionRequested());
          controller.add(
            const AuthenticatedStatus(
              userId: 'user-123',
              email: 'test@test.com',
            ),
          );
        },
        expect: () => <AuthenticationState>[
          const AuthenticationState.authenticated(
            User(id: 'user-123', email: 'test@test.com'),
          ),
        ],
        verify: (_) {
          // Verify that we are NOT relying on userRepository.getUser()
          // for AuthenticatedStatus anymore.
          verifyNever(userRepository.getUser());
        },
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [unauthenticated] when status is authenticated but user is '
        'anonymous',
        build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (AuthenticationBloc bloc) {
          bloc.add(const AuthenticationSubscriptionRequested());
          controller.add(const AuthenticatedStatus()); // default anonymous
        },
        expect: () => <AuthenticationState>[
          const AuthenticationState.unauthenticated(),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [code] when status is code',
        build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (AuthenticationBloc bloc) {
          bloc.add(const AuthenticationSubscriptionRequested());
          controller.add(const CodeAuthenticationStatus('test@test.com'));
        },
        expect: () => <Object>[
          isA<AuthenticationState>().having(
            (AuthenticationState s) => s.status,
            'status',
            isA<CodeAuthenticationStatus>().having(
              (CodeAuthenticationStatus cs) => cs.email,
              'email',
              'test@test.com',
            ),
          ),
        ],
      );
    });

    group('AuthenticationSignOutPressed', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'calls signOut on authenticationRepository',
        build: () => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (AuthenticationBloc bloc) =>
            bloc.add(const AuthenticationSignOutPressed()),
        verify: (_) {
          verify(authenticationRepository.signOut()).called(1);
        },
      );
    });
  });
}
