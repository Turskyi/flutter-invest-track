enum AppRoute {
  investments('/investments'),
  addInvestment('/add-investment'),
  editInvestment('/edit-investment'),
  signIn('/sign-in'),
  code('/code'),
  privacyPolity('/privacy-policy'),
  signUp('/sign-up');

  const AppRoute(this.path);

  final String path;
}
