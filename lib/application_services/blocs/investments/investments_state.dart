part of 'investments_bloc.dart';

@immutable
sealed class InvestmentsState {
  const InvestmentsState({
    this.investments = const <Investment>[],
  });

  final List<Investment> investments;
}

final class InvestmentsLoading extends InvestmentsState {
  const InvestmentsLoading();
}

final class InvestmentsError extends InvestmentsState {
  const InvestmentsError({
    required this.errorMessage,
    super.investments,
  });

  final String errorMessage;
}

final class UnauthenticatedInvestmentsAccessState extends InvestmentsError {
  const UnauthenticatedInvestmentsAccessState({required super.errorMessage});
}

final class InvestmentsLoaded extends InvestmentsState {
  const InvestmentsLoaded({
    required this.hasReachedMax,
    super.investments,
    this.isLoadingMore = false,
  });

  final bool isLoadingMore;
  final bool hasReachedMax;

  InvestmentsLoaded copyWith({
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return InvestmentsLoaded(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

final class InvestmentsUpdated extends InvestmentsLoaded {
  const InvestmentsUpdated({
    required super.hasReachedMax,
    required super.investments,
    super.isLoadingMore = false,
  });
}

final class CreatingInvestment extends InvestmentsLoaded {
  const CreatingInvestment({
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });
}

base class SubmittingInvestment extends InvestmentsLoaded {
  const SubmittingInvestment({
    required this.investmentId,
    required super.investments,
    super.hasReachedMax = false,
    super.isLoadingMore = false,
  });

  final int investmentId;
}

final class UpdatingInvestment extends SubmittingInvestment {
  const UpdatingInvestment({
    required super.investmentId,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });
}

final class InvestmentDeleting extends SubmittingInvestment {
  const InvestmentDeleting({
    required super.investmentId,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });
}

final class InvestmentDeleted extends InvestmentsLoaded {
  const InvestmentDeleted({
    required this.investment,
    required super.investments,
    required this.message,
    required super.hasReachedMax,
    super.isLoadingMore = false,
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
  });

  final Investment selectedInvestment;
}

final class ValueLoadingState extends SelectedInvestmentState {
  const ValueLoadingState({
    required super.selectedInvestment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });
}

final class CurrentValueLoaded extends ValueLoadingState {
  const CurrentValueLoaded({
    required this.currentPrice,
    required super.selectedInvestment,
    required super.investments,
    required super.hasReachedMax,
    super.isLoadingMore = false,
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
