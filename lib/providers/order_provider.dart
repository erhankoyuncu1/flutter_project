  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
  import '../models/order_model.dart';

  class OrderProvider with ChangeNotifier {
    final List<OrderModel> _orders = [];

    List<OrderModel> get orders => [..._orders];

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final userId = FirebaseAuth.instance.currentUser!.uid;

    Future<void> fetchOrders() async {
      try {
        final QuerySnapshot snapshot = await _firestore
            .collection('orders')
            .get();

        final List<OrderModel> loadedOrders = snapshot.docs.map((doc) {
          return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        _orders.clear();
        _orders.addAll(loadedOrders);
        notifyListeners();
      } catch (error) {
        debugPrint('Error fetching orders: $error');
      }
    }

    Future<void> fetchOrdersByUserId() async {
      try {
        final QuerySnapshot snapshot = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .get();

        final List<OrderModel> loadedOrders = snapshot.docs.map((doc) {
          return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
        _orders.clear();
        _orders.addAll(loadedOrders);
        notifyListeners();
      } catch (error) {
        debugPrint('Error fetching orders for user $userId: $error');
      }
    }

    Future<void> addOrder(OrderModel newOrder) async {
      try {
        final docRef = _firestore.collection('orders').doc(newOrder.id);

        await docRef.set(newOrder.toMap());
        _orders.insert(0, newOrder);
        notifyListeners();
      } catch (error) {
        debugPrint('Error adding order: $error');
      }
    }

    Future<void> updateOrder(String orderId, OrderStatus newStatus) async {
      try {
        final docRef = _firestore.collection('orders').doc(orderId);

        await docRef.update({'orderStatus': newStatus.name});

        final index = _orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          _orders[index] = OrderModel(
            id: _orders[index].id,
            userId: _orders[index].userId,
            price: _orders[index].price,
            address: _orders[index].address,
            orderStatus: newStatus,
            orderDate: _orders[index].orderDate,
            deliveryDate: _orders[index].deliveryDate,
            products: _orders[index].products,
            paymentMethod: _orders[index].paymentMethod,
            isPaid: _orders[index].isPaid,
          );
          notifyListeners();
        }
      } catch (error) {
        debugPrint('Error updating order: $error');
      }
    }

    Future<void> deleteOrder(String orderId) async {
      try {
        await _firestore.collection('orders').doc(orderId).delete();

        _orders.removeWhere((order) => order.id == orderId);
        notifyListeners();
      } catch (error) {
        debugPrint('Error deleting order: $error');
      }
    }

    OrderModel? getOrderById(String orderId) {
      try {
        return _orders.firstWhere((order) => order.id == orderId);
      } catch (e) {
        debugPrint('Order not found: $orderId');
        return null;
      }
    }


    Future<void> updateOrderByAdmin({
      required String orderId,
      OrderStatus? orderStatus,
      bool? isPaid,
      Timestamp? deliveryDate,
      String? address,
      double? price,
      PaymentMethod? paymentMethod,
    }) async {
      try {
        final docRef = _firestore.collection('orders').doc(orderId);

        final Map<String, dynamic> updatedFields = {};
        if (orderStatus != null) updatedFields['orderStatus'] = orderStatus.name;
        if (isPaid != null) updatedFields['isPaid'] = isPaid;
        if (deliveryDate != null) updatedFields['deliveryDate'] = deliveryDate;
        if (address != null) updatedFields['address'] = address;
        if (price != null) updatedFields['price'] = price;
        if (paymentMethod != null) updatedFields['paymentMethod'] = paymentMethod.name;

        if (updatedFields.isNotEmpty) {
          await docRef.update(updatedFields);

          final index = _orders.indexWhere((order) => order.id == orderId);
          if (index != -1) {
            _orders[index] = OrderModel(
              id: _orders[index].id,
              userId: _orders[index].userId,
              price: price ?? _orders[index].price,
              address: address ?? _orders[index].address,
              orderStatus: orderStatus ?? _orders[index].orderStatus,
              orderDate: _orders[index].orderDate,
              deliveryDate: deliveryDate ?? _orders[index].deliveryDate,
              products: _orders[index].products,
              paymentMethod: paymentMethod ?? _orders[index].paymentMethod,
              isPaid: isPaid ?? _orders[index].isPaid,
            );
            notifyListeners();
          }
        }
      } catch (error) {
        debugPrint('Error updating order by admin: $error');
      }
    }

  void cancelOrder(String orderId) {
      Fluttertoast.showToast(msg: "This function is not available yet.",backgroundColor: Colors.red,textColor: Colors.white);
  }
  }
