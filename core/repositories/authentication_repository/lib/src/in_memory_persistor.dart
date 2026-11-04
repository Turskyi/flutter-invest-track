import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart';

/// [InMemoryPersistor] is a [Persistor] implementation that keeps
/// Clerk authentication data in memory for the duration of the session.
class InMemoryPersistor implements Persistor {
  final Map<String, dynamic> _storage = <String, dynamic>{};

  @override
  Future<void> initialize() async {}

  @override
  void terminate() {
    _storage.clear();
  }

  @override
  FutureOr<T?> read<T>(String key) {
    return _storage[key] as T?;
  }

  @override
  FutureOr<void> write<T>(String key, T value) async {
    _storage[key] = value;
  }

  @override
  FutureOr<void> delete(String key) async {
    _storage.remove(key);
  }
}
