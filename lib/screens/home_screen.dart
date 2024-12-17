import 'package:flutter/material.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

import '../widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TitleTextWidget(
              label:"Hello World",
              fontWeight: FontWeight.bold,
            ),
            const SubTitleTextWidget(
              label:"Hello World",
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Hello World",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            SwitchListTile(
              title: Text(themeProvider.getIsDarkTheme ? "Dark Mode": "Light Mode"),
                value: themeProvider.getIsDarkTheme,
                onChanged: (value){
                  themeProvider.setDarkTheme(themeValue: value);
                })
          ],
        ),

      )
    );
  }
}
