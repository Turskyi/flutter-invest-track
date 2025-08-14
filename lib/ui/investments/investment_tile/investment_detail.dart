import 'package:flutter/material.dart';

class InvestmentDetail extends StatelessWidget {
  const InvestmentDetail({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              icon,
              size: themeData.textTheme.titleMedium?.fontSize,
              color: valueColor ?? themeData.iconTheme.color,
            ),
            const SizedBox(width: 8),
            Text(label, style: themeData.textTheme.bodyLarge),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: themeData.textTheme.titleSmall?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
