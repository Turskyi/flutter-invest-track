import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtrack/application_services/blocs/theme/theme_bloc.dart';
import 'package:models/models.dart';

class PublicThemeWrapper extends StatelessWidget {
  const PublicThemeWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (BuildContext context, ThemeState themeState) {
        final bool isVibrant = themeState.theme == AppTheme.vibrant;

        if (isVibrant) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0D47A1),
                secondary: Color(0xFFC79100),
                onSurface: Colors.black,
                onBackground: Colors.black,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
                bodyLarge: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
                headlineSmall: TextStyle(color: Colors.black),
                headlineMedium: TextStyle(color: Colors.black),
                headlineLarge: TextStyle(color: Colors.black),
                titleMedium: TextStyle(color: Colors.black),
                titleSmall: TextStyle(color: Colors.black),
                titleLarge: TextStyle(color: Colors.black),
                labelLarge: TextStyle(color: Colors.black),
                labelMedium: TextStyle(color: Colors.black),
                labelSmall: TextStyle(color: Colors.black),
              ),
              iconTheme: const IconThemeData(color: Colors.black87),
              inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelStyle: TextStyle(color: Colors.black54),
                hintStyle: TextStyle(color: Colors.black38),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                elevation: 4,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child: child,
          );
        }

        return child;
      },
    );
  }
}
