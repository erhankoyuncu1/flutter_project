import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/viewed_list_model.dart';

class ViewedListProvider with ChangeNotifier {
  final Map<String, ViewedListModel> _viewedListItems = {};

  Map<String, ViewedListModel> get getViewedProducts => _viewedListItems;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> addProduct(String productId) async {
    try {
      final userDoc =
      FirebaseFirestore.instance.collection('users').doc(_userId);

      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) throw Exception('User not found');

      List<dynamic> viewedList = userSnapshot['userViewedList'] ?? [];

      if (!viewedList.contains(productId)) {
        viewedList.add(productId);
        _viewedListItems[productId] = ViewedListModel(productId: productId);

        await userDoc.update({'userViewedList': viewedList});
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error in addProduct: $error');
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      final userDoc =
      FirebaseFirestore.instance.collection('users').doc(_userId);

      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) throw Exception('User not found');

      List<dynamic> viewedList = userSnapshot['userViewedList'] ?? [];

      if (viewedList.contains(productId)) {
        viewedList.remove(productId);
        _viewedListItems.remove(productId);

        await userDoc.update({'userViewedList': viewedList});
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error in removeItem: $error');
    }
  }

  Future<void> clearViewedList() async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(_userId);

      await userDoc.update({'userViewedList': []});

      _viewedListItems.clear();

      notifyListeners();
    } catch (error) {
      debugPrint('Error clearing viewed list: $error');
    }
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> fetchAllViewedProducts() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .snapshots()
        .listen((userDoc) {
      if (userDoc.exists) {
        final List<dynamic> viewedProductIds = userDoc['userViewedList'] ?? [];
        final Map<String, ViewedListModel> loadedViewed = {};
        for (var productId in viewedProductIds) {
          loadedViewed[productId] = ViewedListModel(productId: productId);
        }
        _viewedListItems.clear();
        _viewedListItems.addAll(loadedViewed);
        notifyListeners();
      }
    });
  }
}
