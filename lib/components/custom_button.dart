import 'package:flutter/material.dart';

class CustomBlueButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const CustomBlueButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: Center(
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
      )
    );
  }
}