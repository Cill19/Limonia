import 'package:flutter/material.dart';

class CustomFitHeightContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomFitHeightContainer({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: Offset(2, 5),
            blurRadius: 20,
          ),
        ],
      ),
      child: child, // Dynamic content
    );
  }
}
