
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({
    super.key,
    this.fontSize = 30,
    this.titleText="Shopping App",
    this.titleColor = Colors.purple,
    this.fontWeight = FontWeight.w600
  });

  final double fontSize;
  final String titleText;
  final FontWeight fontWeight;
  final MaterialColor titleColor;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 12),
      baseColor: titleColor,
      highlightColor: Colors.white,
      child: TitleTextWidget(label: titleText, fontSize: 22, fontWeight: fontWeight)
    );
  }
}
