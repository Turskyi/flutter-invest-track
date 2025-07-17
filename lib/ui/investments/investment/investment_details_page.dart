import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/res/constants/hero_tags.dart' as hero_tags;
import 'package:investtrack/router/slide_page_route.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investment/info_row.dart';
import 'package:investtrack/ui/investments/investment/markdown_widget.dart';
import 'package:investtrack/ui/investments/investment/price_change_widget.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/gradient_background_scaffold.dart';
import 'package:investtrack/utils/price_utils.dart';
import 'package:models/models.dart';

class InvestmentDetailsPage extends StatefulWidget {
  const InvestmentDetailsPage({required this.investment, super.key});

  final Investment investment;

  @override
  State<InvestmentDetailsPage> createState() => _InvestmentDetailsPageState();
}

class _InvestmentDetailsPageState extends State<InvestmentDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvestmentsBloc, InvestmentsState>(
      listener: (
        BuildContext context,
        InvestmentsState state,
      ) {
        if (state is InvestmentsError) {
          // Show a snackbar with the error message.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is InvestmentDeleted) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (BuildContext context, InvestmentsState state) {
        final Investment investment = widget.investment;
        final int quantity = investment.quantity;
        double totalValueCurrent = 0;

        double currentPrice = 0;
        if (state is CurrentValueLoaded) {
          currentPrice = state.currentPrice;
        } else if (state is InvestmentUpdated) {
          currentPrice = state.currentPrice;
        }

        double exchangeRate = 1;
        if (state is ExchangeRateLoaded) {
          exchangeRate = state.exchangeRate;
        }

        double totalValuePurchase = 0;
        if (state is InvestmentUpdated &&
            state.purchasePrice != null &&
            state.exchangeRate != null) {
          final double purchasePrice = state.purchasePrice!;
          final double stateExchangeRate = state.exchangeRate!;

          totalValuePurchase = quantity * purchasePrice;
          currentPrice = state.currentPrice;
          totalValueCurrent = quantity * state.currentPrice;
          exchangeRate = stateExchangeRate;
        }

        final double totalValueCad = totalValueCurrent * exchangeRate;
        final double totalValuePurchaseCad = totalValuePurchase * exchangeRate;
        final double gainOrLoss = totalValueCurrent - totalValuePurchase;
        final double gainOrLossCad = totalValueCad - totalValuePurchaseCad;
        final double gainOrLossPercentage = totalValuePurchase != 0
            ? (gainOrLoss / totalValuePurchase) * 100
            : 0;

        final double gainOrLossPercentageCad = totalValuePurchaseCad != 0
            ? (gainOrLossCad / totalValuePurchaseCad) * 100
            : 0;
        final String currency = investment.currency;
        final bool isPurchased = investment.isPurchased;
        return GradientBackgroundScaffold(
          appBar: BlurredAppBar(
            title: Text(
              investment.ticker,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              if (state is ValueLoadingState)
                const CircularProgressIndicator()
              else
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editInvestment(investment),
                ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: state is InvestmentDeleting
                    ? null
                    : () => _deleteInvestment(investment),
              ),
            ],
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 112,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (investment.companyLogoUrl.isNotEmpty)
                        Hero(
                          tag: '${hero_tags.companyLogo}${investment.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: ColoredBox(
                              color: Colors.white,
                              child: Image.network(
                                investment.companyLogoUrl,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(investment.companyName),
                          Text(investment.type),
                          Text(investment.stockExchange),
                          Text(currency),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state is ValueLoadingState)
                    const CircularProgressIndicator()
                  else
                    InfoRow(
                      label: 'Current Price (USD)',
                      value: formatPrice(price: currentPrice),
                      icon: Icons.monetization_on,
                    ),
                  if (isPurchased)
                    InfoRow(
                      label: 'Quantity',
                      value: investment.quantity.toString(),
                      icon: Icons.confirmation_number,
                    ),
                  if (state is ValueLoadingState)
                    const CircularProgressIndicator()
                  else if (isPurchased)
                    InfoRow(
                      label: 'Total Value (Current USD)',
                      value: totalValueCurrent.toStringAsFixed(2),
                      icon: Icons.attach_money,
                    ),
                  if (state is ValueLoadingState)
                    const CircularProgressIndicator()
                  else if (isPurchased)
                    InfoRow(
                      label: 'Total Value (Current CAD)',
                      value: totalValueCad.toStringAsFixed(2),
                      icon: Icons.currency_exchange_sharp,
                    ),
                  if (isPurchased)
                    InfoRow(
                      label: 'Purchase Date',
                      value: investment.purchaseDate
                              ?.toIso8601String()
                              .split('T')
                              .firstOrNull ??
                          '',
                      icon: Icons.calendar_today,
                    ),
                  if (state is InvestmentUpdated && state.purchasePrice != null)
                    InfoRow(
                      label: 'Purchase Price',
                      value: state.purchasePrice!.toStringAsFixed(2),
                      icon: Icons.price_check,
                    )
                  else if (isPurchased)
                    const CircularProgressIndicator(),
                  if (isPurchased)
                    InfoRow(
                      label: 'Total Value (Purchase USD)',
                      value: totalValuePurchase.toStringAsFixed(2),
                      icon: Icons.money,
                    ),
                  if (isPurchased)
                    InfoRow(
                      label: 'Total Value (Purchase CAD)',
                      value: totalValuePurchaseCad.toStringAsFixed(2),
                      icon: Icons.money_rounded,
                    ),
                  if (state is InvestmentUpdated && isPurchased)
                    InfoRow(
                      label: 'Gain/Loss (USD)',
                      value: '${formatPrice(
                        price: gainOrLoss,
                      )} '
                          '(${gainOrLossPercentage.toStringAsFixed(2)}%)',
                      icon: gainOrLoss >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      valueColor:
                          gainOrLoss >= 0 ? Colors.greenAccent : Colors.red,
                    )
                  else if (isPurchased)
                    const CircularProgressIndicator(),
                  if (state is InvestmentUpdated && isPurchased)
                    InfoRow(
                      label: 'Gain/Loss CAD',
                      value: '${gainOrLossCad.toStringAsFixed(2)} '
                          '(${gainOrLossPercentageCad.toStringAsFixed(2)}'
                          '%)',
                      icon: gainOrLossCad >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      valueColor:
                          gainOrLossCad >= 0 ? Colors.greenAccent : Colors.red,
                    )
                  else if (isPurchased)
                    const CircularProgressIndicator(),
                  if (state is InvestmentUpdated)
                    PriceChangeWidget(
                      priceChange: state.priceChange,
                      changePercentage: state.changePercentage,
                    )
                  else
                    const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  if (investment.description.isNotEmpty)
                    MarkdownWidget(content: investment.description),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool?> _editInvestment(Investment investment) {
    return Navigator.of(context).push<bool?>(
      SlidePageRoute<bool?>(
        page: BlocProvider<InvestmentsBloc>.value(
          value: context.read<InvestmentsBloc>(),
          child: AddEditInvestmentPage(investment: investment),
        ),
      ),
    );
  }

  void _deleteInvestment(Investment investment) {
    context.read<InvestmentsBloc>().add(DeleteInvestmentEvent(investment));
  }
}
