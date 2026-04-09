import 'package:flutter/material.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/router/app_route.dart';

class PrivacyHomeButton extends StatelessWidget {
  const PrivacyHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoute.signIn.path,
              (Route<Object?> _) => false,
            );
          },
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  '${constants.imagePath}logo.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

