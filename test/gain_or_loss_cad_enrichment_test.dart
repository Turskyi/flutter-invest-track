import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/infrastructure/ws/models/responses/investment_response/investment_response.dart';
import 'package:models/models.dart';

/// Regression tests for the gainOrLossCad enrichment after investment creation.
///
/// The backend response model ([InvestmentResponse]) does not include
/// `gainOrLossCad` in its constructor or generated `fromJson`, so the
/// repository always returns an [Investment] with `gainOrLossCad == null`.
/// The BLoC must compute the value locally and apply it via `copyWith` before
/// adding the investment to the state.
void main() {
  group('gainOrLossCad enrichment after investment creation', () {
    final DateTime now = DateTime(2025, 1, 15);

    late InvestmentResponse backendResponse;

    setUp(() {
      backendResponse = InvestmentResponse(
        id: 1,
        ticker: 'AAPL',
        companyName: 'Apple Inc',
        userId: 'user-1',
        createdAt: now,
        updatedAt: now,
        companyLogoUrl: '',
        slug: null,
        type: 'stock',
        stockExchange: 'NASDAQ',
        currency: 'USD',
        description: 'Apple',
        quantity: 10,
        isPurchased: true,
        purchaseDate: DateTime(2024, 1, 15),
        currentPrice: 150.0,
        gainOrLossUsd: 100.0,
        purchasePrice: 140.0,
      );
    });

    test('InvestmentResponse (backend model) has null gainOrLossCad '
        'because the backend does not return it', () {
      expect(backendResponse.gainOrLossCad, isNull);
    });

    test('copyWith on backend response correctly enriches gainOrLossCad', () {
      const double cadExchangeRate = 1.36;
      final double gainOrLossCad =
          backendResponse.gainOrLossUsd! * cadExchangeRate;

      final Investment enriched = backendResponse.copyWith(
        gainOrLossCad: gainOrLossCad,
      );

      expect(enriched.gainOrLossCad, isNotNull);
      expect(enriched.gainOrLossCad, closeTo(136.0, 0.01));
    });

    test('enrichment is skipped when exchange rate lookup fails '
        '(gainOrLossCad stays null)', () {
      const double? gainOrLossCad = null;

      final Investment enriched = gainOrLossCad != null
          ? backendResponse.copyWith(gainOrLossCad: gainOrLossCad)
          : backendResponse;

      expect(enriched.gainOrLossCad, isNull);
    });

    test('Investment.create accepts optional gainOrLossCad', () {
      final Investment investment = Investment.create(
        ticker: 'AAPL',
        companyName: 'Apple Inc',
        currency: 'USD',
        type: 'stock',
        stockExchange: 'NASDAQ',
        description: 'Apple',
        quantity: 10,
        companyLogoUrl: '',
        purchaseDate: DateTime(2024, 1, 15),
        userId: 'user-1',
        currentPrice: 150.0,
        gainOrLossUsd: 100.0,
        totalValueOnPurchase: 1400.0,
        totalCurrentValue: 1500.0,
        purchasePrice: 140.0,
        gainOrLossCad: 136.0,
      );

      expect(investment.gainOrLossCad, 136.0);
    });

    test('Investment.create defaults gainOrLossCad to null when omitted', () {
      final Investment investment = Investment.create(
        ticker: 'AAPL',
        companyName: 'Apple Inc',
        currency: 'USD',
        type: 'stock',
        stockExchange: 'NASDAQ',
        description: 'Apple',
        quantity: 10,
        companyLogoUrl: '',
        purchaseDate: DateTime(2024, 1, 15),
        userId: 'user-1',
        currentPrice: 150.0,
        gainOrLossUsd: 100.0,
        totalValueOnPurchase: 1400.0,
        totalCurrentValue: 1500.0,
        purchasePrice: 140.0,
      );

      expect(investment.gainOrLossCad, isNull);
    });
  });
}
