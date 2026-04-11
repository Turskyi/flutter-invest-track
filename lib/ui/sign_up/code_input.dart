import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/sign_up/bloc/sign_up_bloc.dart';

class CodeInput extends StatefulWidget {
  const CodeInput({super.key});

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  static const int _codeLength = 6;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  Widget build(BuildContext context) {
    final String code = context.select(
      (SignUpBloc bloc) => bloc.state.code.value,
    );
    final bool hasCodeError =
        context.select((SignUpBloc bloc) => bloc.state.code.displayError) !=
        null;

    if (_controller.text != code) {
      _controller.value = TextEditingValue(
        text: code,
        selection: TextSelection.collapsed(offset: code.length),
      );
    }

    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(_codeLength, (int index) {
                  final bool isActive =
                      _focusNode.hasFocus &&
                      ((code.length < _codeLength && index == code.length) ||
                          (code.length == _codeLength &&
                              index == _codeLength - 1));

                  return Container(
                    key: Key('codeInput_box_$index'),
                    width: 48,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasCodeError
                            ? theme.colorScheme.error
                            : isActive
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                        width: isActive ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      index < code.length ? code[index] : '',
                      style: theme.textTheme.titleLarge,
                    ),
                  );
                }),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  width: 1,
                  height: 1,
                  child: Opacity(
                    opacity: 0,
                    child: TextField(
                      key: const Key('codeInput_textField'),
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      enableInteractiveSelection: false,
                      autofillHints: const <String>[AutofillHints.oneTimeCode],
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(_codeLength),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                      ),
                      onChanged: (String value) {
                        context.read<SignUpBloc>().add(CodeChanged(value));
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasCodeError) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              'Invalid code',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
