import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/res/constants/hero_tags.dart' as hero_tags;
import 'package:investtrack/res/constants/types.dart' as types;
import 'package:investtrack/router/slide_page_route.dart';
import 'package:investtrack/ui/investments/investment/investment_page.dart';
import 'package:investtrack/ui/investments/investment_tile/custom_badge.dart';
import 'package:investtrack/ui/investments/investment_tile/investment_detail.dart';
import 'package:investtrack/utils/price_utils.dart';
import 'package:models/models.dart';

class InvestmentCard extends StatelessWidget {
  const InvestmentCard({required this.investment, super.key});

  final Investment investment;

  @override
  Widget build(BuildContext context) {
    final String purchaseDateTimestamp =
        investment.purchaseDate?.toLocal().toString().split(' ').firstOrNull ??
        '';
    final int quantity = investment.quantity;
    final ThemeData themeData = Theme.of(context);
    final double? currentPrice = investment.currentPrice;
    final double? purchasePrice = investment.purchasePrice;
    final double? gainOrLoss = investment.gainOrLossUsd;
    final double totalValuePurchase = quantity * (purchasePrice ?? 0);
    final double gainOrLossPercentage = totalValuePurchase != 0
        ? ((gainOrLoss ?? 0) / totalValuePurchase) * 100
        : 0;
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.all(8.0),
      shadowColor: Colors.blueGrey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade700, width: 0.5),
      ),
      color: themeData.colorScheme.surface.withOpacity(0.6),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () => _navigateToInvestmentDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: '${hero_tags.companyLogo}${investment.id}',
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: investment.companyLogoUrl.isNotEmpty
                          ? NetworkImage(investment.companyLogoUrl)
                          : const AssetImage(
                              '${constants.imagePath}'
                              'company-logo-placeholder.jpeg',
                            ),
                      radius: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              investment.ticker,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Add type badge with color.
                            CustomBadge(
                              // Use the color mapping.
                              backgroundColor:
                                  types.investmentTypeColors[investment.type] ??
                                  Colors.grey,
                              child: Text(
                                investment.type,
                                style: TextStyle(
                                  // Adjust size for the badge.
                                  fontSize:
                                      themeData.textTheme.labelMedium?.fontSize,
                                  fontWeight: FontWeight.bold,
                                  // Ensure text color contrasts well.
                                  color: themeData.colorScheme.onBackground,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          investment.companyName,
                          style: themeData.textTheme.headlineMedium?.copyWith(
                            color: themeData.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              if (quantity > 0)
                InvestmentDetail(
                  label: 'Purchase Price (USD)',
                  value: formatPrice(price: purchasePrice),
                  icon: Icons.money,
                ),
              if (quantity > 0)
                InvestmentDetail(
                  label: 'Gain/Loss (USD)',
                  value:
                      '${formatPrice(price: gainOrLoss)} '
                      '(${gainOrLossPercentage.toStringAsFixed(2)}%)',
                  icon: gainOrLoss != null
                      ? gainOrLoss >= 0
                            ? Icons.trending_up
                            : Icons.trending_down
                      : Icons.question_mark,
                  valueColor: gainOrLoss != null
                      ? gainOrLoss >= 0
                            ? Colors.green
                            : Colors.red
                      : Colors.grey,
                ),
              InvestmentDetail(
                label: 'Current Price (USD)',
                value: formatPrice(price: currentPrice),
                icon: Icons.monetization_on,
              ),
              if (quantity > 0)
                InvestmentDetail(
                  label: 'Quantity',
                  value: quantity.toString(),
                  icon: Icons.pie_chart,
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      purchaseDateTimestamp.isNotEmpty && quantity > 0
                          ? 'Purchased: $purchaseDateTimestamp'
                          : 'Not yet purchased',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: themeData.iconTheme.color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToInvestmentDetails(BuildContext context) {
    Navigator.of(context).push(
      SlidePageRoute<bool?>(
        page: BlocProvider<InvestmentsBloc>.value(
          value: context.read<InvestmentsBloc>()
            ..add(LoadInvestment(investment)),
          child: const InvestmentPage(),
        ),
      ),
    );
  }
}
