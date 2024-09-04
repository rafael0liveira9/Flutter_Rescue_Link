import 'package:flutter/material.dart';

class BuildDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final void Function(DateTime?) onDateChanged;
  final String label;

  const BuildDatePicker({
    required this.selectedDate,
    required this.onDateChanged,
    required this.label,
    super.key,
  });

  @override
  State<BuildDatePicker> createState() => _BuildDatePickerState();
}

class _BuildDatePickerState extends State<BuildDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          widget.label,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(193, 54, 53, 53),
              fontSize: 15),
        ),
        subtitle: Text(
          widget.selectedDate != null
              ? '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}'
              : 'Selecione uma data',
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 54, 53, 53),
              fontSize: 13),
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: widget.selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null && picked != widget.selectedDate) {
            widget.onDateChanged(picked);
          }
        },
      ),
    );
  }
}
