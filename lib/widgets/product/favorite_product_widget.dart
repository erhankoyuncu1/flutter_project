import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/widgets/buttons/cart_button_widget.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../buttons/heart_button_widget.dart';
import '../titles/subtitle_text_widget.dart';
import '../titles/title_text_widget.dart';

class FavoriteProductWidget extends StatelessWidget {
  const FavoriteProductWidget({super.key,
    this.buttonVisibility = false,
    required this.productId
  });
  final String productId;
  final bool buttonVisibility;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);
    final viewedListProvider = Provider.of<ViewedListProvider>(context);

    return FutureBuilder<ProductModel?>(
        future: productProvider.fetchProductByProductId(productId),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    } else if (snapshot.hasError) {
    return Center(child: Text('An error occurred!'));
    } else if (!snapshot.hasData) {
    return Center(child: Text('No product found'));
    } else {
    final product = snapshot.data!;

    return FittedBox(
      child: IntrinsicWidth(
        stepHeight: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async{
                  viewedListProvider.addProduct(productId);
                  await Navigator.pushNamed(context, ProductDetailsWidget.routName,
                    arguments: product.productId,);
                },
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FancyShimmerImage(
                        imageUrl: product!.productImage,
                        height: size.height*0.09,
                        width: size.width*0.2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                        child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end  ,
                                children: [
                                  SizedBox(
                                    width: size.width*0.4,
                                    child: TitleTextWidget(
                                      label: product.productTitle,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.close_sharp,size: 15,),
                                      onPressed:() {
                                        viewedListProvider.removeItem(
                                            product.productId);
                                      }
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SubTitleTextWidget(label: "\$ ${product.productPrice}", color: Colors.green, fontSize: 12,),
                                  Row(
                                    children: [
                                      HeartButtonWidget(productId: product.productId,size: 15,),
                                      CartButtonWidget(productId: productId,size: 15,)
                                    ],
                                  )
                                ],
                              ),
                            ]
                        )
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
});}}
