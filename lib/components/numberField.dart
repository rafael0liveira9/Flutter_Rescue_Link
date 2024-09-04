import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const BuildNumberField({
    required this.controller,
    required this.label,
    super.key,
  });

  @override
  State<BuildNumberField> createState() => _BuildNumberFieldState();
}

class _BuildNumberFieldState extends State<BuildNumberField> {
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
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          labelText: widget.label,
        ),
      ),
    );
  }
}
