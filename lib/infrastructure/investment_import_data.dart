/// Data extracted from an XLSX file row, representing a single stock position
/// to be imported into the app.
class InvestmentImportData {
  const InvestmentImportData({
    required this.ticker,
    required this.companyName,
    required this.stockExchange,
    required this.currency,
    required this.quantity,
    this.type,
    this.purchaseDate,
  });

  /// The stock ticker symbol, e.g. "AAPL".
  final String ticker;

  /// The full company name, e.g. "Apple Inc".
  final String companyName;

  /// The stock exchange where the stock is listed, e.g. "NASDAQ".
  final String stockExchange;

  /// The currency the stock is priced in, e.g. "USD".
  final String currency;

  /// Number of shares owned. A value of 0 means this is a watchlist item.
  final int quantity;

  /// Investment type derived from the cell background colour in the XLSX
  /// (e.g. "Technology", "Games"). Null when no colour is assigned.
  final String? type;

  /// Date of the portfolio snapshot that contains this row, parsed from the
  /// section header (e.g. "Total Value on Jun 2 2023 in $"). Null when the
  /// date cannot be parsed.
  final DateTime? purchaseDate;
}
