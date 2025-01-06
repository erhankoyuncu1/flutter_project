import 'package:flutter/material.dart';
import 'package:flutter_project/root_screen.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class EmptyPageWidget extends StatelessWidget {
  const EmptyPageWidget({
    super.key,
    required this.imagePath,
    required this.subTitle,
    this.buttonText = "Go Homepage",
    this.buttonBackgroundColor = Colors.transparent,
    this.btnTextColor = Colors.white,
    this.titleColor = Colors.orangeAccent,
    this.subtitleColor = Colors.white,
    this.buttonVisibility = true
  });

  final String imagePath, subTitle, buttonText;
  final Color buttonBackgroundColor, btnTextColor, titleColor, subtitleColor;
  final bool buttonVisibility;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height*0.35,
          ),
          const SizedBox(
            height: 40,
          ),
          TitleTextWidget(
            label: "Whoops",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SubTitleTextWidget(
              label: subTitle,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buttonVisibility ? ElevatedButton(
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RootScreen(initialIndex: 0)),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 209, 36, 36),
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0)
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 18,
                color: btnTextColor,
                backgroundColor: buttonBackgroundColor
              ),
            ),
          )
          :SizedBox.shrink()
        ]
      ),
    );
  }
}
