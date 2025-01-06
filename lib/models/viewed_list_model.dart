import 'package:flutter/cupertino.dart';

class ViewedListModel with ChangeNotifier {
  final String viewedListId;
  final String productId;


  ViewedListModel({
    required this.viewedListId,
    required this.productId,
  });
}