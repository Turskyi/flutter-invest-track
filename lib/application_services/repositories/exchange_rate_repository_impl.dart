import 'package:injectable/injectable.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:models/models.dart';

@Injectable(as: ExchangeRateRepository)
class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  const ExchangeRateRepositoryImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<double> getExchangeRate({
    required String fromCurrency,
    String toCurrency = 'CAD',
  }) {
    return _restClient.getExchangeRate(fromCurrency).then((
      ExchangeRate exchangeRate,
    ) {
      final Rates rates = exchangeRate.rates;

      final Map<String, double> currencyMap = rates.toJson();

      return currencyMap[toCurrency.toUpperCase()] ?? 0;
    });
  }
}
