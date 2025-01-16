import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/favorite_list_model.dart';

class FavoriteListProvider with ChangeNotifier {
  final Map<String, FavoritelistModel> _favoriteListItems = {};

  Map<String, FavoritelistModel> get getProducts => _favoriteListItems;

  String? _userId = FirebaseAuth.instance.currentUser?.uid;

  int get totalItems {
    return _favoriteListItems.length;
  }

  void isUserLoggedIn() {
    if (_userId == null) {
      Fluttertoast.showToast(
          msg: "Please login first.!",
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
      return; // Eğer kullanıcı giriş yapmamışsa işlemi durduruyoruz
    }
  }

  Future<void> addOrRemoveProduct(String productId) async {
    // Giriş yapılmamışsa işlem yapma
    isUserLoggedIn();
    if (_userId == null) return;  // Giriş yapılmamışsa işlemi burada durduruyoruz

    try {
      final DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(_userId);

      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        throw Exception('User not found');
      }

      List<dynamic> favoriteList = userSnapshot['userFavoriteList'] ?? [];

      if (favoriteList.contains(productId)) {
        // Remove product from Firestore
        favoriteList.remove(productId);
        _favoriteListItems.remove(productId);
      } else {
        // Add product to Firestore
        favoriteList.add(productId);
        _favoriteListItems.putIfAbsent(
          productId,
              () => FavoritelistModel(productId: productId),
        );
      }

      await userDoc.update({'userFavoriteList': favoriteList});
      notifyListeners();
    } catch (error) {
      debugPrint('Error in addOrRemoveProduct: $error');
    }
  }

  Future<void> removeItem(String productId) async {
    // Giriş yapılmamışsa işlem yapma
    isUserLoggedIn();
    if (_userId == null) return;  // Giriş yapılmamışsa işlemi burada durduruyoruz

    try {
      final DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(_userId);

      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        throw Exception('User not found');
      }

      List<dynamic> favoriteList = userSnapshot['userFavoriteList'] ?? [];

      if (favoriteList.contains(productId)) {
        favoriteList.remove(productId);
        _favoriteListItems.remove(productId);

        await userDoc.update({'userFavoriteList': favoriteList});
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error in removeItem: $error');
    }
  }

  bool isProductInFavorites(String productId) {
    return _favoriteListItems.containsKey(productId);
  }

  void clearFavoriteList() {
    _favoriteListItems.clear();
    notifyListeners();
  }

  Future<void> fetchAllFavoriteProducts() async {
    // Giriş yapılmamışsa işlem yapma
    isUserLoggedIn();
    if (_userId == null) return;  // Giriş yapılmamışsa işlemi burada durduruyoruz

    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        final List<dynamic> favoriteProductIds = userDoc['userFavoriteList'] ?? [];

        final Map<String, FavoritelistModel> loadedFavorites = {};

        for (var productId in favoriteProductIds) {
          loadedFavorites[productId] = FavoritelistModel(productId: productId);
        }

        _favoriteListItems.clear();
        _favoriteListItems.addAll(loadedFavorites);
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error fetching favorite products: $error');
    }
  }
}
