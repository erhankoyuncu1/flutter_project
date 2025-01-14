import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/app_functions.dart';

class FavoriteListProvider with ChangeNotifier {
  List<String> _favoriteList = [];
  User? user = FirebaseAuth.instance.currentUser;

  late String? _currentUserId = user!.uid;

  List<String> get favoriteList => _favoriteList;
  int get totalItemsCount => _favoriteList.length;

  /// Kullanıcının favori listesini Firestore'dan yükler
  Future<void> loadFavoriteList({
    required String userId,
    required BuildContext context,
  }) async {
    if (userId.isEmpty) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "User ID is empty. Cannot load favorite list.",
        function: (){}
      );
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          _favoriteList = List<String>.from(userData['userFavoriteList'] ?? []);
        }
      }
    } catch (e) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Error loading favorite list: $e",
        function: (){}
      );
    }

    notifyListeners();
  }

  /// Bir ürünü favori listesine ekler veya çıkarır
  Future<void> toggleFavorite({
    required String productId,
  }) async {
    if (_currentUserId!.isEmpty) {
      Fluttertoast.showToast(msg: "Current user ID is empty. Cannot toggle favorite.");
      return;
    }

    try {
      if (_favoriteList.contains(productId)) {
        _favoriteList.remove(productId);
      } else {
        _favoriteList.add(productId);
      }

      await FirebaseFirestore.instance.collection('users').doc(_currentUserId).update({
        'userFavoriteList': _favoriteList,
      });

      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error toggling favorite: $e");
    }
  }

  /// Favori listesinde ürünün olup olmadığını kontrol eder
  bool isProductFavorite(String productId) {
    return _favoriteList.contains(productId);
  }

  /// Favori listesini temizler
  Future<void> clearFavoriteList(BuildContext context) async {
    if (_currentUserId!.isEmpty) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Current user ID is empty. Cannot clear favorite list.",
        function: (){}
      );
      return;
    }

    try {
      _favoriteList.clear();

      await FirebaseFirestore.instance.collection('users').doc(_currentUserId).update({
        'userFavoriteList': _favoriteList,
      });

      notifyListeners();
    } catch (e) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Error clearing favorite list: $e",
        function: (){}
      );
    }
  }
}
