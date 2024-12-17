import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/title_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: TitleTextWidget(label: "Profile Screen"),
        )
    );
  }
}
