import 'package:flutter/material.dart';
import 'package:flutter_project/screens/order/order_details_screen.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel order;

  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);
    final productId = order.products.isNotEmpty ? order.products[0]['productId'] : null;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderDetailsScreen.routName,arguments: order.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FutureBuilder<ProductModel?>(
                  future: productId != null ? productProvider.fetchProductByProductId(productId) : Future.value(null),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error);
                    } else if (snapshot.hasData && snapshot.data != null) {
                      final product = snapshot.data!;
                      return Image.network(
                        product.productImage,
                        width: size.width * 0.25,
                        height: size.width * 0.25,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Placeholder();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleTextWidget(
                            label: "Order Address",
                            fontSize: 14,
                          ),
                          SubTitleTextWidget(
                            label: order.orderDate.toDate().toString().split(" ")[0],
                            fontSize: 12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleTextWidget(
                            label: "Price: \$${order.price.toStringAsFixed(2)}",
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                          SubTitleTextWidget(label: order.orderStatus.name)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
