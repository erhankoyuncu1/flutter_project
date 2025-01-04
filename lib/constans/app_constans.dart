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
    CategoryModel(id: "Phone", name: "Phone", imageUrl: AssetsManager.phone),
    CategoryModel(id: "Computer", name: "Computer", imageUrl: AssetsManager.computer),
    CategoryModel(id: "shoes", name: "shoes", imageUrl: AssetsManager.shoes),
    CategoryModel(id: "books", name: "books", imageUrl: AssetsManager.bagImg2),
    CategoryModel(id: "flowers", name: "flowers", imageUrl: AssetsManager.flower),
    CategoryModel(id: "t-shorts", name: "t-shorts", imageUrl: AssetsManager.tshort),
    CategoryModel(id: "watch", name: "watch", imageUrl: AssetsManager.watch)
  ];
}