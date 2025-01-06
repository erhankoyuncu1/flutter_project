import 'package:flutter/material.dart';
import 'package:flutter_project/models/cart_model.dart';
import 'package:flutter_project/models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get totalItems {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.values
        .fold(0.0, (sum, item) => sum + (item.product.productPrice * item.quantity));
  }

  void addItem(ProductModel product, int quantity) {
    if (_items.containsKey(product.productId.toString())) {
      _items[product.productId.toString()] = CartItem(
        product: product,
        quantity: _items[product.productId.toString()]!.quantity + quantity,
      );
    } else {
      _items[product.productId.toString()] =
          CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  bool isProductInCart(String productId) {
    return items.containsKey(productId);
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      _items[productId] = CartItem(
        product: _items[productId]!.product,
        quantity: quantity,
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
