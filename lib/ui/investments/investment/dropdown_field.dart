import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    required this.label,
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    // Add customizable validator.
    this.validator,
  });

  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? value;

  // Allow passing a custom validator.
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value?.isEmpty == true ? null : value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
