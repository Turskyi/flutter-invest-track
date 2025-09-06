String formatPrice({required double? price, String currency = 'USD'}) {
  if (price == null) return 'Loading...';
  final String priceValue = price.toStringAsFixed(2);
  return currency == 'USD' ? '\$$priceValue' : '$currency $priceValue';
}
