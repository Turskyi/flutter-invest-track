enum AppTheme {
  vibrant('vibrant'),
  stealth('stealth');

  const AppTheme(this.value);

  final String value;

  static AppTheme fromValue(String? value) {
    return AppTheme.values.firstWhere(
      (AppTheme theme) => theme.value == value,
      orElse: () => AppTheme.vibrant,
    );
  }
}
