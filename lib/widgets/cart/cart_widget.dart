import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/widgets/buttons/heart_button_widget.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
import 'package:flutter_project/widgets/quantity_bottom_sheet.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';

class CartWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedListProvider = Provider.of<ViewedListProvider>(context);

    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: InkWell(
        onTap: (){
          viewedListProvider.addProduct(cartItem.product.productId);
          Navigator.pushNamed(context, ProductDetailsWidget.routName,
            arguments: cartItem.product.productId
          );
        },
        child: IntrinsicWidth(
          stepHeight: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FancyShimmerImage(
                    imageUrl: cartItem.product.productImage,
                    height: size.height * 0.09,
                    width: size.width * 0.2,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.4,
                            child: TitleTextWidget(
                              label: cartItem.product.productTitle,
                              fontSize: 16,
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  cartProvider.removeItem(cartItem.product.productId.toString());
                                },
                                icon: const Icon(IconlyLight.closeSquare, size: 20),
                              ),
                              HeartButtonWidget(productId: cartItem.product.productId)
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SubTitleTextWidget(
                            label: "\$${cartItem.product.productPrice.toStringAsFixed(2)}",
                            color: Colors.green,
                          ),
                          //quantity select button
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await showModalBottomSheet(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(40),
                                    bottom: Radius.zero,
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return QuantityBottomSheet(
                                    quantity: cartItem.quantity,
                                    onQuantityChanged: (newQuantity) {
                                      cartProvider.updateQuantity(
                                        cartItem.product.productId.toString(),
                                        newQuantity,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(IconlyLight.arrowDown2),
                            label: Text(
                              "Quantity: ${cartItem.quantity}",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )

    );
  }
}
