import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/router/routes.dart' as routes;
import 'package:investtrack/ui/investments/investments_page.dart';
import 'package:investtrack/ui/sign_in/sign_in_page.dart';
import 'package:investtrack/ui/splash_page.dart';

/// [AppView] is a [StatefulWidget] because it maintains a [GlobalKey] which is
/// used to access the [NavigatorState]. By default, [AppView] will render the
/// [SplashPage] and it uses [BlocListener] to navigate to different pages
/// based on changes in the [AuthenticationState].
/// Upon a successful `signIn` request, the state of the [AuthenticationBloc]
/// will change to authenticated and the user will be navigated to the
/// [InvestmentsPage] where we display the user’s investments as well as a
/// button to sign out.
@immutable
class AppView extends StatefulWidget {
  const AppView({required this.authenticationBloc, super.key});

  final AuthenticationBloc authenticationBloc;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  final bool _isDarkTheme = true;

  @override
  Widget build(BuildContext context) {
    // Assuming the primary color is dark blue and secondary is dark golden
    const Color primaryBlue = Color(0xFF0D47A1);
    const Color secondaryGold = Color(0xFFC79100);
    const Color semiTransparentBlue = Color(0x660D47A1);
    return MaterialApp(
      title: constants.appName,
      initialRoute: AppRoute.signIn.path,
      routes: routes.routeMap,
      theme: _isDarkTheme
          ? ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                // Darker blue.
                primary: primaryBlue,
                // Dark golden.
                secondary: secondaryGold,
                // Typical dark mode background.
                background: Color(0xFF121212),
                // For cards and menus.
                surface: Color(0xFF1E1E1E),
                // Text/icon color on primary.
                onPrimary: Colors.white,
                // Text/icon color on secondary.
                onSecondary: Colors.black,
                // Text/icon color on background.
                onBackground: Colors.white,
                // Text/icon color on surfaces.
                onSurface: Colors.white,
              ),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto', // Use your desired font
                ),
                bodyLarge: TextStyle(
                  fontSize: 16.0,
                  // Use your desired font.
                  fontFamily: 'OpenSans',
                  // Adjust color for readability in dark mode
                  color: Colors.white,
                ),
              ).copyWith(
                bodyMedium: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'OpenSans',
                  color: Colors.grey, // Semi-light gray for dark mode
                ),
                headlineSmall: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Colors.white70, // Softer white
                ),
                titleMedium: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                // Dark golden for the progress indicator.
                color: secondaryGold,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey
                            .withOpacity(0.3); // Your disabled color
                      }
                      return primaryBlue
                          .withOpacity(0.8); // Default background color
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors
                            .grey.shade600; // Text color for disabled state
                      }
                      return Colors.white; // Default text color
                    },
                  ),
                  elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return 0.0; // No elevation when disabled
                      }
                      return 5.0; // Default elevation
                    },
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 24.0,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: semiTransparentBlue,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                // Background color
                backgroundColor: Color(0xCC0D47A1),
                // Icon or text color
                foregroundColor: Colors.white,
                // Elevation of the button
                elevation: 6.0,
              ),
              cardColor: const Color(0xFF1E1E1E),
              // For card-like widgets
              scaffoldBackgroundColor: const Color(0xFF121212),
              // Dark background
              dividerColor: Colors.grey.shade700,
              // Subtle dividers
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle(
                  color: Color(0xFFB0BEC5), // Softer grey for readability.
                ),
                hintStyle: TextStyle(color: Colors.grey.shade500),
                // Border color when the TextFormField is enabled (not focused).
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                ),
                // Border color when the TextFormField is focused.
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFDD835), width: 2.0),
                ),
                // Border color when there is an error.
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                ),
                errorStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0D47A1),
                // Same primary color for consistency
                secondary: Color(0xFFC79100),
                background: Colors.white,
                surface: Colors.white,
                onPrimary: Colors.white,
                onSecondary: Colors.black,
                onBackground: Colors.black,
                onSurface: Colors.black,
              ),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                bodyLarge: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              buttonTheme: const ButtonThemeData(
                buttonColor: Color(0xFF0D47A1), // Match primary color
                textTheme: ButtonTextTheme.primary,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0D47A1),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              cardColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              dividerColor: Colors.grey[300],
            ),
      navigatorKey: _navigatorKey,
      builder: (BuildContext context, Widget? child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            final AuthenticationStatus status = state.status;
            switch (status) {
              case DeletingAuthenticatedUserStatus():
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion in progress...'),
                  ),
                );
              case AuthenticatedStatus():
                _navigator?.pushAndRemoveUntil<void>(
                  InvestmentsPage.route(widget.authenticationBloc),
                  (Route<void> route) => false,
                );
              case UnauthenticatedStatus():
                _navigator?.pushAndRemoveUntil<void>(
                  SignInPage.route(),
                  (Route<void> route) => false,
                );
                if (status.message.isNotEmpty) {
                  final String message = status.message;
                  Fluttertoast.showToast(
                    msg: message,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0,
                  );
                }
              case UnknownAuthenticationStatus():
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
