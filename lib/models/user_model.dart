import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String userName;
  final String userImage;
  final String userEmail;
  final String userPassword;
  final bool isAdmin;
  final Timestamp createdAt;
  final List<Map<String, dynamic>> userCart;
  final List<String> userFavoriteList;
  final List<String> userAddressList;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.userPassword,
    required this.isAdmin,
    required this.createdAt,
    required this.userCart,
    required this.userFavoriteList,
    required this.userAddressList,
  });

  // fromMap Fonksiyonu
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPassword: map['userPassword'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      userCart: List<Map<String, dynamic>>.from(map['userCart'] ?? []),
      userFavoriteList: List<String>.from(map['userFavoriteList'] ?? []),
      userAddressList: List<String>.from(map['userAddressList'] ?? []),
    );
  }

  // toMap Fonksiyonu
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
      'userCart': userCart,
      'userFavoriteList': userFavoriteList,
      'userAddressList': userAddressList,
    };
  }
}
