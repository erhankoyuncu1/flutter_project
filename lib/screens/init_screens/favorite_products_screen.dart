import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/widgets/product/favorite_product_widget.dart';
import 'package:flutter_project/widgets/title/app_name_text_widget.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';

class FavoriteProductsScreen extends StatelessWidget {
  static const routName = "/FavoriteProductsScreen";
  const FavoriteProductsScreen({super.key});

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
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
          titleText: "Favorite Products",
        ),
      ),
      body: isEmpty ? Visibility(
        child: EmptyPageWidget(
          imagePath: AssetsManager.noFavoriteProduct,
          subTitle: "Favorite Products is Empty",
          buttonVisibility: false,
          subtitleColor: Color.fromARGB(255, 246, 107, 0,),
          titleColor: Color.fromARGB(255, 246, 107, 0,),
        )
      )
      :ListView.builder(itemBuilder: (context, index){
        return FavoriteProductWidget();
      }),
    );
  }
}
