import 'package:flutter/material.dart';

class SupportChannel extends StatelessWidget {
  const SupportChannel({
    required this.icon,
    required this.label,
    required this.action,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: colors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(action, style: TextStyle(color: colors.primary)),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: onTap,
      ),
    );
  }
}
