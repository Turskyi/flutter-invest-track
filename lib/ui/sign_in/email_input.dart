import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/sign_in/bloc/sign_in_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final EmailValidationError? displayError = context.select(
      (SignInBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('signInForm_emailInput_textField'),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(constants.emailMaxLength),
      ],
      onChanged: (String email) {
        _onEmailChanged(context, email);
      },
      decoration: InputDecoration(
        labelText: translate('sign_in_form.email_label'),
        errorText: displayError != null
            ? translate('sign_in_form.invalid_email')
            : null,
      ),
    );
  }

  void _onEmailChanged(BuildContext context, String email) {
    return context.read<SignInBloc>().add(SignInEmailChanged(email));
  }
}
