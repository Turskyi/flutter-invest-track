import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('EmailAddress', () {
    test('pure state is invalid', () {
      const EmailAddress email = EmailAddress.pure();

      expect(email.isNotValid, isTrue);
    });

    test('valid email is valid', () {
      const EmailAddress email = EmailAddress.dirty('user@example.com');

      expect(email.isValid, isTrue);
    });

    test('empty value is invalid', () {
      const EmailAddress email = EmailAddress.dirty('');

      expect(email.isNotValid, isTrue);
    });

    test('invalid format is invalid', () {
      const EmailAddress email = EmailAddress.dirty('not-an-email');

      expect(email.isNotValid, isTrue);
    });

    test('value shorter than minimum length is invalid', () {
      // emailMinLength is 9, so fewer than 9 characters is invalid.
      const EmailAddress email = EmailAddress.dirty('a@b.c');

      expect(email.isNotValid, isTrue);
    });

    test('value longer than maximum length is invalid', () {
      // emailMaxLength is 40.
      const EmailAddress email = EmailAddress.dirty(
        'averylongemailaddress.thatexceedsmax@example.com',
      );

      expect(email.isNotValid, isTrue);
    });
  });

  group('Password', () {
    test('pure state is invalid', () {
      const Password password = Password.pure();

      expect(password.isNotValid, isTrue);
    });

    test('non-empty password is valid', () {
      const Password password = Password.dirty('secret123');

      expect(password.isValid, isTrue);
    });

    test('empty password is invalid', () {
      const Password password = Password.dirty('');

      expect(password.isNotValid, isTrue);
    });
  });

  group('Code', () {
    test('pure state is invalid', () {
      const Code code = Code.pure();

      expect(code.isNotValid, isTrue);
    });

    test('non-empty code is valid', () {
      const Code code = Code.dirty('ABC123');

      expect(code.isValid, isTrue);
    });

    test('empty code is invalid', () {
      const Code code = Code.dirty('');

      expect(code.isNotValid, isTrue);
    });
  });

  group('User', () {
    test('anonymous constant is anonymous', () {
      expect(User.anonymous.isAnonymous, isTrue);
    });

    test('anonymous constant reports isNotAnonymous as false', () {
      expect(User.anonymous.isNotAnonymous, isFalse);
    });

    test('user with empty id is anonymous', () {
      const User user = User(id: '', email: 'test@example.com');

      expect(user.isAnonymous, isTrue);
    });

    test('user with non-empty id is not anonymous', () {
      const User user = User(id: 'user-123', email: 'test@example.com');

      expect(user.isNotAnonymous, isTrue);
    });

    test('users with same id are equal regardless of email', () {
      const User user1 = User(id: 'user-123', email: 'a@example.com');
      const User user2 = User(id: 'user-123', email: 'b@example.com');

      expect(user1, equals(user2));
    });

    test('users with different ids are not equal', () {
      const User user1 = User(id: 'user-1', email: 'test@example.com');
      const User user2 = User(id: 'user-2', email: 'test@example.com');

      expect(user1, isNot(equals(user2)));
    });
  });

  group('Currency', () {
    test('constructor sets all fields correctly', () {
      const Currency currency = Currency(
        entity: 'UNITED STATES OF AMERICA',
        currency: 'US Dollar',
        alphabeticCode: 'USD',
        numericCode: 840,
        minorUnit: 2,
      );

      expect(currency.entity, equals('UNITED STATES OF AMERICA'));
      expect(currency.currency, equals('US Dollar'));
      expect(currency.alphabeticCode, equals('USD'));
      expect(currency.numericCode, equals(840));
      expect(currency.minorUnit, equals(2));
      expect(currency.withdrawalDate, isNull);
    });

    test('minorUnit defaults to 0 when not provided', () {
      const Currency currency = Currency(
        entity: 'TEST',
        currency: 'Test Currency',
        alphabeticCode: 'TST',
        numericCode: 999,
      );

      expect(currency.minorUnit, equals(0));
    });
  });

  group('Investment', () {
    test('isPurchased is true when quantity is positive', () {
      const Investment investment = Investment.base(
        ticker: 'AAPL',
        companyName: 'Apple Inc.',
        currency: 'USD',
        type: 'stock',
        stockExchange: 'NASDAQ',
        description: 'Apple stock',
        quantity: 10,
        companyLogoUrl: 'https://example.com/logo.png',
        purchaseDate: null,
      );

      expect(investment.isPurchased, isTrue);
    });

    test('isPurchased is false when quantity is zero', () {
      const Investment investment = Investment.base(
        ticker: 'AAPL',
        companyName: 'Apple Inc.',
        currency: 'USD',
        type: 'stock',
        stockExchange: 'NASDAQ',
        description: 'Apple stock',
        quantity: 0,
        companyLogoUrl: 'https://example.com/logo.png',
        purchaseDate: null,
      );

      expect(investment.isPurchased, isFalse);
    });
  });

  group('InvestTrackException', () {
    test('toString includes the exception message', () {
      const InvestTrackException exception =
          InvestTrackException('Something went wrong');

      expect(
        exception.toString(),
        equals('InvestTrackException: Something went wrong'),
      );
    });
  });

  group('FeedbackDetails', () {
    test('copyWith updates only the specified fields', () {
      const FeedbackDetails original = FeedbackDetails(
        feedbackType: FeedbackType.bugReport,
        feedbackText: 'original text',
        rating: FeedbackRating.good,
      );

      final FeedbackDetails updated =
          original.copyWith(feedbackText: 'new text');

      expect(updated.feedbackText, equals('new text'));
      expect(updated.feedbackType, equals(FeedbackType.bugReport));
      expect(updated.rating, equals(FeedbackRating.good));
    });

    test('toMap includes all non-null fields', () {
      const FeedbackDetails details = FeedbackDetails(
        feedbackType: FeedbackType.bugReport,
        feedbackText: 'some text',
        rating: FeedbackRating.bad,
      );

      final Map<String, dynamic> map = details.toMap();

      expect(map['feedback_type'], equals(FeedbackType.bugReport));
      expect(map['feedback_text'], equals('some text'));
      expect(map['rating'], equals(FeedbackRating.bad));
    });

    test('toMap excludes rating key when rating is null', () {
      const FeedbackDetails details = FeedbackDetails(
        feedbackType: FeedbackType.featureRequest,
        feedbackText: 'some text',
      );

      final Map<String, dynamic> map = details.toMap();

      expect(map.containsKey('rating'), isFalse);
    });
  });
}
