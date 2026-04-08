part of 'investments_bloc.dart';

@immutable
sealed class InvestmentsEvent {
  const InvestmentsEvent();
}

final class LoadInvestments extends InvestmentsEvent {
  const LoadInvestments();
}

final class LoadMoreInvestments extends InvestmentsEvent {
  const LoadMoreInvestments();
}

final class UpdateInvestmentEvent extends InvestmentsEvent {
  const UpdateInvestmentEvent(this.investment);

  final Investment investment;
}

final class CreateInvestmentEvent extends InvestmentsEvent {
  const CreateInvestmentEvent({required this.investment});

  final Investment investment;
}

final class DeleteInvestmentEvent extends InvestmentsEvent {
  const DeleteInvestmentEvent(this.investment);

  final Investment investment;
}

final class LoadInvestment extends InvestmentsEvent {
  const LoadInvestment(this.investment);

  final Investment investment;
}

final class BulkImportInvestmentsEvent extends InvestmentsEvent {
  const BulkImportInvestmentsEvent({required this.imports});

  final List<InvestmentImportData> imports;
}
