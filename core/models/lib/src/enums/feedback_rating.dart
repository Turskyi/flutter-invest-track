/// A user-provided sentiment rating.
enum FeedbackRating {
  bad,
  neutral,
  good;

  String get value {
    switch (this) {
      case FeedbackRating.bad:
        return 'feedback.bad';
      case FeedbackRating.neutral:
        return 'feedback.neutral';
      case FeedbackRating.good:
        return 'feedback.good';
    }
  }
}
