import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/widgets/product/favorite_product_widget.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';

class ViewedRecentlyProductsScreen extends StatefulWidget {
  static const routName = "/ViewedRecentlyProductsScreen";
  const ViewedRecentlyProductsScreen({super.key});

  @override
  _ViewedRecentlyProductsScreenState createState() => _ViewedRecentlyProductsScreenState();
}

class _ViewedRecentlyProductsScreenState extends State<ViewedRecentlyProductsScreen> {
  bool isLoading = false;

  Future<void> loadProducts() async{
    final   viewedListProvider = Provider.of<ViewedListProvider>(context,listen:  false);
    setState(() {
      isLoading = true;
    });
    try{
      await viewedListProvider.fetchAllViewedProducts();
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
    loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewedListProvider = Provider.of<ViewedListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            IconlyLight.arrowLeft2,
            color: Colors.purple,
          ),
        ),
        title: const AppNameText(
          titleText: "Viewed Products",
        ),
        actions: [
          if (viewedListProvider.getViewedProducts.isNotEmpty)
            TextButton(
              onPressed: () {
                _showClearConfirmationDialog(context, viewedListProvider);
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
      body: viewedListProvider.getViewedProducts.isEmpty
          ? Center(
        child: EmptyPageWidget(
          imagePath: AssetsManager.noFavoriteProduct,
          subTitle: "Viewed Products Empty!",
          subtitleColor: Colors.orange,
          titleColor: Colors.orange,
          buttonVisibility: false,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: DynamicHeightGridView(
          mainAxisSpacing: 15,
          crossAxisCount: 1,
          itemCount: viewedListProvider.getViewedProducts.length,
          builder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FavoriteProductWidget(
                productId: viewedListProvider.getViewedProducts.values
                    .toList()[index]
                    .productId,
                buttonVisibility: true,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showClearConfirmationDialog(
      BuildContext context, ViewedListProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear All Viewed Products"),
        content: const Text("Are you sure you want to clear all viewed products?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearViewedList();
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
