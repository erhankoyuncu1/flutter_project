import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/address_model.dart';

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;
  String? _userId = FirebaseAuth.instance.currentUser?.uid;

  // Tüm adresleri Firestore'dan getir ve listeyi güncelle
  Future<void> fetchCurrentUserAddresses(List<String> addressIds) async {
    try {
      if (addressIds.isEmpty) {
        _addresses = [];
        notifyListeners();
        return;
      }

      // Adres ID'lerine göre sorgu yap
      final snapshot = await FirebaseFirestore.instance
          .collection('addresses')
          .where(FieldPath.documentId, whereIn: addressIds)
          .get();

      // Gelen verileri modele dönüştür
      _addresses = snapshot.docs
          .map((doc) => AddressModel.fromMap(doc.data()))
          .toList();

      notifyListeners();
    } catch (error) {
      print("Adresleri getirme hatası: $error");
    }
  }


  // Yeni bir adres ekle
  Future<void> addAddress(AddressModel address) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('addresses')
          .doc(address.id);

      await docRef.set(address.toMap());

      // Adresi kullanıcıya bağla
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update({
        'userAddressList': FieldValue.arrayUnion([address.id]),
      });

      _addresses.add(address);
      notifyListeners();
    } catch (error) {
      print("Adres ekleme hatası: $error");
    }
  }

  // Mevcut bir adresi güncelle
  Future<void> updateAddress(AddressModel updatedAddress) async {
    try {
      await FirebaseFirestore.instance
          .collection('addresses')
          .doc(updatedAddress.id)
          .update(updatedAddress.toMap());

      final index = _addresses.indexWhere((addr) => addr.id == updatedAddress.id);
      if (index != -1) {
        _addresses[index] = updatedAddress;
        notifyListeners();
      }
    } catch (error) {
      print("Adres güncelleme hatası: $error");
    }
  }

  // Bir adresi sil
  Future<void> deleteAddress(String addressId) async {
    try {
      await FirebaseFirestore.instance.collection('addresses').doc(addressId).delete();

      // Kullanıcıdan adresi kaldır
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update({
        'userAddressList': FieldValue.arrayRemove([addressId]),
      });

      _addresses.removeWhere((addr) => addr.id == addressId);
      notifyListeners();
    } catch (error) {
      print("Adres silme hatası: $error");
    }
  }

  // Kullanıcının aktif adresini belirle
  Future<void> setActiveAddress(String addressId) async {
    try {
      // Diğer tüm adresleri pasif yap
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

      // Seçilen adresi aktif yap
      final updatedAddress = _addresses.firstWhere((addr) => addr.id == addressId);
      final activeAddress = AddressModel(
        id: updatedAddress.id,
        title: updatedAddress.title,
        fullAddress: updatedAddress.fullAddress,
        isActive: true,
      );
      await updateAddress(activeAddress);
    } catch (error) {
      print("Aktif adres belirleme hatası: $error");
    }
  }
}
