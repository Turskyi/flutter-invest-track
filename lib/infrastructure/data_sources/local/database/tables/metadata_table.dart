import 'package:drift/drift.dart';

/// A Drift database table that stores application-level
/// key-value metadata.
///
/// ### Why do we need this class?
/// Local storage requires a persistent key-value store to
/// track synchronization state and caching metadata (such as
/// the timestamp of the last successful network fetch per user,
/// represented by keys like `'last_fetched_at_<userId>'`).
///
/// ### How do we use it?
/// - **Writing metadata**: We insert or replace key-value pairs
///   (e.g., saving the last fetch ISO-8601 timestamp when
///   portfolio data is successfully synchronized).
/// - **Reading metadata**: We query by `key` to check freshness
///   (e.g., enforcing a 5-minute cache TTL before deciding
///   whether to re-fetch from the network).
@DataClassName('MetadataEntity')
class MetadataTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{key};
}
