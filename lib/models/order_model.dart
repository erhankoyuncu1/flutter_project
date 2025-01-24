import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  preparing,
  shipped,
  onTheWay,
  delivered,
  cancelled,
  pending,
}

enum PaymentMethod {
  creditCard,
  cashOnDelivery,
}

class OrderModel {
  final String id;
  final String userId;
  final String address;
  final double price;
  final OrderStatus orderStatus;
  final Timestamp orderDate;
  final Timestamp? deliveryDate;
  final List<Map<String, dynamic>> products;
  final PaymentMethod paymentMethod;
  final bool isPaid;

  OrderModel({
    required this.id,
    required this.userId,
    required this.price,
    required this.address,
    required this.orderStatus,
    required this.orderDate,
    this.deliveryDate,
    required this.products,
    required this.paymentMethod,
    required this.isPaid,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      orderStatus: OrderStatus.values.byName(map['orderStatus'] ?? 'preparing'),
      orderDate: map['orderDate'] ?? Timestamp.now(),
      deliveryDate: map['deliveryDate'],
      products: List<Map<String, dynamic>>.from(map['products'] ?? []),
      paymentMethod: PaymentMethod.values.byName(map['paymentMethod'] ?? 'creditCard'),
      isPaid: map['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'price': price,
      'address': address,
      'orderStatus': orderStatus.name,
      'orderDate': orderDate,
      'deliveryDate': deliveryDate,
      'products': products,
      'paymentMethod': paymentMethod.name,
      'isPaid': isPaid,
    };
  }
}
