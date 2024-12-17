import 'package:flutter/material.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/root_screen.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'constans/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_){
        return ThemeProvider();
      })
    ],
    child: Consumer<ThemeProvider>(builder:(context, themeProvider, child){
      return MaterialApp(
        title: 'Flutter Project',
        theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
        home:const RootScreen(),
      );

    }),

    );
  }
}
