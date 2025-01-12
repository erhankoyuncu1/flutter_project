import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProvider with ChangeNotifier{
  UserModel? userModel;
  UserModel? get getUserModel{
    return userModel;
  }
  //giriş yapan kullanıcıyı getirme
  Future<UserModel?> fetchUserInfo() async{
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user == null){
      return null;
    }
    String uid = user.uid;
    try{
      final userDoc =await FirebaseFirestore.instance.collection("users").doc(uid).get();

      final userDocDict = userDoc.data() as Map<String, dynamic>?;
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userImage: userDoc.get("userImage"),
        userEmail: userDoc.get("userEmail"),
        userPassword: userDoc.get("userPassword"),
        createdAt: userDoc.get("createdAt"),
        isAdmin: userDoc.get("isAdmin"),

        userCart: userDocDict!.containsKey("userCart") ?   userDoc.get("userCart") :[],
        userFavoriteList: userDocDict.containsKey("userFavoriteList") ?   userDoc.get("userFavoriteList") :[],
        userAddressList: userDocDict.containsKey("userAddressList") ?   userDoc.get("userAddressList") :[],
      );
      return userModel;
    } on FirebaseException catch(error){
      rethrow;
    }catch(error){
      rethrow;
    }
  }

  //Kullanıcı id ile kullanıcı getirme
  Future<UserModel?> fetchUserInfoById( String uid) async{
    try{
      final userDoc =await FirebaseFirestore.instance.collection("users").doc(uid).get();

      final userDocDict = userDoc.data() as Map<String, dynamic>?;
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userImage: userDoc.get("userImage"),
        userEmail: userDoc.get("userEmail"),
        userPassword: userDoc.get("userPassword"),
        createdAt: userDoc.get("createdAt"),
        isAdmin: userDoc.get("isAdmin"),

        userCart: userDocDict!.containsKey("userCart") ?   userDoc.get("userCart") :[],
        userFavoriteList: userDocDict.containsKey("userFavoriteList") ?   userDoc.get("userFavoriteList") :[],
        userAddressList: userDocDict.containsKey("userAddressList") ?   userDoc.get("userAddressList") :[],
      );
      return userModel;
    } on FirebaseException catch(error){
      rethrow;
    }catch(error){
      rethrow;
    }
  }
  
  /*Future<void> updateOldUsers() async{
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final allUsers = await usersCollection.get();

    for(var userDoc in allUsers.docs) {
      if(!userDoc.data().containsKey('userAddressList')) {
        await usersCollection.doc(userDoc.id).update({
          "userAddressList": []
        });
      }
    }

    Fluttertoast.showToast(msg: "Users updating successful");
  }*/

  // Tüm kullanıcıları getirme
  Future<List<UserModel?>> fetchAllUsers() async {
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
          isAdmin: data['isAdmin'] ?? '',
          createdAt: data['createdAt'] ?? Timestamp.now(),
          userCart: data.containsKey("userCart") ? data['userCart'] : [],
          userFavoriteList:
          data.containsKey("userFavoriteList") ? data['userFavoriteList'] : [],
          userAddressList:
          data.containsKey("userAddressList") ? data['userAddressList'] : [],
        ));
      }
    } on FirebaseException catch (error) {
      debugPrint("Hata: ${error.message}");
    } catch (error) {
      debugPrint("Hata: $error");
    }
    return userList;
  }

  // Kullanıcı adı ile getirme
  Future<List<UserModel?>> findByUserName(String searchText) async {
    List<UserModel> filteredUserList = [];

    try {
      final usersCollection =
      await FirebaseFirestore.instance.collection("users").get();

      for (var doc in usersCollection.docs) {
        final data = doc.data();
        if (data['userName']
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          filteredUserList.add(UserModel(
            userId: data['userId'] ?? '',
            userName: data['userName'] ?? '',
            userImage: data['userImage'] ?? '',
            userEmail: data['userEmail'] ?? '',
            userPassword: data['userPassword'] ?? '',
            isAdmin: data['isAdmin'] ?? '',
            createdAt: data['createdAt'] ?? Timestamp.now(),
            userCart: data.containsKey("userCart") ? data['userCart'] : [],
            userFavoriteList:
            data.containsKey("userFavoriteList") ? data['userFavoriteList'] : [],
            userAddressList:
            data.containsKey("userAddressList") ? data['userAddressList'] : [],
          ));
        }
      }
    } catch (error) {
      debugPrint("Error: $error");
    }

    return filteredUserList;
  }

  // kullanıcı güncelleme
  Future<void> updateUser(UserModel userModel) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(userModel.userId).set({
        "userId": userModel.userId,
        "userName": userModel.userName,
        "userImage": userModel.userImage ?? "",
        "userEmail": userModel.userEmail,
        "userPassword": userModel.userPassword,
        "createdAt": userModel.createdAt ?? Timestamp.now(),
        "isAdmin": userModel.isAdmin,
        "userCart": userModel.userCart ?? [],
        "userFavoriteList": userModel.userFavoriteList ?? [],
        "userAddressList": userModel.userAddressList ?? [],
      });

      Fluttertoast.showToast(
        msg: "User updated successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } on FirebaseException catch (error) {
      debugPrint("Firebase error: ${error.message}");
      Fluttertoast.showToast(
        msg: "Failed to update user: ${error.message}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (error) {
      debugPrint("Error: $error");
      Fluttertoast.showToast(
        msg: "An error occurred while updating the user.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

}