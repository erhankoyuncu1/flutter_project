import 'package:flutter/material.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/screens/cart/cart_screen.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:flutter_project/screens/profile_screen.dart';
import 'package:flutter_project/screens/search_screen.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  static const routName = "/RootScreen";
  final int initialIndex;
  const RootScreen({super.key, this.initialIndex = 0});

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

    currentScreen = widget.initialIndex;
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
    final cartProvider = Provider.of<CartProvider>(context);
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
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.home),
              label: "home",
          ),
          NavigationDestination(
              icon: Icon(Icons.search_rounded),
              label: "search",
          ),NavigationDestination(
            icon: Badge(
              isLabelVisible: cartProvider.totalItems > 0,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              label: Text("${cartProvider.totalItems}"),
              child: Icon(Icons.shopping_bag),
            ),
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
