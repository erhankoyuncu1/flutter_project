import 'package:flutter/material.dart';
import 'package:flutter_project/root_screen.dart';
import 'package:flutter_project/widgets/subtitle_text.dart';
import 'package:flutter_project/widgets/title_text.dart';

import '../screens/home_screen.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    super.key,
    required this.imagePath,
    required this.subTitle,
    required this.buttonText,
  });

  final String imagePath, subTitle, buttonText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
            color: Color.fromARGB(255, 255, 183, 40),
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
              ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
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
                ),
              ),
          )

        ]
      ),
    );
  }
}
