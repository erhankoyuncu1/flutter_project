import 'package:flutter/material.dart';
import 'package:flutter_project/screens/cart/checkout_screen.dart';
import 'package:flutter_project/widgets/cart_widget.dart';
import 'package:flutter_project/widgets/empty_card.dart';
import 'package:flutter_project/widgets/title_text.dart';
import 'package:flutter_project/services/assets_manager.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return isEmpty ?
    Scaffold (
      body: Visibility(
        visible: isEmpty,
          child: EmptyCard(
              imagePath: AssetsManager.bagImages2,
              subTitle: "Card is Empty",
              buttonText: "Go Shopp")
      )
    ):
    Scaffold(
      bottomSheet: CartCheckout(),
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
        title: const TitleTextWidget(label: "Cart (7)",
          fontSize: 20,
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
    );
  }
}
