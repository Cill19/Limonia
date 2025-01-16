import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final String fontFamily;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize = 16.0,
    this.color = Colors.black,
    this.fontFamily = 'Poppins',
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}
