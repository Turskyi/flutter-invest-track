part of 'investments_bloc.dart';

@immutable
sealed class InvestmentsState {
  const InvestmentsState({
    this.investments = const <Investment>[],
    this.lastUpdated,
  });

  /// The list of investments currently loaded in state.
  final List<Investment> investments;

  /// The timestamp when investment and market price data were
  /// last successfully updated.
  ///
  /// ### Why is this nullable?
  /// It is nullable (`DateTime?`) because:
  /// - **Initial State (`null`)**: When the app first launches or enters
  ///   [InvestmentsLoading] before any network request has completed,
  ///   no timestamp exists yet.
  /// - **Error State (`null` or preserved)**: If initial loading fails,
  ///   no timestamp is established.
  ///
  /// ### What does `null` mean?
  /// A `null` value indicates that data has not yet been fetched or
  /// refreshed during the current session, or that no successful update
  /// timestamp has been recorded.
  ///
  /// ### How is it handled?
  /// - **In UI**: The presentation layer (`InvestmentsPage`) checks
  ///   `if (state.lastUpdated != null)` before attempting to render the
  ///   "Last updated" subtitle in the app bar. If `null`, the subtitle
  ///   is omitted.
  /// - **In Bloc / State Transitions**: When data is loaded or refreshed
  ///   in `InvestmentsBloc`, `DateTime.now()` is assigned to `lastUpdated`
  ///   and propagated across state updates via `copyWith` to maintain
  ///   freshness context.
  final DateTime? lastUpdated;
}

final class InvestmentsLoading extends InvestmentsState {
  const InvestmentsLoading({super.lastUpdated});
}

final class InvestmentsError extends InvestmentsState {
  const InvestmentsError({
    required this.errorMessage,
    super.investments,
    super.lastUpdated,
  });

  final String errorMessage;
}

final class UnauthenticatedInvestmentsAccessState extends InvestmentsError {
  const UnauthenticatedInvestmentsAccessState({
    required super.errorMessage,
    super.lastUpdated,
  });
}

final class InvestmentsLoaded extends InvestmentsState {
  const InvestmentsLoaded({
    required this.hasReachedMax,
    super.investments,
    super.lastUpdated,
    this.isLoadingMore = false,
  });

  final bool isLoadingMore;
  final bool hasReachedMax;

  bool get canLoadMore => !isLoadingMore && !hasReachedMax;

  InvestmentsLoaded copyWith({
    bool? isLoadingMore,
    bool? hasReachedMax,
    List<Investment>? investments,
    DateTime? lastUpdated,
  }) {
    return InvestmentsLoaded(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      investments: investments ?? this.investments,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

final class InvestmentsUpdated extends InvestmentsLoaded {
  const InvestmentsUpdated({
    required super.hasReachedMax,
    required super.investments,
    super.isLoadingMore = false,
    super.lastUpdated,
  });
}

final class CreatingInvestment extends InvestmentsLoaded {
  const CreatingInvestment({
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });
}

base class SubmittingInvestment extends InvestmentsLoaded {
  const SubmittingInvestment({
    required this.investmentId,
    required super.investments,
    super.hasReachedMax = false,
    super.isLoadingMore = false,
    super.lastUpdated,
  });

  final int investmentId;
}

final class UpdatingInvestment extends SubmittingInvestment {
  const UpdatingInvestment({
    required super.investmentId,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });
}

final class InvestmentDeleting extends SubmittingInvestment {
  const InvestmentDeleting({
    required super.investmentId,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });
}

final class InvestmentDeleted extends InvestmentsLoaded {
  const InvestmentDeleted({
    required this.investment,
    required super.investments,
    required this.message,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });

  final String message;
  final Investment investment;
}

final class SelectedInvestmentState extends InvestmentsLoaded {
  const SelectedInvestmentState({
    required this.selectedInvestment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });

  final Investment selectedInvestment;
}

final class ValueLoadingState extends SelectedInvestmentState {
  const ValueLoadingState({
    required super.selectedInvestment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });
}

final class CurrentValueLoaded extends ValueLoadingState {
  const CurrentValueLoaded({
    required this.currentPrice,
    required super.selectedInvestment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });

  final double currentPrice;
}

final class ExchangeRateLoaded extends CurrentValueLoaded {
  const ExchangeRateLoaded({
    required this.exchangeRate,
    required super.currentPrice,
    required super.selectedInvestment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
    super.lastUpdated,
  });

  final double exchangeRate;
}

final class InvestmentUpdated extends SelectedInvestmentState {
  const InvestmentUpdated({
    required this.currentPrice,
    required super.selectedInvestment,
    required super.investments,
    required super.hasReachedMax,
    this.exchangeRate,
    this.purchasePrice,
    super.isLoadingMore = false,
    this.priceChange = 0,
    this.changePercentage = 0,
    super.lastUpdated,
  });

  final double? purchasePrice;
  final double currentPrice;
  final double? exchangeRate;
  final double priceChange;
  final double changePercentage;

  @override
  InvestmentUpdated copyWith({
    bool? isLoadingMore,
    bool? hasReachedMax,
    double? purchasePrice,
    double? currentPrice,
    double? exchangeRate,
    double? priceChange,
    double? changePercentage,
    Investment? selectedInvestment,
    List<Investment>? investments,
    DateTime? lastUpdated,
  }) {
    return InvestmentUpdated(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      priceChange: priceChange ?? this.priceChange,
      changePercentage: changePercentage ?? this.changePercentage,
      selectedInvestment: selectedInvestment ?? this.selectedInvestment,
      investments: investments ?? this.investments,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

final class InvestmentSubmitted extends InvestmentsLoaded {
  const InvestmentSubmitted({
    required this.investment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });

  final Investment investment;
}

final class InvestmentError extends InvestmentsLoaded {
  const InvestmentError({
    required this.errorMessage,
    required this.investment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });

  final Investment investment;
  final String errorMessage;
}

/// Emitted while a bulk XLSX import is in progress.
final class ImportingInvestments extends InvestmentsLoaded {
  const ImportingInvestments({
    required super.investments,
    required super.hasReachedMax,
    required this.current,
    required this.total,
    super.isLoadingMore = false,
  });

  /// Index of the stock currently being imported (0-based).
  final int current;

  /// Total number of stocks to import.
  final int total;
}

/// Emitted when a bulk XLSX import has finished.
final class ImportCompleted extends InvestmentsLoaded {
  const ImportCompleted({
    required super.investments,
    required super.hasReachedMax,
    required this.importedCount,
    required this.failedCount,
    super.isLoadingMore = false,
  });

  final int importedCount;
  final int failedCount;
}
