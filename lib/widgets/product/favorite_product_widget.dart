import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../heart_button_widget.dart';
import '../title/subtitle_text_widget.dart';
import '../title/title_text_widget.dart';

class FavoriteProductWidget extends StatelessWidget {
  const FavoriteProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
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
                  imageUrl: "http://192.168.96.139:8000/images/bag/bag2.png",
                  height: size.height*0.09,
                  width: size.width*0.2,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IntrinsicWidth(
                  child:  Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width*0.4,
                              child: TitleTextWidget(
                                label: "label " *8,
                                fontSize: 16,
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: (){}, icon: const Icon(IconlyLight.closeSquare,size: 20),
                                ),
                                HeartButtonWidget()
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SubTitleTextWidget(label: "16.00\$", color: Colors.green,),
                          ],
                        ),
                      ]
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
