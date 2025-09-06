import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/ui/investments/investment/info_row.dart';
import 'package:investtrack/utils/price_utils.dart';

class PriceChangeWidget extends StatelessWidget {
  const PriceChangeWidget({
    required this.priceChange,
    required this.changePercentage,
    super.key,
  });

  final double priceChange;
  final double changePercentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlocBuilder<InvestmentsBloc, InvestmentsState>(
          buildWhen: _shouldRebuildPriceChange,
          builder: (BuildContext _, InvestmentsState state) {
            return InfoRow(
              label: 'Price Change',
              value:
                  priceChange == 0 &&
                      state is! InvestmentUpdated &&
                      state is! InvestmentError
                  ? 'Loading...'
                  : formatPrice(price: priceChange),
              icon: priceChange >= 0 ? Icons.trending_up : Icons.trending_down,
              valueColor: priceChange >= 0 ? Colors.greenAccent : Colors.red,
            );
          },
        ),
        BlocBuilder<InvestmentsBloc, InvestmentsState>(
          buildWhen: _shouldRebuildPriceChange,
          builder: (BuildContext _, InvestmentsState state) {
            return InfoRow(
              label: 'Change %',
              value:
                  changePercentage == 0 &&
                      state is! InvestmentUpdated &&
                      state is! InvestmentError
                  ? 'Loading...'
                  : '${changePercentage.toStringAsFixed(2)}%',
              icon: changePercentage >= 0
                  ? Icons.trending_up
                  : Icons.trending_down,
              valueColor: changePercentage >= 0
                  ? Colors.greenAccent
                  : Colors.red,
            );
          },
        ),
      ],
    );
  }

  bool _shouldRebuildPriceChange(InvestmentsState _, InvestmentsState current) {
    // Ignore `InvestmentsUpdated` and `InvestmentsError` states. They do
    // not belong to this screen.
    return current is! InvestmentsUpdated && current is! InvestmentsError;
  }
}
