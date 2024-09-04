import 'package:flutter/material.dart';

class BoolDropdownField extends StatelessWidget {
  final String label;
  final void Function(bool?) onChanged;

  const BoolDropdownField({
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<bool>(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        items: const [
          DropdownMenuItem(
            value: true,
            child: Text('SIM'),
          ),
          DropdownMenuItem(
            value: false,
            child: Text('NÃO'),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
