import 'dart:developer';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/heart_button_widget.dart';
import 'package:flutter_project/widgets/title/subtitle_text_widget.dart';

import '../title/title_text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: GestureDetector(
        onTap: () {
          log("to do add navigate");
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(
                imageUrl: "http://192.168.96.139:8000/images/bag/bag2.png",
                height: size.height*0.2,
                width: size.width*0.2,
              )
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
                    child: TitleTextWidget(label: "product name")
                  ),
                  Flexible(
                    flex: 2,
                    child: HeartButtonWidget(iconColor: Colors.red,)
                  ),
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
                  const Flexible(
                    flex: 1,
                    child: SubTitleTextWidget(label: "price: \$16",color: Colors.green,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: (){

                        },
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.shopping_cart_outlined,color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
