import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, int> _items = {}; // productId -> quantity

  Map<String, int> get items => _items;

  int get totalItems {
    return _items.values.fold(0, (sum, quantity) => sum + quantity);
  }

  Future<double> get totalPrice async {
    double total = 0.0;

    try {
      for (var productId in _items.keys) {
        final productDoc = await _firestore.collection('products').doc(productId).get();
        if (productDoc.exists) {
          final productData = productDoc.data();
          final price = productData?['productPrice'] ?? 0.0;
          total += price * _items[productId]!;
        }
      }
    } catch (e) {
      debugPrint('Error calculating total price: $e');
    }

    return total;
  }


  Future<void> fetchCartFromFirestore() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final List<dynamic> cartData = userDoc.data()!['userCart'] ?? [];
        _items.clear();
        for (var item in cartData) {
          final productId = item['productId'];
          final quantity = item['quantity'];
          _items[productId] = quantity;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    }
  }

  Future<void> addItem(String productId, int quantity) async {
    if (_items.containsKey(productId)) {
      _items[productId] = _items[productId]! + quantity;
    } else {
      _items[productId] = quantity;
    }
    await _updateFirestoreCart();
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      await _updateFirestoreCart();
      notifyListeners();
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (_items.containsKey(productId)) {
      if (quantity > 0) {
        _items[productId] = quantity;
      } else {
        _items.remove(productId);
      }
      await _updateFirestoreCart();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _updateFirestoreCart();
    notifyListeners();
  }

  Future<void> _updateFirestoreCart() async {
    try {
      final List<Map<String, dynamic>> cartData = _items.entries
          .map((entry) => {
        'productId': entry.key,
        'quantity': entry.value,
      })
          .toList();
      await _firestore.collection('users').doc(userId).update({'userCart': cartData});
    } catch (e) {
      debugPrint('Error updating Firestore cart: $e');
    }
  }

  bool isProductInCart(String productId) {
    return _items.containsKey(productId);
  }
}
