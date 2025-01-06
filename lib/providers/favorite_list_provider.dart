import 'package:flutter/material.dart';
import 'package:flutter_project/models/favorite_list_model.dart';
import 'package:uuid/uuid.dart';

class FavoriteListProvider with ChangeNotifier {
  final Map<String, FavoritelistModel> _favoriteListItems = {};

  Map<String, FavoritelistModel> get getProducts => _favoriteListItems;

  int get totalItems {
    return _favoriteListItems.length;
  }

  void addOrRemoveProduct(String productId) {
    if (_favoriteListItems.containsKey(productId)) {
      _favoriteListItems.remove(productId);
    } else {
      _favoriteListItems.putIfAbsent(productId, () => FavoritelistModel(
        favoritelistId: const Uuid().v4(), productId: productId)
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _favoriteListItems.remove(productId);
    notifyListeners();
  }

  bool isProductInFavorites(String productId) {
    return _favoriteListItems.containsKey(productId);
  }

  void clearFavoriteList() {
    _favoriteListItems.clear();
    notifyListeners();
  }
}
