import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/providers/address_provider.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/providers/favorite_list_provider.dart';
import 'package:flutter_project/providers/order_provider.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/root_screen.dart';
import 'package:flutter_project/screens/admin/all_orders_screen.dart';
import 'package:flutter_project/screens/admin/all_product_screen.dart';
import 'package:flutter_project/screens/admin/all_users_screen.dart';
import 'package:flutter_project/screens/admin/dashboard_screen.dart';
import 'package:flutter_project/screens/admin/edit_order_screen.dart';
import 'package:flutter_project/screens/admin/edit_upload_product_screen.dart';
import 'package:flutter_project/screens/admin/edit_upload_user_screen.dart';
import 'package:flutter_project/screens/auth/forgot_password_screen.dart';
import 'package:flutter_project/screens/auth/login_screen.dart';
import 'package:flutter_project/screens/auth/register.dart';
import 'package:flutter_project/screens/init_screens/addresses_screen.dart';
import 'package:flutter_project/screens/init_screens/favorite_products_screen.dart';
import 'package:flutter_project/screens/init_screens/viewed_recently_products_screen.dart';
import 'package:flutter_project/screens/order/order_creation_screen.dart';
import 'package:flutter_project/screens/order/order_details_screen.dart';
import 'package:flutter_project/screens/orders_screen.dart';
import 'package:flutter_project/screens/search_screen.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
import 'package:provider/provider.dart';

import 'constans/theme_data.dart';
import 'firebase_options.dart';
import 'models/order_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      }),
      ChangeNotifierProvider(create: (_){
        return UserProvider();
      }),
      ChangeNotifierProvider(create: (_){
        return AddressProvider();
      }),
      ChangeNotifierProvider(create: (_){
        return OrderProvider();
      })
    ],
    child: Consumer<ThemeProvider>(builder:(context, themeProvider, child){
      return MaterialApp(
        title: 'Shopping App',
        theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
        home:LoginScreen(),
        routes: {
          RootScreen.routName : (context) => const RootScreen(initialIndex: 0),
          DashboardScreen.routName : (context) => const DashboardScreen(),
          SearchScreen.routName : (context) => const SearchScreen(),
          ProductDetailsWidget.routName : (context) => const ProductDetailsWidget(),
          ViewedRecentlyProductsScreen.routName : (context) => const ViewedRecentlyProductsScreen(),
          OrdersScreen.routName : (context) => const OrdersScreen(),
          FavoriteProductsScreen.routName : (context) => const FavoriteProductsScreen(),
          AddressesScreen.routName : (context) => const AddressesScreen(),
          RegisterScreen.routName : (context) => const RegisterScreen(),
          LoginScreen.routName : (context) => const LoginScreen(),
          ForgetPasswordScreen.routName : (context) => const ForgetPasswordScreen(),
          AllProductScreen.routName : (context) => const AllProductScreen(),
          EditUploadProductScreen.routName : (context) => const EditUploadProductScreen(),
          AllUsersScreen.routName : (context) => const AllUsersScreen(),
          EditUploadUserScreen.routName : (context) => const  EditUploadUserScreen(),
          OrderCreationScreen.routName : (context) => const  OrderCreationScreen(),
          AllOrdersScreen.routName : (context) => const  AllOrdersScreen(),
          EditOrderScreen.routName : (context) => const  EditOrderScreen(),
          OrderDetailsScreen.routName : (context) => const  OrderDetailsScreen(),
        },
      );

    }),

    );
  }
}
