import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/screens/admin/all_orders_screen.dart';
import 'package:flutter_project/screens/admin/all_product_screen.dart';
import 'package:flutter_project/screens/admin/all_users_screen.dart';
import 'package:flutter_project/screens/admin/edit_upload_user_screen.dart';
import 'package:flutter_project/screens/auth/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../screens/admin/edit_upload_product_screen.dart';
import '../../services/assets_manager.dart';
import '../services/app_functions.dart';

class DashboardButtonModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonModel> getDashboardButtons(BuildContext context) {
    return [
      DashboardButtonModel(
        text: "Add new product",
        imagePath: AssetsManager.addNewProduct,
        onPressed: () {
          Navigator.pushNamed(context, EditUploadProductScreen.routName);
        },
      ),
      DashboardButtonModel(
        text: "All products",
        imagePath: AssetsManager.allProducts,
        onPressed: () {
          Navigator.pushNamed(context, AllProductScreen.routName);
        },
      ),
      DashboardButtonModel(
        text: "View Orders",
        imagePath: AssetsManager.orders,
        onPressed: () {
          Navigator.pushNamed(context, AllOrdersScreen.routName);
        },
      ),
      DashboardButtonModel(
        text: "Users",
        imagePath: AssetsManager.user512,
        onPressed: () {
          Navigator.pushNamed(context, AllUsersScreen.routName);
        },
      ),
      DashboardButtonModel(
        text: "Add new User",
        imagePath: AssetsManager.user512,
        onPressed: () {
          Navigator.pushNamed(context, EditUploadUserScreen.routName);
        },
      ),
      DashboardButtonModel(
        text: "Log out",
        imagePath: AssetsManager.logout,
        onPressed: () async{
          await AppFunctions.showErrorOrWarningDialog(
            context: context,
            subtitle: "Are you sure ?",
            function: () async {
              try{
                await  FirebaseAuth.instance.signOut();
                Fluttertoast.showToast(msg: "Sign out successful");
                Navigator.pushNamed(context, LoginScreen.routName);
              }
              catch(error){
                Fluttertoast.showToast(msg: "Sign out failed");
              }
            }
          );
        },
      ),
    ];
  }
}
