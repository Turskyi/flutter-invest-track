import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/application_services/repositories/demo_exchange_rate_repository.dart';
import 'package:investtrack/application_services/repositories/demo_investments_repository.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investments_page.dart';
import 'package:investtrack/ui/marketing/marketing_url_page.dart';
import 'package:investtrack/ui/privacy/privacy_choices_page.dart';
import 'package:investtrack/ui/privacy/privacy_policy_page.dart';
import 'package:investtrack/ui/sign_in/sign_in_page.dart';
import 'package:investtrack/ui/support/support_page.dart';
import 'package:investtrack/ui/widgets/public_theme_wrapper.dart';

Map<String, WidgetBuilder> getRouteMap({
  required InvestmentsBloc investmentsBloc,
  required AuthenticationBloc authenticationBloc,
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
    AppRoute.signIn.path: (BuildContext _) =>
        const PublicThemeWrapper(child: SignInPage()),
    AppRoute.privacyPolity.path: (BuildContext _) =>
        const PublicThemeWrapper(child: PrivacyPolicyPage()),
    AppRoute.privacyChoices.path: (BuildContext _) =>
        const PublicThemeWrapper(child: PrivacyChoicesPage()),
    AppRoute.marketing.path: (BuildContext _) =>
        const PublicThemeWrapper(child: MarketingUrlPage()),
    AppRoute.support.path: (BuildContext _) =>
        const PublicThemeWrapper(child: SupportPage()),
    AppRoute.addInvestment.path: (BuildContext _) {
      return BlocProvider<InvestmentsBloc>(
        create: (BuildContext _) => investmentsBloc,
        child: const AddEditInvestmentPage(),
      );
    },
    AppRoute.demo.path: (BuildContext _) => BlocProvider<InvestmentsBloc>(
      create: (BuildContext _) => InvestmentsBloc(
        const DemoInvestmentsRepository(),
        const DemoExchangeRateRepository(),
        authenticationBloc,
        isDemo: true,
      )..add(const LoadInvestments()),
      child: const InvestmentsPage(isDemo: true),
    ),
  };
}
