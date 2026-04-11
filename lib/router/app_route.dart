enum AppRoute {
  investments('/investments'),
  addInvestment('/add-investment'),
  editInvestment('/edit-investment'),
  signIn('/sign-in'),
  code('/code'),
  privacyPolity('/privacy-policy'),
  privacyChoices('/privacy-choices'),
  signUp('/sign-up'),
  demo('/demo'),
  marketing('/about'),
  support('/support');

  const AppRoute(this.path);

  final String path;
}
