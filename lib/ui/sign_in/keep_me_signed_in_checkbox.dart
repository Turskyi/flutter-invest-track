import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/sign_in/bloc/sign_in_bloc.dart';

class KeepMeSignedInCheckbox extends StatelessWidget {
  const KeepMeSignedInCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: _hasKeepMeSignedInChanged,
      builder: (BuildContext context, SignInState state) {
        return Row(
          children: <Widget>[
            Checkbox(
              value: state.keepMeSignedIn,
              onChanged: (bool? value) {
                context.read<SignInBloc>().add(
                  SignInKeepMeSignedInChanged(value ?? false),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<SignInBloc>().add(
                    SignInKeepMeSignedInChanged(!state.keepMeSignedIn),
                  );
                },
                child: Text(
                  translate('sign_in_form.keep_me_signed_in'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasKeepMeSignedInChanged(SignInState previous, SignInState current) {
    return previous.keepMeSignedIn != current.keepMeSignedIn;
  }
}
