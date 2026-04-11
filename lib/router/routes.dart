import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investments_page.dart';
import 'package:investtrack/ui/privacy/privacy_policy_page.dart';
import 'package:investtrack/ui/sign_in/sign_in_page.dart';
import 'package:investtrack/ui/support/support_page.dart';

Map<String, WidgetBuilder> getRouteMap({
  required InvestmentsBloc investmentsBloc,
  required InvestmentsBloc demoInvestmentsBloc,
}) {
  return <String, WidgetBuilder>{
    AppRoute.investments.path: (BuildContext _) {
      return BlocProvider<InvestmentsBloc>(
        create: (BuildContext _) {
          return investmentsBloc..add(const LoadInvestments());
        },
        child: const InvestmentsPage(),
      );
    },
    AppRoute.signIn.path: (BuildContext _) => const SignInPage(),
    AppRoute.privacyPolity.path: (BuildContext _) => const PrivacyPolicyPage(),
    AppRoute.support.path: (BuildContext _) => const SupportPage(),
    AppRoute.addInvestment.path: (BuildContext _) {
      return BlocProvider<InvestmentsBloc>(
        create: (BuildContext _) => investmentsBloc,
        child: const AddEditInvestmentPage(),
      );
    },
    AppRoute.demo.path: (BuildContext _) => BlocProvider<InvestmentsBloc>(
      create: (BuildContext _) {
        return demoInvestmentsBloc..add(const LoadInvestments());
      },
      child: const InvestmentsPage(isDemo: true),
    ),
  };
}
