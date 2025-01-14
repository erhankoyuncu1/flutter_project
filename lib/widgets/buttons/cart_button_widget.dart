import 'package:flutter/material.dart';
import 'package:flutter_project/models/product_model.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';

class CartButtonWidget extends StatefulWidget {
  const CartButtonWidget({super.key,
    this.bgColor =  Colors.transparent,
    this.iconColor = Colors.blue,
    this.size  = 20,
    this.label = "",
    required this.productId
  });

  final Color bgColor;
  final Color iconColor;
  final double  size;
  final String label;
  final String productId;

  @override
  State<CartButtonWidget> createState() => _CartButtonWidgetState();
}

class _CartButtonWidgetState extends State<CartButtonWidget> {

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final product = productProvider.fetchProductByProductId(widget.productId);

    return Container(
        decoration: BoxDecoration(
          color: widget.bgColor,
          shape: BoxShape.circle,
        ),
        child: Row(
          children: [
            Title(color: Colors.white, child: Text(widget.label)),
            IconButton(
              style: IconButton.styleFrom(
                elevation: 10,
              ),
              icon: cartProvider.isProductInCart(widget.productId) ?
              Icon(Icons.done,color: widget.iconColor,size: widget.size,):
              Icon(Icons.shopping_cart_outlined,color: widget.iconColor,size: widget.size,),
              onPressed: (){
                cartProvider.addItem(product! as ProductModel,1);
              },),
          ],
        )

    );
  }
}
