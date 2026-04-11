import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/utils/price_utils.dart';

void main() {
  group('formatPrice', () {
    test('formats USD with dollar symbol', () {
      expect(
        formatPrice(price: 123.456, currency: PriceCurrency.usd),
        equals(r'$123.46'),
      );
    });

    test('formats known non-USD currency with currency code', () {
      expect(
        formatPrice(price: 123.4, currency: PriceCurrency.cad),
        equals('CAD 123.40'),
      );
    });

    test('formats unknown currency from code', () {
      expect(
        formatPriceByCode(price: 10, currencyCode: 'jpy'),
        equals('jpy 10.00'),
      );
    });
  });

  group('PriceCurrency.fromCode', () {
    test('matches known currencies case-insensitively', () {
      expect(PriceCurrency.fromCode('usd'), equals(PriceCurrency.usd));
      expect(PriceCurrency.fromCode('CAD'), equals(PriceCurrency.cad));
      expect(PriceCurrency.fromCode('Eur'), equals(PriceCurrency.eur));
      expect(PriceCurrency.fromCode('gbp'), equals(PriceCurrency.gbp));
    });

    test('returns other for unsupported code', () {
      expect(PriceCurrency.fromCode('JPY'), equals(PriceCurrency.other));
    });
  });
}
