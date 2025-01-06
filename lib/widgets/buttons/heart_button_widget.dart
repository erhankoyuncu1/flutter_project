import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/providers/favorite_list_provider.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.bgColor =  Colors.transparent,
    this.iconColor = Colors.red,
    this.size = 20,
    this.label = "",
    required this.productId
  });

  final Color bgColor;
  final Color iconColor;
  final double  size;
  final String label;
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final favoriteListProvider = Provider.of<FavoriteListProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final product = productProvider.findByProductId(widget.productId);

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
            icon: favoriteListProvider.isProductInFavorites(product!.productId) ?
            Icon(IconlyBold.heart,color: widget.iconColor,size: widget.size,):
            Icon(IconlyLight.heart,color: widget.iconColor,size: widget.size,),
            onPressed: (){
              favoriteListProvider.addOrRemoveProduct(product.productId);
            },),
        ],
      )

    );
  }
}
