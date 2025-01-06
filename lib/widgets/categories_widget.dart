import 'package:flutter/cupertino.dart';
import 'package:flutter_project/screens/search_screen.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';

class CategoriesWidgets extends StatelessWidget {
  const CategoriesWidgets({
    super.key,
    required this.name,
    required this.imageUrl
  });

  final String name, imageUrl;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, SearchScreen.routName, arguments: name);
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
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
      )
    );


  }
}
