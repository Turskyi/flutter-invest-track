import 'package:models/models.dart';

abstract interface class RestClient {
  const RestClient();

  Future<LoginResponse> signEmail(String identifier);

  Future<LoginResponse> signIn(
    String identifier,
    String password,
    String strategy,
  );

  Future<LogoutResponse> signOut();

  Future<InvestmentResult> createInvestment(Investment investment);

  Future<InvestmentResult> updateInvestment(Investment investment);

  Future<MessageResponse> deleteInvestment(String userId, int investmentId);

  Future<Investments> getInvestments(String userId, int page, int itemsPerPage);

  Future<MessageResponse> deleteAccount(String userId);

  Future<ExchangeRate> getExchangeRate(String fromCurrency);

  Future<PriceChange> fetchPriceChange(String ticker);

  Future<ChangePercentage> fetchChangePercentage(String ticker);
}
