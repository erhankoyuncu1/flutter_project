import 'package:flutter/cupertino.dart';
import 'package:flutter_project/models/product_model.dart';

class CartItem with ChangeNotifier {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'quantity': quantity,
    };
  }

  // fromJson metodu da olmalı
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: json['product'],
      quantity: json['quantity'],
    );
  }
}

class CartModel with ChangeNotifier {
  final Map<String, CartItem> items;

  CartModel({required this.items});

  factory CartModel.fromMap(Map<String, dynamic> map) {
    Map<String, CartItem> items = {};
    map.forEach((key, value) {
      items[key] = CartItem.fromMap(value as Map<String, dynamic>);
    });
    return CartModel(items: items);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((key, item) => MapEntry(key, item.toMap())),
    };
  }
}