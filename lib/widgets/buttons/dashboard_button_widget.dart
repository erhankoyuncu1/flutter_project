import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';

class DashboardButtonWidget extends StatelessWidget {
  const DashboardButtonWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onPressed
  });

  final String text, imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              SubTitleTextWidget(label: text)
            ],
          ),
        ),
      ),
    );
  }
}
