import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/entities/demo_investments.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';

import '../../entities/demo_message_response.dart';

/// A read-only in-memory repository used in demo mode.
/// Returns a hardcoded portfolio so unauthenticated users can explore the app
/// without creating an account, satisfying App Store guideline 5.1.1(v).
class DemoInvestmentsRepository implements InvestmentsRepository {
  const DemoInvestmentsRepository();

  static final List<Investment> _demoInvestments = <Investment>[
    Investment(
      id: 1,
      userId: 'demo',
      ticker: 'AAPL',
      companyName: 'Apple Inc.',
      currency: 'USD',
      type: 'Technology',
      stockExchange: 'NASDAQ',
      description:
          'Designs and manufactures consumer electronics, software, '
          'and services.',
      quantity: 10,
      companyLogoUrl: '',
      purchaseDate: DateTime(2023, 1, 15),
      purchasePrice: 134.76,
      currentPrice: 189.30,
      totalValueOnPurchase: 1347.60,
      totalCurrentValue: 1893.00,
      gainOrLossUsd: 545.40,
    ),
    Investment(
      id: 2,
      userId: 'demo',
      ticker: 'MSFT',
      companyName: 'Microsoft Corporation',
      currency: 'USD',
      type: 'Software',
      stockExchange: 'NASDAQ',
      description:
          'Develops and supports software, services, devices, and solutions '
          'worldwide.',
      quantity: 5,
      companyLogoUrl: '',
      purchaseDate: DateTime(2022, 11, 10),
      purchasePrice: 242.00,
      currentPrice: 415.50,
      totalValueOnPurchase: 1210.00,
      totalCurrentValue: 2077.50,
      gainOrLossUsd: 867.50,
    ),
    Investment(
      id: 3,
      userId: 'demo',
      ticker: 'NVDA',
      companyName: 'NVIDIA Corporation',
      currency: 'USD',
      type: 'Technology',
      stockExchange: 'NASDAQ',
      description:
          'Designs graphics processing units and system-on-chip units.',
      quantity: 8,
      companyLogoUrl: '',
      purchaseDate: DateTime(2023, 3, 20),
      purchasePrice: 277.50,
      currentPrice: 875.00,
      totalValueOnPurchase: 2220.00,
      totalCurrentValue: 7000.00,
      gainOrLossUsd: 4780.00,
    ),
    Investment(
      id: 4,
      userId: 'demo',
      ticker: 'TSLA',
      companyName: 'Tesla, Inc.',
      currency: 'USD',
      type: 'Cars',
      stockExchange: 'NASDAQ',
      description:
          'Designs, develops, and sells electric vehicles and energy '
          'solutions.',
      quantity: 12,
      companyLogoUrl: '',
      purchaseDate: DateTime(2023, 6, 5),
      purchasePrice: 248.00,
      currentPrice: 175.00,
      totalValueOnPurchase: 2976.00,
      totalCurrentValue: 2100.00,
      gainOrLossUsd: -876.00,
    ),
    Investment(
      id: 5,
      userId: 'demo',
      ticker: 'GOOGL',
      companyName: 'Alphabet Inc.',
      currency: 'USD',
      type: 'Technology',
      stockExchange: 'NASDAQ',
      description: 'Provides internet-related services and products globally.',
      quantity: 15,
      companyLogoUrl: '',
      purchaseDate: DateTime(2022, 8, 22),
      purchasePrice: 115.00,
      currentPrice: 170.00,
      totalValueOnPurchase: 1725.00,
      totalCurrentValue: 2550.00,
      gainOrLossUsd: 825.00,
    ),
  ];

  @override
  Future<Investments> getInvestments({
    required String userId,
    int page = constants.pageOffset,
    int investmentsPerPage = constants.itemsPerPage,
  }) async {
    return DemoInvestments(investments: _demoInvestments);
  }

  @override
  Future<Investment> create(Investment investment) async => investment;

  @override
  Future<Investment> update(Investment investment) async => investment;

  @override
  Future<MessageResponse> delete(Investment investment) async {
    return const DemoMessageResponse('Demo mode: deletion is not supported.');
  }

  @override
  Future<double> fetchPriceChange(String ticker) async => 0.0;

  @override
  Future<double> fetchChangePercentage(String ticker) async => 0.0;
}
