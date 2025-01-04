import 'package:flutter/material.dart';

class SubTitleTextWidget extends StatelessWidget {
  const SubTitleTextWidget({super.key,
    required this.label,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.color,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.center,

  });

  final String label;
  final  double fontSize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: color,
        fontStyle: fontStyle,
      ),
    );
  }
}
