import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/providers/favorite_list_provider.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/user_provider.dart';

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
  String? userId;
  bool isLoading = false;
class _HeartButtonWidgetState extends State<HeartButtonWidget> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteListProvider = Provider.of<FavoriteListProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return FutureBuilder<ProductModel?>(
        future: productProvider.fetchProductByProductId(widget.productId), // Asenkron veri
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
      } else if (snapshot.hasError) {
      return Center(child: Text('An error occurred!'));
      } else if (!snapshot.hasData) {
      return Center(child: Text('No product found'));
      } else {
      final product = snapshot.data!;

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
            icon: favoriteListProvider.isProductFavorite(product!.productId) ?
            Icon(IconlyBold.heart,color: widget.iconColor,size: widget.size,):
            Icon(IconlyLight.heart,color: widget.iconColor,size: widget.size,),
            onPressed: () async {
              await favoriteListProvider.toggleFavorite(productId: product.productId);
            },),
        ],
      )

    );
  }
});}}
