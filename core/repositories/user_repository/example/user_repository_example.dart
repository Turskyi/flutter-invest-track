// ignore_for_file: avoid_print
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/user_repository.dart';

/// A minimal stand-alone illustration of [UserRepository].
///
/// In a real application obtain a [SharedPreferences] instance via
/// `SharedPreferences.getInstance()` after calling
/// `WidgetsFlutterBinding.ensureInitialized()`, then pass it to
/// [UserRepository].
///
/// This example uses a lightweight in-memory stub so the flow can be shown
/// without Flutter or any platform channel.
void main() {
  // 1. Prepare in-memory preferences that simulate what
  //    AuthenticationRepository would have persisted after a successful login.
  final _FakePreferences preferences = _FakePreferences();

  // 2. Build the repository.
  final UserRepository repository = UserRepository(preferences);

  // 3. Retrieve the user when no data has been stored yet (anonymous state).
  final User anonymous = repository.getUser();
  print('Before login  → id: "${anonymous.id}", email: "${anonymous.email}"');
  print('Is anonymous  → ${anonymous.isAnonymous}');

  // 4. Simulate a successful login by populating the preference store.
  preferences.setString(StorageKeys.userId.key, 'abc-123');
  preferences.setString(StorageKeys.email.key, 'investor@example.com');

  // 5. Retrieve the user again – it should now reflect the stored values.
  final User loggedIn = repository.getUser();
  print('After login   → id: "${loggedIn.id}", email: "${loggedIn.email}"');
  print('Is anonymous  → ${loggedIn.isAnonymous}');
}

// ---------------------------------------------------------------------------
// Stub used only by this example – not part of the package API.
// ---------------------------------------------------------------------------

class _FakePreferences implements SharedPreferences {
  final Map<String, Object> _store = <String, Object>{};

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _store.remove(key);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
        '${invocation.memberName} is not implemented in _FakePreferences',
      );
}
