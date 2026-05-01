import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';

class SignUpEmailInput extends StatefulWidget {
  const SignUpEmailInput({required this.initialValue, super.key});

  final String initialValue;

  @override
  State<SignUpEmailInput> createState() => _SignUpEmailInputState();
}

class _SignUpEmailInputState extends State<SignUpEmailInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.initialValue;
    context.read<SignUpBloc>().add(SignUpEmailChanged(widget.initialValue));
  }

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final EmailValidationError? displayError = context.select(
      (SignUpBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('signUpForm_emailInput_textField'),
      controller: _textEditingController,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(constants.emailMaxLength),
      ],
      onChanged: _onEmailChanged,
      decoration: InputDecoration(
        errorText: displayError != null
            ? translate('sign_in_form.invalid_email')
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String email) {
    return context.read<SignUpBloc>().add(SignUpEmailChanged(email));
  }
}
