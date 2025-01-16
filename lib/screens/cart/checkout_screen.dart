import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartCheckout extends StatelessWidget {
  const CartCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Color.fromARGB(255, 11, 55, 14)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      child: TitleTextWidget(
                        label:
                        "Total ${cartProvider.items.length} product - ${cartProvider.totalItems} items ",
                      ),
                    ),
                    FutureBuilder<double>(
                      future: cartProvider.totalPrice, // Asenkron işlem burada çağrılır
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SubTitleTextWidget(
                            label: "Loading...",
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          );
                        } else if (snapshot.hasError) {
                          return SubTitleTextWidget(
                            label: "Error: ${snapshot.error}",
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          );
                        } else if (snapshot.hasData) {
                          return SubTitleTextWidget(
                            label: "Check: \$${snapshot.data!.toStringAsFixed(2)}",
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          );
                        } else {
                          return SubTitleTextWidget(
                            label: "No data",
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

