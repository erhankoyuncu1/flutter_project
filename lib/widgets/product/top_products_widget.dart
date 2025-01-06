import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/product_model.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/widgets/buttons/heart_button_widget.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:provider/provider.dart';

class TopProductsWidget extends StatelessWidget {
  const TopProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () async{
          viewedListProvider.addProduct(productModel.productId);
          await Navigator.pushNamed(
            context,
            ProductDetailsWidget.routName,
            arguments: productModel.productId,
          );
        },
        child: SizedBox(
          width: size.width*0.8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FancyShimmerImage(
                    imageUrl: productModel.productImage,
                    height: size.height*0.1,
                    width: size.width*0.2,
                  ),
                )
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      productModel.productTitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: SubTitleTextWidget(
                        label: "\$ ${productModel.productPrice}",
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(iconColor: Colors.pinkAccent, productId: productModel.productId,),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed: (){
                              cartProvider.addItem(productModel, 1);
                            },
                            icon:cartProvider.isProductInCart(productModel.productId)
                              ? Icon(Icons.check)
                              : Icon(Icons.shopping_cart_outlined,color: Colors.blue,)
                          )
                        ],
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
