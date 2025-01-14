import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier{
    final String productId,
    productTitle,
    productCategory,
    productDescription;
    late String productImage;

   final Timestamp createdAt;

   final double productQuantity,
    productPrice;

   ProductModel({
     required this.productId,
     required this.productTitle,
     required this.productPrice,
     required this.productCategory,
     required this.productDescription,
     required this.productImage,
     required this.productQuantity,
     required this.createdAt
   });

    factory ProductModel.fromMap(Map<String, dynamic> map) {
      return ProductModel(
        productId: map['productId'] as String,
        productTitle: map['productTitle'] as String,
        productPrice: map['productPrice'] as double,
        productCategory: map['productCategory'] as String,
        productDescription: map['productDescription'] as String,
        productImage: map['productImage'] as String,
        productQuantity: map['productQuantity'] as double,
        createdAt: map['createdAt'] as Timestamp,
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'productId': productId,
        'productTitle': productTitle,
        'productPrice': productPrice,
        'productCategory': productCategory,
        'productDescription': productDescription,
        'productImage': productImage,
        'productQuantity': productQuantity,
        'createdAt': createdAt,
      };
    }

}