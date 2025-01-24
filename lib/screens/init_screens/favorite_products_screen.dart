import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:flutter_project/widgets/product/favorite_product_widget.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../providers/favorite_list_provider.dart';

class FavoriteProductsScreen extends StatefulWidget {
  static const routName = "/FavoriteProductsScreen";
  const FavoriteProductsScreen({super.key});

  @override
  State<FavoriteProductsScreen> createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  bool isLoading = false;

  Future<void> laodProducts() async{
    final favoriteListProvider = Provider.of<FavoriteListProvider>(context,listen:  false);
    setState(() {
      isLoading = true;
    });
    try{
      await favoriteListProvider.fetchAllFavoriteProducts();
    }
    catch(err){
      Fluttertoast.showToast(msg: err.toString());
    }
    finally{
      isLoading = false;
    }
  }

  @override
  void initState() {
    laodProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final favoriteListProvider = Provider.of<FavoriteListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple,size: 28,),
        ),
        title: AppNameText(
          titleText: "Favorite Products (${favoriteListProvider.totalItems})",
        ),
        actions: [
          if (favoriteListProvider.getProducts.isNotEmpty)
            TextButton(
              onPressed: () {
                _showClearConfirmationDialog(context, favoriteListProvider);
              },
              child: const Text(
                "Clear all",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
        ],
      ),
      body: LoadingWidget(
        isLoading: isLoading,
        child: favoriteListProvider.getProducts.isEmpty
            ? EmptyPageWidget(
          imagePath: AssetsManager.noFavoriteProduct,
          subTitle: "Favorite Products is Empty",
          buttonVisibility: false,
          subtitleColor: const Color.fromARGB(255, 246, 107, 0),
          titleColor: const Color.fromARGB(255, 246, 107, 0),
        )
            : DynamicHeightGridView(
          mainAxisSpacing: 15,
          crossAxisCount: 1,
          itemCount: favoriteListProvider.getProducts.length,
          builder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FavoriteProductWidget(
                productId: favoriteListProvider.getProducts.values
                    .toList()[index]
                    .productId,
              ),
            );
          },
        ),
      )
    );
  }

  void _showClearConfirmationDialog(
      BuildContext context, FavoriteListProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear All Favorite Products"),
        content: const Text("Are you sure you want to clear all favorite products?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearFavoriteList();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Clear All",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
