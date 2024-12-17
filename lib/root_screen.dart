import 'package:flutter/material.dart';
import 'package:flutter_project/screens/cart_screen.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:flutter_project/screens/profile_screen.dart';
import 'package:flutter_project/screens/search_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;

  @override
  void initState(){
    super.initState();

    screens = const [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen()
    ];

    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index){
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home),
              label: "home",
          ),
          NavigationDestination(
              icon: Icon(Icons.search_rounded),
              label: "search",
          ),NavigationDestination(
              icon: Icon(Icons.shopping_cart_rounded),
              label: "cart",
          ),NavigationDestination(
              icon: Icon(Icons.person_rounded),
              label: "profile",
          ),
        ],
      ),
    );
  }
}
