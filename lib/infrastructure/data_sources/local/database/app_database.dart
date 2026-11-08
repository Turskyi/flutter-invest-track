import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/tables/investments_table.dart';
import 'package:investtrack/infrastructure/data_sources/local/database/tables/metadata_table.dart';
import 'package:models/models.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: <Type>[InvestmentsTable, MetadataTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  Stream<List<Investment>> watchInvestments(String userId) {
    return (select(investmentsTable)
          ..where(($InvestmentsTableTable t) => t.userId.equals(userId)))
        .watch()
        .map(
          (List<InvestmentEntity> entities) =>
              entities.map(_toInvestment).toList(),
        );
  }

  Future<List<Investment>> getInvestments(String userId) async {
    final List<InvestmentEntity> entities = await (select(
      investmentsTable,
    )..where(($InvestmentsTableTable t) => t.userId.equals(userId))).get();
    return entities.map(_toInvestment).toList();
  }

  Future<void> saveInvestments({
    required String userId,
    required List<Investment> investments,
  }) async {
    await batch((Batch batch) {
      for (final Investment investment in investments) {
        batch.insert(
          investmentsTable,
          _toCompanion(investment: investment, userIdOverride: userId),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Inserts or replaces an [investment] in the database.
  ///
  /// Returns the `int` row ID (rowid) of the inserted or replaced record.
  /// Can return `0` (for example, when saving a new investment with an explicit
  /// or default `id` of `0`).
  ///
  /// **Example**:
  /// ```dart
  /// final int rowId = await database.saveInvestment(investment);
  /// print('Saved investment with row ID: $rowId');
  /// ```
  Future<int> saveInvestment(Investment investment) {
    return into(investmentsTable).insert(
      _toCompanion(investment: investment),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Deletes an investment matching the given [id] and [userId].
  ///
  /// Returns the `int` number of rows affected by the delete operation.
  /// - `1`: Successfully deleted the matching investment.
  /// - `0`: No matching investment found.
  ///
  /// **Example**:
  /// ```dart
  /// final int deletedCount = await database.deleteInvestment(
  ///   id: 123,
  ///   userId: 'user_1',
  /// );
  /// if (deletedCount > 0) {
  ///   print('Investment deleted successfully');
  /// }
  /// ```
  Future<int> deleteInvestment({required int id, required String userId}) {
    return (delete(investmentsTable)..where(($InvestmentsTableTable t) {
          return t.id.equals(id) & t.userId.equals(userId);
        }))
        .go();
  }

  Future<DateTime?> getLastFetchedAt(String userId) async {
    final String key = 'last_fetched_at_$userId';
    final MetadataEntity? row = await (select(
      metadataTable,
    )..where(($MetadataTableTable t) => t.key.equals(key))).getSingleOrNull();

    if (row == null) {
      return null;
    }
    return DateTime.tryParse(row.value);
  }

  /// Sets or updates the last fetched timestamp for the given [userId].
  ///
  /// Returns the `int` row ID (rowid) of the inserted or replaced
  /// metadata record.
  ///
  /// **Example**:
  /// ```dart
  /// final int rowId = await database.setLastFetchedAt(
  ///   userId: 'user_1',
  ///   time: DateTime.now(),
  /// );
  /// print('Metadata updated with row ID: $rowId');
  /// ```
  Future<int> setLastFetchedAt({
    required String userId,
    required DateTime time,
  }) {
    final String key = 'last_fetched_at_$userId';
    return into(metadataTable).insert(
      MetadataTableCompanion(
        key: Value<String>(key),
        value: Value<String>(time.toIso8601String()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> clearAll() async {
    await delete(investmentsTable).go();
    await delete(metadataTable).go();
  }

  Investment _toInvestment(InvestmentEntity entity) {
    return Investment(
      id: entity.id,
      userId: entity.userId,
      ticker: entity.ticker,
      companyName: entity.companyName,
      currency: entity.currency,
      type: entity.type,
      stockExchange: entity.stockExchange,
      description: entity.description,
      quantity: entity.quantity,
      totalValueOnPurchase: entity.totalValueOnPurchase,
      companyLogoUrl: entity.companyLogoUrl,
      purchaseDate: entity.purchaseDate,
      isPurchased: entity.isPurchased,
      purchasePrice: entity.purchasePrice,
      totalCurrentValue: entity.totalCurrentValue,
      gainOrLossCad: entity.gainOrLossCad,
      gainOrLossUsd: entity.gainOrLossUsd,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      currentPrice: entity.currentPrice,
      slug: entity.slug,
    );
  }

  InvestmentsTableCompanion _toCompanion({
    required Investment investment,
    String? userIdOverride,
  }) {
    final String effectiveUserId = userIdOverride ?? investment.userId;
    return InvestmentsTableCompanion(
      id: Value<int>(investment.id),
      userId: Value<String>(effectiveUserId),
      ticker: Value<String>(investment.ticker),
      companyName: Value<String>(investment.companyName),
      currency: Value<String>(investment.currency),
      type: Value<String>(investment.type),
      stockExchange: Value<String>(investment.stockExchange),
      description: Value<String>(investment.description),
      quantity: Value<int>(investment.quantity),
      totalValueOnPurchase: Value<double?>(investment.totalValueOnPurchase),
      companyLogoUrl: Value<String>(investment.companyLogoUrl),
      purchaseDate: Value<DateTime?>(investment.purchaseDate),
      isPurchased: Value<bool>(investment.isPurchased),
      purchasePrice: Value<double?>(investment.purchasePrice),
      totalCurrentValue: Value<double?>(investment.totalCurrentValue),
      gainOrLossCad: Value<double?>(investment.gainOrLossCad),
      gainOrLossUsd: Value<double?>(investment.gainOrLossUsd),
      createdAt: Value<DateTime?>(investment.createdAt),
      updatedAt: Value<DateTime?>(investment.updatedAt),
      currentPrice: Value<double?>(investment.currentPrice),
      slug: Value<String?>(investment.slug),
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'investtrack_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (WasmDatabaseResult result) {
          if (result.missingFeatures.isNotEmpty && kDebugMode) {
            debugPrint(
              'Drift Web using ${result.chosenImplementation} due to '
              'unsupported browser features: ${result.missingFeatures}',
            );
          }
        },
      ),
    );
  }
}
