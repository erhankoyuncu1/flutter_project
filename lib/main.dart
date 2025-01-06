import 'package:flutter/material.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/providers/favorite_list_provider.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/root_screen.dart';
import 'package:flutter_project/screens/auth/forgot_password_screen.dart';
import 'package:flutter_project/screens/auth/login_screen.dart';
import 'package:flutter_project/screens/auth/register.dart';
import 'package:flutter_project/screens/init_screens/favorite_products_screen.dart';
import 'package:flutter_project/screens/init_screens/viewed_recently_products_screen.dart';
import 'package:flutter_project/screens/orders_screen.dart';
import 'package:flutter_project/screens/search_screen.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
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
      }),
      ChangeNotifierProvider(create: (_){
        return ProductProvider();
      }),
      ChangeNotifierProvider(create: (_){
        return CartProvider();
      }),
      ChangeNotifierProvider(create: (_){
        return FavoriteListProvider();
      }),
      ChangeNotifierProvider(create: (_){
        return ViewedListProvider();
      })
    ],
    child: Consumer<ThemeProvider>(builder:(context, themeProvider, child){
      return MaterialApp(
        title: 'Flutter Project',
        theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
        home:const RootScreen(initialIndex: 0),
        routes: {
          SearchScreen.routName : (context) => const SearchScreen(),
          ProductDetailsWidget.routName : (context) => const ProductDetailsWidget(),
          ViewedRecentlyProductsScreen.routName : (context) => const ViewedRecentlyProductsScreen(),
          OrdersScreen.routName : (context) => const OrdersScreen(),
          FavoriteProductsScreen.routName : (context) => const FavoriteProductsScreen(),
          RegisterScreen.routName : (context) => const RegisterScreen(),
          LoginScreen.routName : (context) => const LoginScreen(),
          ForgetPasswordScreen.routName : (context) => const ForgetPasswordScreen(),
        },
      );

    }),

    );
  }
}
