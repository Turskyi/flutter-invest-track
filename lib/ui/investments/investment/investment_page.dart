import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/investments/investment/investment_details_page.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvestmentsBloc, InvestmentsState>(
      listener: (BuildContext context, InvestmentsState state) {
        if (state is InvestmentDeleted) {
          Navigator.pushReplacementNamed(
            context,
            AppRoute.investments.name,
          );
        }
      },
      builder: (BuildContext context, InvestmentsState state) {
        if (state is SelectedInvestmentState) {
          return InvestmentDetailsPage(investment: state.selectedInvestment);
        } else if(state is InvestmentSubmitted){
          return InvestmentDetailsPage(investment: state.investment);
        } else {
          // Fancy loading placeholder.
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.insert_chart, size: 50, color: Colors.blueAccent),
                  SizedBox(height: 20),
                  Text(
                    'Loading investment details...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
