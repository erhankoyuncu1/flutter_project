import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel with ChangeNotifier{
  final String userId, userName, userImage, userEmail, userPassword;
  final Timestamp createdAt;
  final List userCart, userFavoriteList, userAddressList;
  final bool isAdmin;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.createdAt,
    required this.userFavoriteList,
    required this.userCart,
    required this.userAddressList,
    required this.userPassword,
    required this.isAdmin
  });

}