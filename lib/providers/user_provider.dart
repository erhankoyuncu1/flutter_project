import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;

  UserModel? get getUserModel {
    return userModel;
  }

  // Tüm kullanıcıları getirme
  Future<List<UserModel>> fetchAllUsers() async {
    List<UserModel> userList = [];
    try {
      final usersCollection =
      await FirebaseFirestore.instance.collection("users").get();

      for (var doc in usersCollection.docs) {
        final data = doc.data();
        userList.add(UserModel(
          userId: data['userId'] ?? '',
          userName: data['userName'] ?? '',
          userImage: data['userImage'] ?? '',
          userEmail: data['userEmail'] ?? '',
          userPassword: data['userPassword'] ?? '',
          isAdmin: data['isAdmin'] ?? false,
          createdAt: data['createdAt'] ?? Timestamp.now(),
          userCart: List<Map<String, dynamic>>.from(data['userCart'] ?? []),
          userFavoriteList:
          List<String>.from(data['userFavoriteList'] ?? []),
          userAddressList:
          List<String>.from(data['userAddressList'] ?? []),
          userViewedList:
          List<String>.from(data['userViewedList'] ?? []),
        ));
      }
    } on FirebaseException catch (error) {
      debugPrint("Firebase error: ${error.message}");
      Fluttertoast.showToast(
        msg: "Failed to fetch users: ${error.message}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (error) {
      debugPrint("Error: $error");
      Fluttertoast.showToast(
        msg: "An error occurred while fetching users.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    return userList;
  }

  // Kullanıcı ID'ye göre kullanıcıyı getirme
  Future<UserModel?> fetchUserInfoById(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (!userDoc.exists) return null;

      final data = userDoc.data()!;
      userModel = UserModel(
        userId: data['userId'] ?? '',
        userName: data['userName'] ?? '',
        userImage: data['userImage'] ?? '',
        userEmail: data['userEmail'] ?? '',
        userPassword: data['userPassword'] ?? '',
        isAdmin: data['isAdmin'] ?? false,
        createdAt: data['createdAt'] ?? Timestamp.now(),
        userCart: List<Map<String, dynamic>>.from(data['userCart'] ?? []),
        userFavoriteList:
        List<String>.from(data['userFavoriteList'] ?? []),
        userViewedList:
        List<String>.from(data['userViewedList'] ?? []),
        userAddressList:
        List<String>.from(data['userAddressList'] ?? []),
      );
      return userModel;
    } on FirebaseException catch (error) {
      debugPrint("Firebase error: ${error.message}");
      Fluttertoast.showToast(
        msg: "Failed to fetch user by ID: ${error.message}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (error) {
      debugPrint("Error: $error");
      Fluttertoast.showToast(
        msg: "An error occurred while fetching user by ID.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    return null;
  }

  // Yeni kullanıcı ekleme
  Future<void> addUser(UserModel newUser) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(newUser.userId)
          .set(newUser.toMap());

      Fluttertoast.showToast(
        msg: "User added successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } on FirebaseException catch (error) {
      debugPrint("Firebase error: ${error.message}");
      Fluttertoast.showToast(
        msg: "Failed to add user: ${error.message}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (error) {
      debugPrint("Error: $error");
      Fluttertoast.showToast(
        msg: "An error occurred while adding the user.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Kullanıcı güncelleme
  Future<void> updateUser(UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userModel.userId)
          .update(userModel.toMap());

      Fluttertoast.showToast(
        msg: "User updated successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM
      );
    } catch (error) {
      debugPrint("Error updating user: $error");
      Fluttertoast.showToast(
        msg: "An error occurred while updating the user.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Kullanıcı giriş
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        return await fetchUserInfoById(user.uid);
      }
    } on FirebaseAuthException catch (error) {
      debugPrint("FirebaseAuth error: ${error.message}");
      Fluttertoast.showToast(
        msg: "Login failed: ${error.message}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (error) {
      debugPrint("Error: $error");
      Fluttertoast.showToast(
        msg: "An error occurred during login.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    return null;
  }
}
