import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:formz/formz.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/ui/sign_up/code_continue_button.dart';
import 'package:investtrack/ui/sign_up/sign_up_page.dart';
import 'package:investtrack/ui/widgets/input_field.dart';

class CodeForm extends StatelessWidget {
  const CodeForm({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double? titleFontSize = textTheme.titleMedium?.fontSize;
    final double? headlineFontSize = textTheme.headlineSmall?.fontSize;
    return BlocListener<SignUpBloc, SignUpState>(
      listener: _signUpStateListener,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: constants.maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  translate('code_form.title'),
                  style: TextStyle(
                    fontSize: headlineFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  translate('code_form.subtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: titleFontSize),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil<void>(
                          SignUpPage.route(email: email),
                          (Route<void> route) => false,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                InputField(
                  label: translate('code_form.input_label'),
                  icon: Icons.numbers,
                  child: BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (BuildContext context, SignUpState state) {
                      return TextField(
                        key: const Key('codeForm_code_textField'),
                        onChanged: (String value) =>
                            context.read<SignUpBloc>().add(CodeChanged(value)),
                        keyboardType: TextInputType.number,
                        autofillHints: const <String>[
                          AutofillHints.oneTimeCode,
                        ],
                        decoration: InputDecoration(
                          errorText: state.code.displayError != null
                              ? translate('code_form.invalid_code')
                              : null,
                          hintText: '000000',
                        ),
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                Text(translate('code_form.no_code_prompt')),
                const SizedBox(height: 8),
                BlocBuilder<SignUpBloc, SignUpState>(
                  builder: (BuildContext context, SignUpState state) {
                    final bool isLoading = state is SignUpProgressState;

                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<SignUpBloc>().add(
                                const ResendCode(),
                              );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(translate('code_form.resend_button')),
                    );
                  },
                ),
                const Padding(padding: EdgeInsets.all(24)),
                const CodeContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUpStateListener(BuildContext context, SignUpState state) {
    final FormzSubmissionStatus status = state.status;
    if (status.isFailure || state is SignUpErrorState) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              state is SignUpErrorState
                  ? state.errorMessage
                  : translate('sign_up_form.error_sign_up_failure'),
            ),
          ),
        );
    }
  }
}
