import 'package:flutter/material.dart';
import 'package:flutter_health/theme.dart';

class MainButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String type;

  const MainButton({
    required this.onPressed,
    required this.text,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: type == '1' ? thirdColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: type == '1' ? thirdColor : Colors.grey,
            width: 1,
          ),
        ),
        width: 200,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: type == '1' ? Colors.white : thirdColor,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
