
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/title_text.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({super.key, this.FontSize = 30});

  final double FontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 12),
      baseColor: Colors.purple,
      highlightColor: Colors.white,
      child: TitleTextWidget(label: "Shopping App", fontSize: 22,),
    );
  }
}
