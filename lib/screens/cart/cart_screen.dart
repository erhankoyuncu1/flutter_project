import 'package:flutter/material.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/screens/cart/checkout_screen.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/cart/cart_widget.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.fetchCartFromFirestore();
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final bool isEmpty = cartProvider.items.isEmpty;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return isEmpty
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset(
              AssetsManager.bagImages4,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: AppNameText(
          titleText: "Cart",
          titleColor: Colors.green,
        ),
      ),
      body: EmptyPageWidget(
        imagePath: AssetsManager.bagImages2,
        subTitle: "Cart is Empty",
        buttonText: "Go Shop",
      ),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset(
              AssetsManager.bagImages4,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: AppNameText(
          titleText: "Cart (${cartProvider.totalItems})",
          titleColor: Colors.green,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await cartProvider.clearCart();
            },
            child: const Text(
              "Clear All",
              style: TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            onPressed: () async {
              await cartProvider.clearCart();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final productId =
                cartProvider.items.keys.toList()[index];
                final quantity =
                cartProvider.items.values.toList()[index];
                return CartWidget(productId: productId, quantity: quantity);
              },
            ),
          ),
          CartCheckout(),
        ],
      ),
    );
  }
}
