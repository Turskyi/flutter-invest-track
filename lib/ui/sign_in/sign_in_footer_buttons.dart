import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/ui/sign_in/how_it_works_bottom_sheet.dart';

class SignInFooterButtons extends StatelessWidget {
  const SignInFooterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: <Widget>[
        TextButton.icon(
          icon: const Icon(Icons.privacy_tip_outlined),
          label: Text(translate('menu.privacy_policy')),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoute.privacyPolity.path);
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.help_outline),
          label: Text(translate('support.button')),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoute.support.path);
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.info_outline),
          label: Text(translate('how_it_works.button')),
          onPressed: () => HowItWorksBottomSheet.show(context),
        ),
        TextButton.icon(
          icon: const Icon(Icons.play_circle_outline),
          label: Text(translate('demo.explore_button')),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoute.demo.path);
          },
        ),
      ],
    );
  }
}
