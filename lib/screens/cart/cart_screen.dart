import 'package:flutter/material.dart';
import 'package:flutter_project/providers/cart_provider.dart';
import 'package:flutter_project/screens/cart/checkout_screen.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/cart/cart_widget.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final bool isEmpty = cartProvider.items.isEmpty;

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
          )),
      body: Visibility(
          child: EmptyPageWidget(
            imagePath: AssetsManager.bagImages2,
            subTitle: "Cart is Empty",
            buttonText: "Go Shop",
          )),
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
            onPressed: () {
              cartProvider.clearCart();
            },
            child: const Text(
              "Clear All",
              style: TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            onPressed: () {
              cartProvider.clearCart();
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
                final cartItem = cartProvider.items.values.toList()[index];
                return CartWidget(cartItem: cartItem);
              },
            ),
          ),
          CartCheckout(),
        ],
      ),
    );
  }
}
