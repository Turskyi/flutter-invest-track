import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/ui/investments/investment/investment_details_page.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/gradient_background_scaffold.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvestmentsBloc, InvestmentsState>(
      listener: _handleInvestmentStateChanges,
      buildWhen: _shouldRebuildForState,
      builder: (BuildContext _, InvestmentsState state) {
        if (state is SelectedInvestmentState) {
          // This condition handles `SelectedInvestmentState` and its subtypes,
          // such as `InvestmentUpdated` and `CurrentValueLoaded`.
          // `InvestmentUpdated` directly extends `SelectedInvestmentState`.
          // `CurrentValueLoaded` extends `ValueLoadingState`, which in turn
          // extends `SelectedInvestmentState`.
          // Therefore, checking `state is SelectedInvestmentState` is
          // sufficient.
          return InvestmentDetailsPage(investment: state.selectedInvestment);
        } else if (state is InvestmentSubmitted) {
          return InvestmentDetailsPage(investment: state.investment);
        } else if (state is InvestmentDeleted) {
          return InvestmentDetailsPage(investment: state.investment);
        } else {
          // Fancy loading placeholder.
          return GradientBackgroundScaffold(
            // We need to add the whole `AppBar` so that "arrow back" appeared.
            appBar: BlurredAppBar(title: Text(translate('title'))),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.insert_chart,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    translate('investments.loading_details'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  bool _shouldRebuildForState(InvestmentsState _, InvestmentsState current) {
    // Ignore `InvestmentsUpdated` and `InvestmentsError` states. They do
    // not belong to this screen.
    return current is! InvestmentsUpdated && current is! InvestmentsError;
  }

  void _handleInvestmentStateChanges(
    BuildContext context,
    InvestmentsState state,
  ) {
    if (state is InvestmentDeleted) {
      final NavigatorState navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop(true);
      }
    }
  }
}
