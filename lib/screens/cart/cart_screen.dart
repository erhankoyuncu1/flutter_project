import 'package:flutter/material.dart';
import 'package:flutter_project/screens/cart/checkout_screen.dart';
import 'package:flutter_project/widgets/title/app_name_text_widget.dart';
import 'package:flutter_project/widgets/cart/cart_widget.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/services/assets_manager.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return isEmpty ?
    Scaffold (
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
          )
        ),
      body: Visibility(
        child: EmptyPageWidget(
            imagePath: AssetsManager.bagImages2,
            subTitle: "Cart is Empty",
            buttonText: "Go Shopp")
      )
    ):
    Scaffold(
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
          titleText: "Cart (7)",
          titleColor: Colors.green,
        ),
        actions: [
          Text("clear all"),
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.delete, color: Colors.red,)
          )
        ],
      ),
      body: ListView.builder(itemBuilder: (context, index){
        return CartWidget();
      }),
      bottomSheet: CartCheckout(),
    );
  }
}
