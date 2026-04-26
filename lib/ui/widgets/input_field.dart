import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.label,
    required this.icon,
    required this.child,
    super.key,
  });

  final String label;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}
