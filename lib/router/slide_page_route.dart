import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  SlidePageRoute({required this.page})
    : super(
        pageBuilder:
            (BuildContext _, Animation<double> _, Animation<double> _) {
              return page;
            },
        transitionsBuilder:
            (
              BuildContext _,
              Animation<double> animation,
              Animation<double> _,
              Widget child,
            ) {
              const Offset begin = Offset(1.0, 0.0);
              const Offset end = Offset.zero;
              const Curve curve = Curves.easeInOut;

              final Animatable<Offset> tween = Tween<Offset>(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              final Animation<Offset> offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
      );
  final Widget page;
}
