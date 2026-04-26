import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF0D47A1);
const Color _secondaryGold = Color(0xFFC79100);

const Color _primaryBlack = Color(0xFF000000);
const Color _secondaryRed = Color(0xFFD32F2F);

ThemeData get vibrantTheme => _buildTheme(
  primary: _primaryBlue,
  secondary: _secondaryGold,
  background: const Color(0xFF121212),
  surface: const Color(0xFF1E1E1E),
);

ThemeData get stealthTheme => _buildTheme(
  primary: _primaryBlack,
  secondary: _secondaryRed,
  background: const Color(0xFF000000),
  surface: const Color(0xFF121212),
);

ThemeData _buildTheme({
  required Color primary,
  required Color secondary,
  required Color background,
  required Color surface,
}) {
  return ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      outline: Colors.white.withValues(alpha: 0.12),
      primaryContainer: primary.withValues(alpha: 0.8),
    ),
    textTheme:
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            fontFamily: 'OpenSans',
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0,
            fontFamily: 'OpenSans',
            color: Colors.white,
          ),
        ).copyWith(
          headlineSmall: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: Colors.white70,
          ),
          titleMedium: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: secondary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return primary.withValues(alpha: 0.3);
          }
          return primary.withValues(alpha: 0.8);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade400;
          }
          return Colors.white;
        }),
        elevation: WidgetStateProperty.resolveWith<double>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return 0.0;
          }
          return 5.0;
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0x80FFFFFF),
    ),
    cardColor: surface,
    scaffoldBackgroundColor: background,
    dividerColor: Colors.grey.shade700,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Color(0xFFB0BEC5)),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: secondary, width: 2.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      errorStyle: TextStyle(
        color: Colors.red.shade100,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      errorMaxLines: 3,
    ),
  );
}
