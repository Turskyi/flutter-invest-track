import 'package:investtrack/router/app_route.dart';

/// The route paths that are accessible without authentication.
///
/// Used by [AppView] to decide whether to redirect an unauthenticated user to
/// the sign-in page or to keep them on their current route.
final Set<String> publicRoutePaths = <String>{
  AppRoute.signIn.path,
  AppRoute.privacyPolity.path,
  AppRoute.demo.path,
  AppRoute.marketing.path,
  AppRoute.support.path,
  AppRoute.privacyChoices.path,
};
