import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/widgets/product/favorite_product_widget.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyProductsScreen  extends StatelessWidget {
  static const routName = "/ViewedRecentlyProductsScreen";
  const ViewedRecentlyProductsScreen ({super.key});

  @override
  Widget build(BuildContext context) {

    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    return Scaffold (
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(onPressed: (){
            if(Navigator.canPop(context)){
              Navigator.pop(context);
            }
          },
          icon: const Icon(IconlyLight.arrowLeft2, color: Colors.purple,)),
          title: AppNameText(
            titleText: "Viewed Products",
          ),
          actions: [
            viewedListProvider.getViewedProducts.isNotEmpty ?
            TextButton(
              onPressed: (){
                viewedListProvider.clearFavoriteList();
              },
              child: Text(
                "Clear all",
                style: TextStyle(
                  color: Colors.red
                ),
              )
            ): SizedBox.shrink()
          ],
        ),
        body: viewedListProvider.getViewedProducts.isEmpty ?
        Visibility(
          child: EmptyPageWidget(
            imagePath: AssetsManager.noFavoriteProduct,
            subTitle: "Viewed Products Empty !",
            subtitleColor: Color.fromARGB(255, 246, 107, 0,),
            titleColor: Color.fromARGB(255, 246, 107, 0,),
            buttonVisibility: false,
          )
        ):
        DynamicHeightGridView(
          mainAxisSpacing: 15,
          crossAxisCount: 1,
          itemCount: viewedListProvider.getViewedProducts.length,
          builder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FavoriteProductWidget(
                productId: viewedListProvider.getViewedProducts.values.toList()[index].productId,
                buttonVisibility: true
              ),
            );
          },
        ),
    );
  }
}

