import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/providers/favorite_list_provider.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/theme_provider.dart';

class ProductDetailsWidget extends StatefulWidget {
  static const routName = "/ProductDetailsSecreen";
  const ProductDetailsWidget({super.key});

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoriteProductProvider = Provider.of<FavoriteListProvider>(context);

    String? productId = ModalRoute.of(context)!.settings.arguments as String?;

    return FutureBuilder<ProductModel?>(
        future: productProvider.fetchProductByProductId(productId!),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    } else if (snapshot.hasError) {
    return Center(child: Text('An error occurred!'));
    } else if (!snapshot.hasData) {
    return Center(child: Text('No product found'));
    } else {
    final product = snapshot.data!;

    final bool  isAdded = cartProvider.isProductInCart(product!.productId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
        icon: const Icon(IconlyLight.arrowLeft2)),
        title: AppNameText(),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: FancyShimmerImage(
                alignment: Alignment.center,
                imageUrl: product.productImage,
                height: size.height*0.25,
                width: size.width,
                errorWidget: Icon(Icons.broken_image, size: 50),
                boxDecoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                )
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start  ,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(product.productTitle,
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                color: Colors.green
                            ),
                          ),
                        )
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: SubTitleTextWidget(
                          label: "\$ ${product.productPrice}",
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                iconColor: Colors.white
                              ),
                              icon: favoriteProductProvider.isProductFavorite(product.productId) ? Icon(IconlyBold.heart) : Icon(IconlyLight.heart),
                              label:
                                Text(favoriteProductProvider.isProductFavorite(product.productId) ? "Favorite" : "Add to favorites",
                                  style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              onPressed: (){
                                favoriteProductProvider.toggleFavorite(productId: product.productId);
                              },
                            ),
                          )
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                iconColor: Colors.white
                              ),
                              icon: isAdded ?
                                Icon(Icons.check) :
                                Icon(Icons.shopping_cart_outlined),
                              label:
                                Text( isAdded ?
                                  "Product added"
                                  :"Add to cart",
                                  style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              onPressed: (){
                                cartProvider.addItem(product, 1);
                              },
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleTextWidget(label: "Product Category",fontSize: 14,),
                        SubTitleTextWidget(label: product.productCategory),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child:  SubTitleTextWidget(
                      label: product.productDescription,
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
});}}
