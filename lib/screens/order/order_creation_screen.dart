import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/models/product_model.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/providers/order_provider.dart';
import 'package:flutter_project/providers/product_provider.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/order_model.dart';
import '../../models/address_model.dart';
import '../../models/user_model.dart';
import '../../providers/address_provider.dart';
import '../../providers/user_provider.dart';

class OrderCreationScreen extends StatefulWidget {
  static const routName = "OrderCreationScreen";
  const OrderCreationScreen({super.key});

  @override
  State<OrderCreationScreen> createState() => _OrderCreationScreenState();
}

class _OrderCreationScreenState extends State<OrderCreationScreen> {
  late String selectedAddressId;
  List<AddressModel> userAddresses = [];
  PaymentMethod selectedPaymentMethod = PaymentMethod.creditCard;
  bool isLoading = true;

  Future<void> fetchUserAddresses() async {
    try {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final UserModel? user = await userProvider.fetchUserInfoById(userId);
      if (user == null) {
        throw Exception("User not found.");
      }

      await addressProvider.fetchCurrentUserAddresses(user.userAddressList);
      userAddresses = addressProvider.addresses;

      final defaultAddress = userAddresses.firstWhere(
            (address) => address.isActive == 'true',
        orElse: () => userAddresses.first,
      );
      selectedAddressId = defaultAddress.id;
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error fetching addresses: ${err.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createOrder() async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final userId = FirebaseAuth.instance.currentUser!.uid;

      double totalPrice = await cartProvider.totalPrice;
      final products = cartProvider.items.entries
          .map((entry) => {
        'productId': entry.key,
        'quantity': entry.value,
      })
          .toList();

      final orderModel = OrderModel(
        id: DateTime.now().toString(),
        userId: userId,
        price: totalPrice,
        address: selectedAddressId,
        orderStatus: OrderStatus.pending,
        orderDate: Timestamp.now(),
        deliveryDate: null,
        products: products,
        paymentMethod: selectedPaymentMethod,
        isPaid: false,
      );

      await orderProvider.addOrder(orderModel);

      await cartProvider.clearCart();

      Fluttertoast.showToast(
        msg: "Order created successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error creating order: ${e.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserAddresses();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userAddresses.isEmpty) {
      return const Scaffold(
        body: Center(
          child: SubTitleTextWidget(label:"No addresses found.",color: Colors.purple, fontSize: 22, fontWeight: FontWeight.w700,),
        ),
      );
    }

    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context,listen: false);
    final cartItems = cartProvider.items;
    return Scaffold(
      appBar: AppBar(
        title: AppNameText(titleText: 'Order Creation'),
        backgroundColor: ThemeData.light().scaffoldBackgroundColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple,size: 28,),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleTextWidget(label: 'Delivery Address',
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.purple,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedAddressId,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black),
                  items: userAddresses.map((address) {
                    return DropdownMenuItem<String>(
                      value: address.id,
                      child: SubTitleTextWidget(label: '${address.title} - ${address.fullAddress}',color: Colors.purple, fontWeight: FontWeight.w600,),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedAddressId = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              SubTitleTextWidget(label: 'Payment Method',
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.purple,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<PaymentMethod>(
                  value: selectedPaymentMethod,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black),
                  items: const [
                    DropdownMenuItem(
                      value: PaymentMethod.creditCard,
                      child: SubTitleTextWidget(label:'Credit Card',color: Colors.purple, fontWeight: FontWeight.w600,),
                    ),
                    DropdownMenuItem(
                      value: PaymentMethod.cashOnDelivery,
                      child: SubTitleTextWidget(label: 'Cash on Delivery',color: Colors.purple, fontWeight: FontWeight.w600),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              const SubTitleTextWidget(label: 'Order Summary',
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.purple,
              ),
              const SizedBox(height: 8),
              if (cartItems.isNotEmpty)
          Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: cartItems.entries.map((entry) {
          return FutureBuilder<ProductModel?>(
            future: productProvider.fetchProductByProductId(entry.key),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                ProductModel product = snapshot.data!;
                String productName = product.productTitle;
                double price = product.productPrice;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Ürün adı
                      Expanded(
                        child: Text(
                          productName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        '${entry.value} x ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('Product not found');
              }
            },
          );
        }).toList(),
      ),
    ),

    const SizedBox(height: 16),
                    FutureBuilder<double>(
                      future: cartProvider.totalPrice,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return SubTitleTextWidget(label: 'Total: \$${snapshot.data!.toStringAsFixed(2)}',
                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple,
                          );
                        } else {
                          return const Text('No data available');
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: createOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple, // Button background color
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:  Center(
                        child: SubTitleTextWidget(label: 'Create Order',
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
                        ),
                      )
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
