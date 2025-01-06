import 'package:flutter/cupertino.dart';
import 'package:flutter_project/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}

class CartModel  with ChangeNotifier{
  final Map<String, CartItem> items;

  CartModel({required this.items});
}
