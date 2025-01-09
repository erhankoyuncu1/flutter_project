import 'package:flutter/material.dart';
import 'package:flutter_project/models/category_model.dart';
import 'package:flutter_project/services/assets_manager.dart';

class AppConstans {
  static const String imageUrl = "http://192.168.96.139:8000/images/categories/computer4.png";

  static List<String> bannerImages = [
    AssetsManager.slide1,
    AssetsManager.slide2,
    AssetsManager.slide3,
    AssetsManager.slide4,
    AssetsManager.slide5,
    AssetsManager.slide6,
    AssetsManager.slide7
  ];

  static List<CategoryModel> categories = [
    CategoryModel(id: "phone", name: "Phone", imageUrl: AssetsManager.phone),
    CategoryModel(id: "electronics", name: "Electronics", imageUrl: AssetsManager.computer),
    CategoryModel(id: "shoes", name: "Shoes", imageUrl: AssetsManager.shoes),
    CategoryModel(id: "books", name: "Books", imageUrl: AssetsManager.bagImg2),
    CategoryModel(id: "kitchen", name: "Kitchen", imageUrl: AssetsManager.flower),
    CategoryModel(id: "clothes", name: "Clothes", imageUrl: AssetsManager.tshort),
    CategoryModel(id: "accessories", name: "Accessories", imageUrl: AssetsManager.watch),
    CategoryModel(id: "sport", name: "Sport", imageUrl: AssetsManager.sportCategory),

  ];

  static List<String> categoryList = [
    "Phone",
    "Electronics",
    "Shoes",
    "Books",
    "Kitchen",
    "Clothes",
    "Accessories",
    "Sport",
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
      List<DropdownMenuItem<String>>.generate(categoryList.length, (index) =>
          DropdownMenuItem(
            value: categoryList[index],
            child: Text(categoryList[index])
          )
      );
    return menuItem;
  }
}