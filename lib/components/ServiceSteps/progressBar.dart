import 'package:flutter/material.dart';
import 'package:flutter_health/theme.dart';

class ProgressBar extends StatelessWidget {
  final int progress;

  const ProgressBar({
    required this.progress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            height: 4,
            decoration: BoxDecoration(
              color: index < progress ? thirdColor : Colors.grey[300],
            ),
          ),
        );
      }),
    );
  }
}
