import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:investtrack/res/constants/constants.dart' as constant;

class BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BlurredAppBar({
    required this.title,
    this.actions = const <Widget>[],
    this.leading,
    super.key,
  });

  final Widget title;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: constant.blurSigma,
            sigmaY: constant.blurSigma,
          ),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
