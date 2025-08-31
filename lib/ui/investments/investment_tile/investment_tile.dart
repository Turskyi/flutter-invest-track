import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/ui/investments/investment_tile/investment_card.dart';
import 'package:models/models.dart';

class InvestmentTile extends StatelessWidget {
  const InvestmentTile({required this.investment, super.key});

  final Investment investment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InvestmentCard(investment: investment),
        BlocBuilder<InvestmentsBloc, InvestmentsState>(
          builder: (_, InvestmentsState state) {
            if (state is SubmittingInvestment &&
                state.investmentId == investment.id) {
              return Positioned.fill(
                child: Card(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
