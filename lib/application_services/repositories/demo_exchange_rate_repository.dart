import 'package:investtrack/domain_services/exchange_rate_repository.dart';

/// A stub exchange rate repository used in demo mode.
/// Returns fixed rates so no network calls are made for unauthenticated users.
class DemoExchangeRateRepository implements ExchangeRateRepository {
  const DemoExchangeRateRepository();

  @override
  Future<double> getExchangeRate({
    required String fromCurrency,
    String toCurrency = 'CAD',
  }) async {
    return 1.36;
  }
}
