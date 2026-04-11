import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/application_services/repositories/demo_exchange_rate_repository.dart';
import 'package:investtrack/application_services/repositories/demo_investments_repository.dart';
import 'package:models/models.dart';

void main() {
  const DemoInvestmentsRepository repository = DemoInvestmentsRepository();

  group('DemoInvestmentsRepository', () {
    test('getInvestments returns exactly 5 investments', () async {
      final Investments result = await repository.getInvestments(userId: 'any');

      expect(result.investments, hasLength(5));
    });

    test('getInvestments always returns page 1 of 1', () async {
      final Investments result = await repository.getInvestments(userId: 'any');

      expect(result.currentPage, 1);
      expect(result.totalPages, 1);
    });

    test('all demo investments have non-empty tickers', () async {
      final Investments result = await repository.getInvestments(userId: 'any');

      for (final Investment investment in result.investments) {
        expect(investment.ticker, isNotEmpty);
      }
    });

    test(
      'all demo investments have empty companyLogoUrl to avoid network calls',
      () async {
        final Investments result = await repository.getInvestments(
          userId: 'any',
        );

        for (final Investment investment in result.investments) {
          expect(
            investment.companyLogoUrl,
            isEmpty,
            reason:
                '${investment.ticker} must not use a network logo URL in demo '
                'mode',
          );
        }
      },
    );

    test(
      'all demo investments have non-null gainOrLossCad for desktop table',
      () async {
        final Investments result = await repository.getInvestments(
          userId: 'any',
        );

        for (final Investment investment in result.investments) {
          expect(
            investment.gainOrLossCad,
            isNotNull,
            reason:
                '${investment.ticker} must have gainOrLossCad set so the '
                'desktop table does not show N/A',
          );
        }
      },
    );

    test('demo investments include the expected tickers', () async {
      final Investments result = await repository.getInvestments(userId: 'any');

      final List<String> tickers = result.investments
          .map((Investment i) => i.ticker)
          .toList();

      expect(
        tickers,
        containsAll(<String>['AAPL', 'MSFT', 'NVDA', 'TSLA', 'GOOGL']),
      );
    });

    test('create returns the investment unchanged', () async {
      final Investments result = await repository.getInvestments(
        userId: 'demo',
      );
      final Investment original = result.investments.first;

      final Investment returned = await repository.create(original);

      expect(returned, same(original));
    });

    test('update returns the investment unchanged', () async {
      final Investments result = await repository.getInvestments(
        userId: 'demo',
      );
      final Investment original = result.investments.first;

      final Investment returned = await repository.update(original);

      expect(returned, same(original));
    });

    test('delete returns a non-empty message', () async {
      final Investments result = await repository.getInvestments(
        userId: 'demo',
      );
      final Investment investment = result.investments.first;

      final MessageResponse response = await repository.delete(investment);

      expect(response.message, isNotEmpty);
    });

    test('fetchPriceChange returns 0.0', () async {
      expect(await repository.fetchPriceChange('AAPL'), 0.0);
    });

    test('fetchChangePercentage returns 0.0', () async {
      expect(await repository.fetchChangePercentage('AAPL'), 0.0);
    });
  });

  group('DemoExchangeRateRepository', () {
    const DemoExchangeRateRepository exchangeRepo =
        DemoExchangeRateRepository();

    test('getExchangeRate returns a positive rate', () async {
      final double rate = await exchangeRepo.getExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'CAD',
      );

      expect(rate, greaterThan(0));
    });

    test('getExchangeRate returns a rate without network calls', () async {
      // Should complete immediately with a hardcoded value.
      expect(exchangeRepo.getExchangeRate(fromCurrency: 'USD'), completes);
    });
  });
}
