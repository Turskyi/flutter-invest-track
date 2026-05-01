import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/sign_up/code_form.dart';
import 'package:investtrack/ui/widgets/public_theme_wrapper.dart';

class CodePage extends StatelessWidget {
  const CodePage({required this.email, super.key});

  final String email;

  static Route<void> route({required String email}) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: AppRoute.code.path),
      builder: (BuildContext _) {
        return PublicThemeWrapper(child: CodePage(email: email));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocProvider<SignUpBloc>(
            create: (BuildContext context) => SignUpBloc(
              authenticationRepository: context
                  .read<AuthenticationRepository>(),
            ),
            child: CodeForm(email: email),
          ),
        ),
      ),
    );
  }
}
