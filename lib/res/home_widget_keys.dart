/// Enum representing keys used to store and retrieve home widget data.
enum HomeWidgetKey {
  totalPortfolioValue,
  totalGainOrLoss,
  totalGainOrLossPercentage,
  isPositive,
  totalInvested,
  totalHoldingsCount,
  lastUpdated,
  currency,
  topHoldingsJson,
  appTheme,
  totalPortfolioValueLabel,
  investedLabel,
  topHoldingsLabel,
  selectedLanguage;

  String get stringValue {
    switch (this) {
      case HomeWidgetKey.totalPortfolioValue:
        return 'total_portfolio_value';
      case HomeWidgetKey.totalGainOrLoss:
        return 'total_gain_or_loss';
      case HomeWidgetKey.totalGainOrLossPercentage:
        return 'total_gain_or_loss_percentage';
      case HomeWidgetKey.isPositive:
        return 'is_positive';
      case HomeWidgetKey.totalInvested:
        return 'total_invested';
      case HomeWidgetKey.totalHoldingsCount:
        return 'total_holdings_count';
      case HomeWidgetKey.lastUpdated:
        return 'last_updated';
      case HomeWidgetKey.currency:
        return 'currency';
      case HomeWidgetKey.topHoldingsJson:
        return 'top_holdings_json';
      case HomeWidgetKey.appTheme:
        return 'app_theme';
      case HomeWidgetKey.totalPortfolioValueLabel:
        return 'total_portfolio_value_label';
      case HomeWidgetKey.investedLabel:
        return 'invested_label';
      case HomeWidgetKey.topHoldingsLabel:
        return 'top_holdings_label';
      case HomeWidgetKey.selectedLanguage:
        return 'selected_language';
    }
  }
}
