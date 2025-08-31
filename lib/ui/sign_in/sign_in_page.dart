import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/sign_in/bloc/sign_in_bloc.dart';
import 'package:investtrack/ui/sign_in/sign_in_form.dart';

/// The [SignInPage] is responsible for exposing the `Route` as well as
/// creating and providing the [SignInBloc] to the [SignInForm].
/// `RepositoryProvider.of<AuthenticationRepository>(context)` is used to
/// lookup the instance of [AuthenticationRepository] via the `BuildContext`.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static Route<void> route() {
    return PageRouteBuilder<Widget>(
      pageBuilder: (BuildContext _, Animation<double> _, Animation<double> _) {
        return const SignInPage();
      },
      transitionsBuilder:
          (
            _,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(opacity: animation, child: child);
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignInBloc>(
        create: (BuildContext context) => SignInBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: const SignInForm(),
      ),
    );
  }
}
