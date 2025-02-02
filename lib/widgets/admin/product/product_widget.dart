import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/screens/admin/edit_upload_product_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/product_model.dart';
import '../../../providers/product_provider.dart';
import '../../titles/subtitle_text_widget.dart';
import '../../titles/title_text_widget.dart';

class AdminProductWidget extends StatefulWidget {
    const AdminProductWidget({
      super.key,
      required this.productId,
    });

  final String productId;

  @override
  State<AdminProductWidget> createState() => _AdminProductWidgetState();
}

class _AdminProductWidgetState extends State<AdminProductWidget> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);
    return FutureBuilder<ProductModel?>(
        future: productProvider.fetchProductByProductId(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    strokeWidth: 6,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 18, color: Colors.purple),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No product found'));
          } else {
            final product = snapshot.data!;
            return product == null
            ? SizedBox.shrink()
            : Padding(
          padding: EdgeInsets.all(1.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return EditUploadProductScreen(
                      productModel: product,
                    );
                  }
                )
              );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FancyShimmerImage(
                      imageUrl: product.productImage,
                      height: size.height * 0.2,
                      width: size.width * 0.2,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TitleTextWidget(label: product.productTitle),
                        )
                      ],
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: SubTitleTextWidget(
                                label: "price: \$${product.productPrice}",
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                    height: 25,
                    ),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}
