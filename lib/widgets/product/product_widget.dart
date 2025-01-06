import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/widgets/buttons/heart_button_widget.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:provider/provider.dart';
import '../titles/title_text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    final product = productProvider.findByProductId(widget.productId);

    return product == null
        ? SizedBox.shrink()
        : Padding(
      padding: EdgeInsets.all(1.0),
      child: GestureDetector(
        onTap: () async {
          viewedListProvider.addProduct(product.productId);
          await Navigator.pushNamed(
            context,
            ProductDetailsWidget.routName,
            arguments: product.productId,
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(
                imageUrl: product.productImage,
                height: size.height * 0.2,
                width: size.width * 0.2,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: TitleTextWidget(label: product.productTitle),
                  ),
                  Flexible(
                    flex: 2,
                    child: HeartButtonWidget(iconColor: Colors.red,productId: product.productId,),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: SubTitleTextWidget(
                      label: "price: \$${product.productPrice}",
                      color: Colors.green,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () {
                          cartProvider.addItem(product, 1);
                        },
                        child:  Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            cartProvider.isProductInCart(product.productId) ?
                                Icons.check
                                :Icons.shopping_cart_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
