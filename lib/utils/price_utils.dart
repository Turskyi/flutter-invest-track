import 'package:flutter_translate/flutter_translate.dart';

enum PriceCurrency {
  usd('USD'),
  cad('CAD'),
  eur('EUR'),
  gbp('GBP'),
  other('');

  const PriceCurrency(this.code);

  final String code;

  static PriceCurrency fromCode(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return PriceCurrency.usd;
      case 'CAD':
        return PriceCurrency.cad;
      case 'EUR':
        return PriceCurrency.eur;
      case 'GBP':
        return PriceCurrency.gbp;
      default:
        return PriceCurrency.other;
    }
  }
}

String formatPrice({
  required double? price,
  PriceCurrency currency = PriceCurrency.usd,
  String? currencyCode,
}) {
  if (price == null) {
    return translate('investments.loading');
  } else {
    final String priceValue = price.toStringAsFixed(2);
    if (currency == PriceCurrency.usd) {
      return '\$$priceValue';
    } else {
      final String code = currency == PriceCurrency.other
          ? (currencyCode ?? PriceCurrency.usd.code)
          : currency.code;
      return '$code $priceValue';
    }
  }
}

String formatPriceByCode({
  required double? price,
  required String currencyCode,
}) {
  return formatPrice(
    price: price,
    currency: PriceCurrency.fromCode(currencyCode),
    currencyCode: currencyCode,
  );
}
