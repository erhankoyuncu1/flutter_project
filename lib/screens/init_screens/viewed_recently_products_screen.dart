import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/widgets/product/favorite_product_widget.dart';
import 'package:flutter_project/widgets/title/app_name_text_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';

class ViewedRecentlyProductsScreen  extends StatelessWidget {
  static const routName = "/ViewedRecentlyProductsScreen";
  const ViewedRecentlyProductsScreen ({super.key});

  final bool isEmpty = false;

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
              icon: const Icon(IconlyLight.arrowLeft2, color: Colors.purple,)),
          title: AppNameText(
            titleText: "Viewed Products",
          ),
        ),
        body: isEmpty ? Visibility(
            visible: isEmpty,
            child: EmptyPageWidget(
              imagePath: AssetsManager.noFavoriteProduct,
              subTitle: "Viewed Products Empty !",
              subtitleColor: Color.fromARGB(255, 246, 107, 0,),
              titleColor: Color.fromARGB(255, 246, 107, 0,),
              buttonVisibility: false,
            )
        ):
        ListView.builder(itemBuilder: (context, index){
          return FavoriteProductWidget();
        }),
    );
  }
}

