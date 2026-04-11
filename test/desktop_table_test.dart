import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/ui/investments/desktop_table.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flutter_translate_test_utils.dart';

void main() {
  late LocalizationDelegate localizationDelegate;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    localizationDelegate = await setUpFlutterTranslateForTests();
  });

  Widget buildSubject({
    required List<Investment> investments,
    bool canLoadMore = false,
    VoidCallback? onLoadMore,
  }) {
    return prepareWidgetForTesting(
      LocalizedApp(
        localizationDelegate,
        DesktopTable(
          investments: investments,
          canLoadMore: canLoadMore,
          onLoadMore: onLoadMore,
        ),
      ),
      localizationDelegate,
    );
  }

  testWidgets('shows N/A for purchase price when purchase date is missing', (
    WidgetTester tester,
  ) async {
    final Investment investment = _buildInvestment(
      purchaseDate: null,
      purchasePrice: null,
    );

    await tester.pumpWidget(
      buildSubject(investments: <Investment>[investment]),
    );
    await tester.pumpAndSettle();

    expect(find.text('N/A'), findsWidgets);
    expect(find.text('Loading...'), findsNothing);
  });

  testWidgets(
    'shows Loading... for purchase price when date exists but price is null',
    (WidgetTester tester) async {
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: null,
      );

      await tester.pumpWidget(
        buildSubject(investments: <Investment>[investment]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Loading...'), findsOneWidget);
    },
  );

  testWidgets(
    'shows formatted purchase price when purchase date and price exist',
    (WidgetTester tester) async {
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: 120,
        currency: 'USD',
      );

      await tester.pumpWidget(
        buildSubject(investments: <Investment>[investment]),
      );
      await tester.pumpAndSettle();

      expect(find.text(r'$120.00'), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);
    },
  );

  testWidgets(
    'requests next page once when content is not scrollable and can load more',
    (WidgetTester tester) async {
      int loadMoreCalls = 0;
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: 120,
      );

      await tester.pumpWidget(
        buildSubject(
          investments: <Investment>[investment],
          canLoadMore: true,
          onLoadMore: () {
            loadMoreCalls++;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(loadMoreCalls, 1);

      await tester.pumpWidget(
        buildSubject(
          investments: <Investment>[investment],
          canLoadMore: true,
          onLoadMore: () {
            loadMoreCalls++;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(loadMoreCalls, 1);
    },
  );

  testWidgets('does not request next page when canLoadMore is false', (
    WidgetTester tester,
  ) async {
    int loadMoreCalls = 0;
    final Investment investment = _buildInvestment(
      purchaseDate: DateTime(2024, 1, 15),
      purchasePrice: 120,
    );

    await tester.pumpWidget(
      buildSubject(
        investments: <Investment>[investment],
        canLoadMore: false,
        onLoadMore: () {
          loadMoreCalls++;
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(loadMoreCalls, 0);
  });

  group('computed value fallbacks', () {
    testWidgets('shows total current value from currentPrice * quantity '
        'when totalCurrentValue is null', (WidgetTester tester) async {
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: 120,
        currentPrice: 150,
        totalCurrentValue: null,
        quantity: 3,
      );

      await tester.pumpWidget(
        buildSubject(investments: <Investment>[investment]),
      );
      await tester.pumpAndSettle();

      // 3 * 150 = 450.00
      expect(find.text(r'$450.00'), findsOneWidget);
    });

    testWidgets('shows total value on purchase from purchasePrice * quantity '
        'when totalValueOnPurchase is null', (WidgetTester tester) async {
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: 120,
        currentPrice: 150,
        totalValueOnPurchase: null,
        quantity: 3,
      );

      await tester.pumpWidget(
        buildSubject(investments: <Investment>[investment]),
      );
      await tester.pumpAndSettle();

      // 3 * 120 = 360.00
      expect(find.text(r'$360.00'), findsOneWidget);
    });

    testWidgets('shows gain/loss CAD when gainOrLossCad is provided', (
      WidgetTester tester,
    ) async {
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: 120,
        gainOrLossCad: 55,
      );

      await tester.pumpWidget(
        buildSubject(investments: <Investment>[investment]),
      );
      await tester.pumpAndSettle();

      expect(find.text('CAD 55.00'), findsOneWidget);
    });

    testWidgets('shows N/A for gain/loss CAD when gainOrLossCad is null', (
      WidgetTester tester,
    ) async {
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: 120,
        gainOrLossCad: null,
      );

      await tester.pumpWidget(
        buildSubject(investments: <Investment>[investment]),
      );
      await tester.pumpAndSettle();

      // The CAD column should show N/A when not enriched by bloc.
      final Finder cadCells = find.text('N/A');
      expect(cadCells, findsWidgets);
    });

    testWidgets('shows explicit totalCurrentValue and totalValueOnPurchase '
        'when provided', (WidgetTester tester) async {
      final Investment investment = _buildInvestment(
        purchaseDate: DateTime(2024, 1, 15),
        purchasePrice: 120,
        currentPrice: 999,
        totalCurrentValue: 280,
        totalValueOnPurchase: 240,
        quantity: 2,
      );

      await tester.pumpWidget(
        buildSubject(investments: <Investment>[investment]),
      );
      await tester.pumpAndSettle();

      // Should use the explicit values, not currentPrice * quantity.
      expect(find.text(r'$280.00'), findsOneWidget);
      expect(find.text(r'$240.00'), findsOneWidget);
    });
  });

  testWidgets('requests next page again after investment count increases', (
    WidgetTester tester,
  ) async {
    int loadMoreCalls = 0;
    final Investment investment = _buildInvestment(
      purchaseDate: DateTime(2024, 1, 15),
      purchasePrice: 120,
    );

    await tester.pumpWidget(
      buildSubject(
        investments: <Investment>[investment],
        canLoadMore: true,
        onLoadMore: () {
          loadMoreCalls++;
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(loadMoreCalls, 1);

    await tester.pumpWidget(
      buildSubject(
        investments: <Investment>[investment, investment.copyWith(id: 2)],
        canLoadMore: true,
        onLoadMore: () {
          loadMoreCalls++;
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(loadMoreCalls, 2);
  });
}

Investment _buildInvestment({
  required DateTime? purchaseDate,
  required double? purchasePrice,
  String currency = 'CAD',
  int quantity = 2,
  double? currentPrice = 140,
  double? totalCurrentValue = 280,
  double? totalValueOnPurchase = 240,
  double? gainOrLossUsd = 40,
  double? gainOrLossCad = 55,
}) {
  return Investment(
    ticker: 'AAPL',
    userId: 'user-1',
    currency: currency,
    type: 'stock',
    companyLogoUrl: '',
    stockExchange: 'NASDAQ',
    description: 'Apple Inc',
    quantity: quantity,
    purchaseDate: purchaseDate,
    companyName: 'Apple Inc',
    currentPrice: currentPrice,
    totalCurrentValue: totalCurrentValue,
    totalValueOnPurchase: totalValueOnPurchase,
    purchasePrice: purchasePrice,
    gainOrLossUsd: gainOrLossUsd,
    gainOrLossCad: gainOrLossCad,
  );
}
