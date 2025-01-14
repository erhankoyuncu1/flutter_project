import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/widgets/product/favorite_product_widget.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:provider/provider.dart';

import '../../providers/favorite_list_provider.dart';

class FavoriteProductsScreen extends StatelessWidget {
  static const routName = "/FavoriteProductsScreen";
  const FavoriteProductsScreen({super.key});

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final favoriteListProvider = Provider.of<FavoriteListProvider>(context);

    return Scaffold (
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
            icon: const Icon(IconlyLight.arrowLeft2)),
        title: AppNameText(
          titleText: "Favorite Products (${favoriteListProvider.totalItemsCount})",
        ),
      ),
      body: favoriteListProvider.favoriteList.isEmpty ? Visibility(
        child: EmptyPageWidget(
          imagePath: AssetsManager.noFavoriteProduct,
          subTitle: "Favorite Products is Empty",
          buttonVisibility: false,
          subtitleColor: Color.fromARGB(255, 246, 107, 0,),
          titleColor: Color.fromARGB(255, 246, 107, 0,),
        )
      )
      :DynamicHeightGridView(
        mainAxisSpacing: 15,
        crossAxisCount: 1,
        itemCount: favoriteListProvider.totalItemsCount,
        builder: (context, index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FavoriteProductWidget(productId: favoriteListProvider.favoriteList[index]),
          );
        },
      ),
    );
  }
}
