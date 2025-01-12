import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constans/app_constans.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FancyShimmerImage(
              imageUrl: AppConstans.imageUrl,
              width: size.width * 0.25,
              height: size.width * 0.25,
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: TitleTextWidget(label: "Order addrress",fontSize: 14,),
                      ),
                      SubTitleTextWidget(label: "Order date", fontSize: 12,)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      TitleTextWidget(label: "Price:",fontSize: 14,),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: SubTitleTextWidget(label: "\$16",fontSize: 12,color: Colors.green,fontWeight: FontWeight.w600,),
                      )
                    ],
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
