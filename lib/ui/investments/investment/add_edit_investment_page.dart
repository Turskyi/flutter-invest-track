import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/res/constants/currency_list.dart' as list;
import 'package:investtrack/res/constants/types.dart' as types;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/investments/investment/date_picker.dart';
import 'package:investtrack/ui/investments/investment/dropdown_field.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/gradient_background_scaffold.dart';
import 'package:investtrack/ui/widgets/labeled_text_field.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class AddEditInvestmentPage extends StatefulWidget {
  const AddEditInvestmentPage({super.key, this.investment});

  final Investment? investment;

  @override
  State<AddEditInvestmentPage> createState() => _AddEditInvestmentPageState();
}

class _AddEditInvestmentPageState extends State<AddEditInvestmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _tickerController;
  late TextEditingController _companyNameController;
  late TextEditingController _companyLogoUrlController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  final ValueNotifier<bool> _formStateChangedNotifier = ValueNotifier<bool>(
    false,
  );
  DateTime? _purchaseDate;
  String? _investmentType;
  String? _stockExchange;
  String? _currency;

  @override
  void initState() {
    super.initState();
    _tickerController =
        TextEditingController(text: widget.investment?.ticker ?? '')
          ..addListener(() {
            _formStateChangedNotifier.value = !_formStateChangedNotifier.value;
          });

    _companyNameController = TextEditingController(
      text: widget.investment?.companyName ?? '',
    );
    _companyLogoUrlController = TextEditingController(
      text: widget.investment?.companyLogoUrl ?? '',
    );

    _quantityController =
        TextEditingController(
          text: widget.investment?.quantity.toString() ?? '',
        )..addListener(() {
          _formStateChangedNotifier.value = !_formStateChangedNotifier.value;
        });

    _descriptionController = TextEditingController(
      text: widget.investment?.description ?? '',
    );
    _purchaseDate = widget.investment?.purchaseDate;
    _investmentType = widget.investment?.type;
    _stockExchange = widget.investment?.stockExchange;
    _currency = widget.investment?.currency;
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundScaffold(
      appBar: BlurredAppBar(
        title: Text(
          widget.investment == null ? 'Add Investment' : 'Edit Investment',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 120,
          right: 16,
          bottom: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LabeledTextField(
                controller: _tickerController,
                label: 'Ticker Symbol (Stock name)',
                hint: 'e.g. GOOG',
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                controller: _companyNameController,
                label: 'Company Name',
                hint: 'e.g. Alphabet Inc Class C',
                validator: (String? value) => value == null || value.isEmpty
                    ? 'Please enter company name'
                    : null,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                controller: _companyLogoUrlController,
                label: 'Company Logo URL',
                hint: 'Enter direct image URL.',
                validator: _validateImageUrl,
              ),
              const SizedBox(height: 16),
              DropdownField(
                label: 'Investment Type',
                value: _investmentType,
                items: types.investmentTypes,
                onChanged: (String? value) =>
                    setState(() => _investmentType = value),
                validator: (String? value) => value == null || value.isEmpty
                    ? 'Please select Investment Type'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownField(
                label: 'Stock Exchange',
                value: _stockExchange,
                items: types.stockExchangeTypes,
                onChanged: (String? value) =>
                    setState(() => _stockExchange = value),
              ),
              const SizedBox(height: 16),
              DropdownField(
                label: 'Currency',
                value: _currency,
                items: list.currencies
                    .map((Currency currency) => currency.alphabeticCode)
                    .toList(),
                onChanged: (String? value) => setState(() => _currency = value),
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                controller: _quantityController,
                label: 'Quantity',
                hint: 'e.g. 100',
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    // Allow empty input
                    return null;
                  }
                  final int? number = int.tryParse(value);
                  if (number == null || number < 0) {
                    return 'Please enter a valid positive number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _quantityController,
                builder: (BuildContext _, TextEditingValue value, Widget? _) {
                  final String text = value.text;
                  final int? quantity = int.tryParse(text);
                  final bool isQuantityValid =
                      text.isNotEmpty && quantity != null && quantity > 0;

                  return Column(
                    children: <Widget>[
                      if (isQuantityValid)
                        DatePicker(
                          label: 'Purchase Date and Time',
                          selectedDate: _purchaseDate,
                          onChanged: (DateTime? value) =>
                              setState(() => _purchaseDate = value),
                        ),
                      if (isQuantityValid &&
                          (_purchaseDate == null ||
                              _purchaseDate!.isAfter(DateTime.now())))
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _purchaseDate == null
                                ? 'Please select a purchase date'
                                : 'Purchase date cannot be in the future',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter a description',
                maxLines: 5,
                validator: (_) {
                  // Allow empty input.
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (widget.investment != null)
                    BlocBuilder<InvestmentsBloc, InvestmentsState>(
                      builder: (_, InvestmentsState state) {
                        return TextButton(
                          onPressed: state is InvestmentDeleting
                              ? null
                              : _deleteInvestment,
                          child: state is InvestmentDeleting
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Delete investment',
                                  style: TextStyle(color: Colors.red),
                                ),
                        );
                      },
                    ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _formStateChangedNotifier,
                    child: const Text('Submit'),
                    builder: (BuildContext _, bool _, Widget? submitText) {
                      return BlocConsumer<InvestmentsBloc, InvestmentsState>(
                        listener: _investmentsStateListener,
                        builder: (_, InvestmentsState state) {
                          final bool isSubmitting =
                              state is UpdatingInvestment ||
                              state is CreatingInvestment;

                          const double progressIndicatorSize = 24.0;

                          final String tickerValue = _tickerController.text;
                          final int? quantity = int.tryParse(
                            _quantityController.text,
                          );
                          final bool isQuantityValid =
                              quantity != null && quantity > 0;
                          final bool isPurchaseDateValid =
                              _purchaseDate != null &&
                              _purchaseDate!.isBefore(DateTime.now());

                          final bool isFormValid =
                              tickerValue.isNotEmpty &&
                              (!isQuantityValid || isPurchaseDateValid);

                          return ElevatedButton(
                            onPressed: (isSubmitting || !isFormValid)
                                ? null
                                : _submit,
                            child: isSubmitting
                                ? const SizedBox(
                                    width: progressIndicatorSize,
                                    height: progressIndicatorSize,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                  )
                                : submitText,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tickerController.dispose();
    _companyNameController.dispose();
    _companyLogoUrlController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _formStateChangedNotifier.dispose();
    super.dispose();
  }

  void _investmentsStateListener(BuildContext context, InvestmentsState state) {
    if (state is InvestmentSubmitted) {
      if (widget.investment != null) {
        context.read<InvestmentsBloc>().add(LoadInvestment(state.investment));
      }

      // Close the screen.
      Navigator.of(context).pop(true);
    } else if (state is InvestmentsError) {
      // Show a snackbar with the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } else if (state is InvestmentError) {
      final String errorMessage = state.errorMessage;

      // Check if the error message indicates an invalid
      // ticker.
      if (errorMessage.contains('Unable to fetch historical data') &&
          errorMessage.contains('ticker:')) {
        // Show a modal dialog instead of a snackbar.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Ticker'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'It looks like the input you entered '
                    'is invalid. The issue could be with '
                    'the ticker or the date.',
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      const String url =
                          'https://finance.yahoo.com/markets/stocks';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Text(
                      'Find valid tickers here',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please note: This link will open a '
                    'browser and is not part of the app.',
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Otherwise, show the error message as a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } else if (state is InvestmentDeleted) {
      Navigator.pushReplacementNamed(context, AppRoute.investments.path);
    }
  }

  Future<void> _submit() async {
    final FormState? formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      final Investment? investment = widget.investment;
      if (investment != null) {
        context.read<InvestmentsBloc>().add(
          UpdateInvestmentEvent(
            investment.copyWith(
              ticker: _tickerController.text,
              companyName: _companyNameController.text,
              companyLogoUrl: _companyLogoUrlController.text,
              type: _investmentType ?? '',
              stockExchange: _stockExchange ?? '',
              currency: _currency ?? '',
              quantity: int.tryParse(_quantityController.text),
              purchaseDate: _purchaseDate,
              description: _descriptionController.text,
            ),
          ),
        );
      } else {
        // Collect form data and create the investment object.
        final Investment newInvestment = Investment.base(
          ticker: _tickerController.text,
          companyName: _companyNameController.text,
          companyLogoUrl: _companyLogoUrlController.text,
          type: _investmentType ?? '',
          stockExchange: _stockExchange ?? '',
          currency: _currency ?? '',
          quantity: int.tryParse(_quantityController.text) ?? 0,
          purchaseDate: _purchaseDate,
          description: _descriptionController.text,
        );

        // Dispatch the event to create the investment.
        context.read<InvestmentsBloc>().add(
          CreateInvestmentEvent(investment: newInvestment),
        );
      }
    } else {
      // Handle invalid form case.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all required fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteInvestment() async {
    final Investment? investment = widget.investment;
    if (investment == null) return;
    context.read<InvestmentsBloc>().add(DeleteInvestmentEvent(investment));
  }

  String? _validateImageUrl(String? value) {
    // Check if the value is null or empty (optional).
    if (value == null || value.isEmpty) {
      // Allow empty input.
      return null;
    }

    // Regular expression to match valid image URLs.
    final String validUrlPattern = r'^(https://).*\.(png|jpe?g|webp)$';
    final RegExp regExp = RegExp(validUrlPattern, caseSensitive: false);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid image URL ending with one of the following '
          'extensions: .png, .jpg, .jpeg, .webp. You can also leave this field '
          'empty if no image is provided.';
    }
    // URL is valid.
    return null;
  }
}
