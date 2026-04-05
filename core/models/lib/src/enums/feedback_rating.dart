import 'package:flutter_easy_translate/flutter_easy_translate.dart';

/// A user-provided sentiment rating.
enum FeedbackRating {
  bad,
  neutral,
  good;

  String get value {
    switch (this) {
      case FeedbackRating.bad:
        return translate('feedback.bad');
      case FeedbackRating.neutral:
        return translate('feedback.neutral');
      case FeedbackRating.good:
        return translate('feedback.good');
    }
  }
}
