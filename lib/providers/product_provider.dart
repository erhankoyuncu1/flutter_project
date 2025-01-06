import 'package:flutter/material.dart';
import 'package:flutter_project/models/product_model.dart';

class ProductProvider with ChangeNotifier{
  List<ProductModel> get getProducts{
    return products;
  }

  ProductModel ? findByProductId(String productId) {
    if(products.where((product) => product.productId == productId).isEmpty){
      return null;
    }
    return products.firstWhere((product) => product.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    List<ProductModel> categoryList = products.where((product) =>
        product.productCategory.toLowerCase()
          .contains(categoryName.toLowerCase())).toList();
    return categoryList;
  }

  List<ProductModel> findByProductName({required String searchText,
    required List<ProductModel> searchingProductList
  }) {
    List<ProductModel> productList = searchingProductList.where((product) =>
      product.productTitle.toLowerCase()
        .contains(searchText.toLowerCase())).toList();
    return productList;
  }



  List<ProductModel> products = [
    ProductModel(
      productId: "1",
      productTitle: "Electronics",
      productPrice: 29.99,
      productCategory: "Electronics",
      productDescription: "A reliable wireless mouse with ergonomic design.",
      productImage: "https://images.pexels.com/photos/392018/pexels-photo-392018.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 100,
    ),
    ProductModel(
      productId: "2",
      productTitle: "Bluetooth Headphones",
      productPrice: 59.99,
      productCategory: "Electronics",
      productDescription: "High-quality headphones with noise-cancellation.",
      productImage: "https://images.pexels.com/photos/6889216/pexels-photo-6889216.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 50,
    ),
    ProductModel(
      productId:"3",
      productTitle: "Smartphone Stand",
      productPrice: 15.99,
      productCategory: "Accessories",
      productDescription: "Adjustable stand for all smartphone sizes.",
      productImage: "https://images.pexels.com/photos/19238584/pexels-photo-19238584/free-photo-of-magsafe-i-phone-standi-oakywood.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 200,
    ),
    ProductModel(
      productId: "4",
      productTitle: "LED Desk Lamp",
      productPrice: 39.99,
      productCategory: "Electronics",
      productDescription: "A sleek LED desk lamp with adjustable brightness.",
      productImage: "https://images.pexels.com/photos/5400775/pexels-photo-5400775.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 120,
    ),
    ProductModel(
      productId: "5",
      productTitle: "Gaming Keyboard",
      productPrice: 79.99,
      productCategory: "Electronics",
      productDescription: "Mechanical gaming keyboard with RGB lighting.",
      productImage: "https://images.pexels.com/photos/2115257/pexels-photo-2115257.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 80,
    ),
    ProductModel(
      productId: "6",
      productTitle: "Coffee Mug",
      productPrice: 9.99,
      productCategory: "Kitchen",
      productDescription: "Durable ceramic mug with a modern design.",
      productImage: "https://images.pexels.com/photos/17555891/pexels-photo-17555891/free-photo-of-plaka-tabak-kupa-fincanlar.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 300,
    ),
    ProductModel(
      productId: "7",
      productTitle: "Running Shoes",
      productPrice: 49.99,
      productCategory: "Shoes",
      productDescription: "Comfortable and lightweight running shoes.",
      productImage: "https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 70,
    ),
    ProductModel(
      productId: "8",
      productTitle: "Electric Kettle",
      productPrice: 24.99,
      productCategory: "Kitchen",
      productDescription: "Fast-boil electric kettle with auto shut-off.",
      productImage: "https://images.pexels.com/photos/4108671/pexels-photo-4108671.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 150,
    ),
    ProductModel(
      productId: "9",
      productTitle: "Yoga Mat",
      productPrice: 19.99,
      productCategory: "Sports",
      productDescription: "Non-slip yoga mat with extra cushioning.",
      productImage: "https://images.pexels.com/photos/4325462/pexels-photo-4325462.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 90,
    ),
    ProductModel(
      productId: "10",
      productTitle: "Laptop Backpack",
      productPrice: 45.99,
      productCategory: "Accessories",
      productDescription: "Water-resistant backpack with multiple compartments.",
      productImage: "https://images.pexels.com/photos/3731256/pexels-photo-3731256.jpeg?auto=compress&cs=tinysrgb&w=400",
      productQuantity: 60,
    ),
  ];

}