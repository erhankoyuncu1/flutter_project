import 'package:flutter/cupertino.dart';
import 'package:flutter_project/screens/admin/all_product_screen.dart';
import 'package:flutter_project/screens/orders_screen.dart';
import 'package:flutter_project/screens/search_screen.dart';
import '../../screens/admin/edit_upload_product_screen.dart';
import '../../services/assets_manager.dart';

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
      ),DashboardButtonModel(
        text: "View Orders",
        imagePath: AssetsManager.orders,
        onPressed: () {
          Navigator.pushNamed(context, OrdersScreen.routName);
        },
      ),
    ];
  }
}
