import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/heart_button_widget.dart';
import 'package:flutter_project/widgets/product/product_details_widget.dart';
import 'package:flutter_project/widgets/title/subtitle_text_widget.dart';

import '../../constans/app_constans.dart';

class TopProductsWidget extends StatelessWidget {
  const TopProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () async{
          await Navigator.pushNamed(context, ProductDetailsWidget.routName);
        },
        child: SizedBox(
          width: size.width*0.8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FancyShimmerImage(
                    imageUrl: AppConstans.imageUrl,
                    height: size.height*0.1,
                    width: size.width*0.2,
                  ),
                )
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Title "*18,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const FittedBox(
                      child: SubTitleTextWidget(
                        label: "\$16.00",
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(iconColor: Colors.pinkAccent,),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.shopping_cart_outlined,color: Colors.blue,)
                          )
                        ],
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
