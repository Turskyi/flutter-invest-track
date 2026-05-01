import 'dart:async';
import 'dart:convert';

import 'package:clerk_auth/clerk_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPrefsPersistor] is a [Persistor] implementation that uses
/// `package:shared_preferences` to persist Clerk authentication data.
class SharedPrefsPersistor implements Persistor {
  SharedPrefsPersistor(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> initialize() async {}

  @override
  void terminate() {}

  @override
  FutureOr<T?> read<T>(String key) {
    final String? data = _prefs.getString('clerk_$key');
    if (data == null) {
      return null;
    }
    return json.decode(data) as T?;
  }

  @override
  FutureOr<void> write<T>(String key, T value) async {
    await _prefs.setString('clerk_$key', json.encode(value));
  }

  @override
  FutureOr<void> delete(String key) async {
    await _prefs.remove('clerk_$key');
  }
}
