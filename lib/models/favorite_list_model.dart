import 'package:flutter/cupertino.dart';

class FavoritelistModel with ChangeNotifier {
  final String favoritelistId;
  final String productId;


  FavoritelistModel({
    required this.favoritelistId,
    required this.productId,
  });
}