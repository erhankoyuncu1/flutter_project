import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/models/product_model.dart';
import 'package:flutter_project/providers/viewed_list_provider.dart';
import 'package:flutter_project/widgets/buttons/heart_button_widget.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
import 'package:flutter_project/widgets/quantity_bottom_sheet.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartWidget extends StatefulWidget {
  final String productId;
  final int quantity;

  const CartWidget({
    super.key,
    required this.productId,
    required this.quantity,
  });

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  ProductModel? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (productDoc.exists) {
        setState(() {
          _product = ProductModel.fromMap(productDoc.data()!);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching product details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedListProvider = Provider.of<ViewedListProvider>(context);
    Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_product == null) {
      return const SizedBox(); // Ürün bulunamadıysa boş widget döndür.
    }

    return FittedBox(
      child: InkWell(
        onTap: () {
          viewedListProvider.addProduct(_product!.productId);
          Navigator.pushNamed(
            context,
            ProductDetailsWidget.routName,
            arguments: _product!.productId,
          );
        },
        child: IntrinsicWidth(
          stepHeight: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FancyShimmerImage(
                    imageUrl: _product!.productImage,
                    height: size.height * 0.09,
                    width: size.width * 0.2,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.4,
                            child: TitleTextWidget(
                              label: _product!.productTitle,
                              fontSize: 16,
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  cartProvider.removeItem(widget.productId);
                                },
                                icon: const Icon(IconlyLight.closeSquare, size: 20),
                              ),
                              HeartButtonWidget(productId: widget.productId),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SubTitleTextWidget(
                            label: "\$${_product!.productPrice.toStringAsFixed(2)}",
                            color: Colors.green,
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await showModalBottomSheet(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(40),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return QuantityBottomSheet(
                                    availableQuantity: _product!.productQuantity.toInt(),
                                    quantity: widget.quantity,
                                    onQuantityChanged: (newQuantity) {
                                      cartProvider.updateQuantity(
                                        widget.productId,
                                        newQuantity,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(IconlyLight.arrowDown2),
                            label: Text(
                              "Quantity: ${widget.quantity}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
