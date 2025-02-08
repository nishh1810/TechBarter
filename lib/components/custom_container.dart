import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color color;
  final Color borderColor;
  final List<BoxShadow>? boxShadow;

  const CustomContainer({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.only(right: 16),
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.color = Colors.white,
    this.borderColor = const Color(0xFFE0E0E0), // Equivalent to grey.shade50
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        boxShadow: boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              spreadRadius: -3,
              blurRadius: 10,
              offset: const Offset(-4, -4),
            ),
          ],
      ),
      child: child,
    );
  }
}
