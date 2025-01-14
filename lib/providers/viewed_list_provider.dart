  import 'package:flutter/material.dart';
  import 'package:flutter_project/models/viewed_list_model.dart';
  import 'package:uuid/uuid.dart';

  class ViewedListProvider with ChangeNotifier {
    final Map<String, ViewedListModel> _viewedListItems = {};

    Map<String, ViewedListModel> get getViewedProducts => _viewedListItems;

    int get totalItems {
      return _viewedListItems.length;
    }

    void addProduct(String productId)  async{
      if (_viewedListItems.containsKey(productId)) {
        return;
      } else {
        _viewedListItems.putIfAbsent(productId, () => ViewedListModel(
          viewedListId: const Uuid().v4(), productId: productId)
        );
      }
      notifyListeners();
    }

    void removeItem(String productId) {
      _viewedListItems.remove(productId);
      notifyListeners();
    }

    bool isProductInFavorites(String productId) {
      return _viewedListItems.containsKey(productId);
    }

    void clearFavoriteList() {
      _viewedListItems.clear();
      notifyListeners();
    }
  }
