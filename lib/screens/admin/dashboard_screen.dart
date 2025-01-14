import 'package:flutter/material.dart';
import 'package:flutter_project/models/dashboard_button_model.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:flutter_project/widgets/buttons/dashboard_button_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static const routName = "/DashboardScreen";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.adminDashboard
          ),
        ),
        title: TitleTextWidget(label: "Admin Dashboard",fontSize: 18,fontWeight: FontWeight.w600,),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          DashboardButtonModel.getDashboardButtons(context).length, (index) =>
          DashboardButtonWidget(
            text: DashboardButtonModel.getDashboardButtons(context)[index].text,
            imagePath: DashboardButtonModel.getDashboardButtons(context)[index].imagePath,
            onPressed: DashboardButtonModel.getDashboardButtons(context)[index].onPressed,
          )
        )
      )
    );
  }
}
