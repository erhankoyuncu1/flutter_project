import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier{
   final String productId,
    productTitle,
    productCategory,
    productDescription,
    productImage;

   final double productQuantity,
    productPrice;

   ProductModel({
     required this.productId,
     required this.productTitle,
     required this.productPrice,
     required this.productCategory,
     required this.productDescription,
     required this.productImage,
     required this.productQuantity
   });

}