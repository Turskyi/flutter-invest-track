import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;

class BlurredFabWithBorder extends StatelessWidget {
  const BlurredFabWithBorder({
    required this.onPressed,
    super.key,
    this.tooltip,
    this.icon,
    this.borderWidth = 1,
  });

  final VoidCallback onPressed;
  final String? tooltip;
  final IconData? icon;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: constants.blurSigma,
            sigmaY: constants.blurSigma,
          ),
          child: FloatingActionButton(
            onPressed: onPressed,
            tooltip: tooltip,
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
