import 'package:flutter/material.dart';

class GradientBackgroundScaffold extends StatelessWidget {
  const GradientBackgroundScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            colorScheme.primaryContainer.withValues(alpha: 0.8),
            colorScheme.secondary,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: appBar,
        drawer: drawer,
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
