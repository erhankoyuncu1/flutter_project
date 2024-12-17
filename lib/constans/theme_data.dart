import 'package:flutter/material.dart';
import 'app_colors.dart';

class Styles {
  static ThemeData themeData(
    {required bool isDarkTheme, required BuildContext context}){
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,
      cardColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light);
  }
}