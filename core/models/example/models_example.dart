import 'package:models/models.dart';

void main() {
  // User
  const User user = User(id: 'user-123', email: 'investor@example.com');
  print('User: ${user.email}, anonymous: ${user.isAnonymous}');

  // EmailAddress validation
  const EmailAddress validEmail = EmailAddress.dirty('investor@example.com');
  const EmailAddress invalidEmail = EmailAddress.dirty('not-an-email');
  print('Valid email error: ${validEmail.error}');
  print('Invalid email error: ${invalidEmail.error}');

  // Currency
  const Currency currency = Currency(
    entity: 'UNITED STATES OF AMERICA',
    currency: 'US Dollar',
    alphabeticCode: 'USD',
    numericCode: 840,
    minorUnit: 2,
  );
  print('Currency: ${currency.currency} (${currency.alphabeticCode})');

  // Investment
  final Investment investment = Investment.base(
    ticker: 'AAPL',
    companyName: 'Apple Inc.',
    currency: CurrencyCode.usd.value,
    type: 'Stock',
    stockExchange: 'NASDAQ',
    description: 'Apple Inc. designs, manufactures, and markets smartphones.',
    quantity: 10,
    companyLogoUrl: 'https://example.com/aapl.png',
    purchaseDate: DateTime(2024, 1, 15),
  );
  print(
    'Investment: ${investment.companyName} (${investment.ticker}), '
    'qty: ${investment.quantity}, purchased: ${investment.isPurchased}',
  );

  // FeedbackDetails
  const FeedbackDetails feedback = FeedbackDetails(
    feedbackType: FeedbackType.featureRequest,
    feedbackText: 'Please add portfolio export to CSV.',
    rating: FeedbackRating.good,
  );
  print('Feedback type: ${feedback.feedbackType}, rating: ${feedback.rating}');
}
