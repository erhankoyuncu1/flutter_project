import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/address_model.dart';

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> fetchCurrentUserAddresses(List<String> addressIds) async {
    try {
      if (addressIds.isEmpty) {
        _addresses = [];
        notifyListeners();
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('addresses')
          .where(FieldPath.documentId, whereIn: addressIds)
          .get();

      _addresses = snapshot.docs
          .map((doc) => AddressModel.fromMap(doc.data()))
          .toList();

      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Couldn't Fetch Addresses: $error");
    }
  }

  Future<AddressModel?> fetchAddressById(String id) async{
    try{
      final snapshot = await FirebaseFirestore.instance
          .collection('addresses')
          .doc(id)
          .get();

      if(snapshot.exists) {
        return AddressModel(
          id: id,
          title: snapshot['title'],
          fullAddress: snapshot['fullAddress'],
          isActive: snapshot['isActive']
        );
      }
    }
    catch(err){
      Fluttertoast.showToast(msg: err.toString());
    }
    return null;
  }

  Future<void> addAddress(AddressModel address) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('addresses')
          .doc(address.id);

      await docRef.set(address.toMap());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update({
        'userAddressList': FieldValue.arrayUnion([address.id]),
      });

      _addresses.add(address);
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Couldn't Add Address: $error");
    }
  }

  Future<void> updateAddress(AddressModel updatedAddress) async {
    try {
      await FirebaseFirestore.instance
          .collection('addresses')
          .doc(updatedAddress.id)
          .update(updatedAddress.toMap());

      final index = _addresses.indexWhere((address) => address.id == updatedAddress.id);
      if (index != -1) {
        _addresses[index] = updatedAddress;
        notifyListeners();
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Couldn't Update Address: $error");
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await FirebaseFirestore.instance.collection('addresses').doc(addressId).delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update({
        'userAddressList': FieldValue.arrayRemove([addressId]),
      });

      _addresses.removeWhere((address) => address.id == addressId);
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Couldn't Delete Address: $error");
    }
  }

  Future<void> setActiveAddress(String addressId) async {
    try {
      for (final address in _addresses) {
        if (address.isActive && address.id != addressId) {
          final updatedAddress = AddressModel(
            id: address.id,
            title: address.title,
            fullAddress: address.fullAddress,
            isActive: false,
          );
          await updateAddress(updatedAddress);
        }
      }

      final updatedAddress = _addresses.firstWhere((address) => address.id == addressId);
      final activeAddress = AddressModel(
        id: updatedAddress.id,
        title: updatedAddress.title,
        fullAddress: updatedAddress.fullAddress,
        isActive: true,
      );
      await updateAddress(activeAddress);
    } catch (error) {
      Fluttertoast.showToast(msg: "Couldn't make active address: $error");
    }
  }
}
