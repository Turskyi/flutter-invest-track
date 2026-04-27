/// What type of feedback the user wants to provide.
enum FeedbackType {
  bugReport,
  featureRequest;

  String get value {
    switch (this) {
      case FeedbackType.bugReport:
        return 'feedback.bugReport';
      case FeedbackType.featureRequest:
        return 'feedback.featureRequest';
    }
  }
}
