import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:investtrack/application_services/blocs/sign_in/bloc/sign_in_bloc.dart';

/// The [ContinueButton] widget is only enabled if the status of the form is
/// valid and a [CircularProgressIndicator] is shown in its place while the
/// form is being submitted.
class ContinueButton extends StatelessWidget {
  const ContinueButton({required this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isInProgressOrSuccess = context.select(
      (SignInBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) return const CircularProgressIndicator();

    final bool isValid =
        context.select((SignInBloc bloc) => bloc.state.isValid);

    return ElevatedButton(
      key: const Key('signInForm_continue_raisedButton'),
      onPressed: isValid ? onPressed : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 15,
        ),
      ),
      child: const Text('Continue'),
    );
  }
}
