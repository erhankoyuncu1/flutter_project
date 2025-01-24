import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/product_model.dart';
import 'package:flutter_project/services/cloudinary_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductProvider with ChangeNotifier {
  ProductModel? productModel;

  late List<ProductModel> _products = [];

  List<ProductModel> get getProducts => _products;

  Future<void> fetchProducts() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();
      _products = querySnapshot.docs
          .map((doc) => ProductModel(
        productId: doc['productId'] ?? '',
        productTitle: doc['productTitle'] ?? '',
        productPrice: (doc['productPrice'] as num?)?.toDouble() ?? 0.0,
        productCategory: doc['productCategory'] ?? '',
        productDescription: doc['productDescription'] ?? '',
        productImage: doc['productImage'] ?? '',
        productQuantity: (doc['productQuantity'] as num?)?.toDouble() ?? 0.0,
        createdAt: doc['createdAt'] ?? Timestamp.now(),
      ))
          .toList();
      notifyListeners();
    } catch (error) {
      print("Error fetching products: $error");
      rethrow;
    }
  }


  Future<ProductModel?> fetchProductByProductId(String productId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (docSnapshot.exists) {
        return ProductModel(
          productId: docSnapshot['productId'],
          productTitle: docSnapshot['productTitle'],
          productPrice: (docSnapshot['productPrice'] as num).toDouble(),
          productCategory: docSnapshot['productCategory'],
          productDescription: docSnapshot['productDescription'],
          productImage: docSnapshot['productImage'],
          productQuantity: (docSnapshot['productQuantity'] as num).toDouble(),
          createdAt: docSnapshot['createdAt'],
        );
      } else {
        return null;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error in findByProductId: $error");
      rethrow;
    }
  }


  Future<void> addProduct(ProductModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.productId)
          .set({
        'productId': product.productId,
        'productTitle': product.productTitle,
        'productPrice': product.productPrice,
        'productCategory': product.productCategory,
        'productDescription': product.productDescription,
        'productImage': product.productImage,
        'productQuantity': product.productQuantity,
        'createdAt': product.createdAt,
      });
      _products.add(product);
      Fluttertoast.showToast(msg: "${product.productTitle} Product Added",backgroundColor: Colors.green,textColor: Colors.white);
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString(),backgroundColor: Colors.red,textColor: Colors.white);
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(product.productId).update({
        'productTitle': product.productTitle,
        'productPrice': product.productPrice,
        'productCategory': product.productCategory,
        'productDescription': product.productDescription,
        'productImage': product.productImage,
        'productQuantity': product.productQuantity,
        'createdAt': product.createdAt,
      });
      final index = _products.indexWhere((item) => item.productId == product.productId);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      _products.removeWhere((product) => product.productId == productId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }


  List<ProductModel> findByCategory({required String categoryName}) {
    return _products
        .where((product) => product.productCategory.toLowerCase().contains(categoryName.toLowerCase()))
        .toList();
  }

  List<ProductModel> findByProductName({
    required String searchText,
    required List<ProductModel> searchingProductList,
  }) {
    return searchingProductList
        .where((product) => product.productTitle.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  Future<String?> uploadImage(File img) async{
    final cloudinaryService = CloudinaryService();
    String? url;
    try {
      url = await cloudinaryService.uploadImage(img);
      return url;
    }
    catch(err){
      Fluttertoast.showToast(msg: err.toString());
    }
    return null;
  }
}