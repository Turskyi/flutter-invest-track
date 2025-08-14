import 'package:flutter/material.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/gradient_background_scaffold.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.redirectRoute});

  final String? redirectRoute;

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundScaffold(
      appBar: const BlurredAppBar(title: Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, size: 100, color: Colors.red.shade400),
            const SizedBox(height: 20),
            const Text(
              'Oops! The page you were looking for does not exist.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'It might have been removed, renamed, or is temporarily '
              'unavailable.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  redirectRoute ?? AppRoute.investments.path,
                );
              },
              child: const Text('Go to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}
