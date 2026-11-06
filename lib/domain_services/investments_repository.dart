import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:models/models.dart';

abstract interface class InvestmentsRepository {
  const InvestmentsRepository();

  Future<Investments> getInvestments({
    required String userId,
    int page = constants.pageOffset,
    int investmentsPerPage = constants.itemsPerPage,
  });

  Future<Investment> create(Investment investment);

  Future<Investment> update(Investment investment);

  Future<MessageResponse> delete(Investment investment);

  Future<double> fetchPriceChange(String ticker);

  Future<double> fetchChangePercentage(String ticker);

  /// Fetches financial data (current or historical stock price)
  /// for a given ticker.
  ///
  /// **Request Example**:
  /// `fetchFinance(ticker: "BMV", date: "2023-06-02")`
  /// or
  /// `fetchFinance(ticker: "AAPL")`
  ///
  /// **Response Example**:
  /// Returns `double` representing the stock price (e.g. `253.5`).
  Future<double> fetchFinance({required String ticker, String? date});
}
