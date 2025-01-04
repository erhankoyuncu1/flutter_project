import 'package:flutter/cupertino.dart';
import 'package:flutter_project/widgets/title/subtitle_text_widget.dart';

class CategoriesWidgets extends StatelessWidget {
  const CategoriesWidgets({
    super.key,
    required this.name,
    required this.imageUrl
  });

  final String name, imageUrl;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imageUrl, height: 50, width: 50,
        ),
        const SizedBox(
          height: 10,
        ),
        SubTitleTextWidget(
          label: name,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )
      ],
    );
  }
}
