import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/gradient_background_scaffold.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.redirectRoute});

  final String? redirectRoute;

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return GradientBackgroundScaffold(
      appBar: BlurredAppBar(title: Text(translate('not_found.title'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, size: 100, color: Colors.red.shade400),
            const SizedBox(height: 20),
            Text(
              translate('not_found.message'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              translate('not_found.details'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  redirectRoute ?? AppRoute.investments.path,
                );
              },
              child: Text(translate('not_found.go_home_button')),
            ),
          ],
        ),
      ),
    );
  }
}
