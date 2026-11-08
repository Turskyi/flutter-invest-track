import 'package:drift/drift.dart';

@DataClassName('InvestmentEntity')
class InvestmentsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get userId => text()();
  TextColumn get ticker => text()();
  TextColumn get companyName => text()();
  TextColumn get currency => text()();
  TextColumn get type => text()();
  TextColumn get stockExchange => text()();
  TextColumn get description => text()();
  IntColumn get quantity => integer()();
  RealColumn get totalValueOnPurchase => real().nullable()();
  TextColumn get companyLogoUrl => text()();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  BoolColumn get isPurchased {
    return boolean().withDefault(const Constant<bool>(true))();
  }

  RealColumn get purchasePrice => real().nullable()();
  RealColumn get totalCurrentValue => real().nullable()();
  RealColumn get gainOrLossCad => real().nullable()();
  RealColumn get gainOrLossUsd => real().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  RealColumn get currentPrice => real().nullable()();
  TextColumn get slug => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id, userId};
}
