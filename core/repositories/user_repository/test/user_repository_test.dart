import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('UserRepository', () {
    test(
      'getUser returns user with id and email stored in SharedPreferences',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          StorageKeys.userId.key: 'abc123',
          StorageKeys.email.key: 'user@example.com',
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final UserRepository repository = UserRepository(prefs);

        final User user = repository.getUser();

        expect(user.id, 'abc123');
        expect(user.email, 'user@example.com');
      },
    );

    test(
      'getUser returns anonymous user when SharedPreferences is empty',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final UserRepository repository = UserRepository(prefs);

        final User user = repository.getUser();

        expect(user, User.anonymous);
        expect(user.isAnonymous, isTrue);
      },
    );

    test(
      'getUser returns user with empty id when only email is stored',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          StorageKeys.email.key: 'user@example.com',
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final UserRepository repository = UserRepository(prefs);

        final User user = repository.getUser();

        expect(user.id, isEmpty);
        expect(user.email, 'user@example.com');
        expect(user.isAnonymous, isTrue);
      },
    );

    test(
      'getUser returns non-anonymous user when id is stored without email',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          StorageKeys.userId.key: 'abc123',
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final UserRepository repository = UserRepository(prefs);

        final User user = repository.getUser();

        expect(user.id, 'abc123');
        expect(user.email, isEmpty);
        expect(user.isAnonymous, isFalse);
        expect(user.isNotAnonymous, isTrue);
      },
    );
  });
}
