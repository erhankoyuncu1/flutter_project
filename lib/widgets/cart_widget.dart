import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/widgets/quantity_bottom_sheet.dart';
import 'package:flutter_project/widgets/subtitle_text.dart';
import 'package:flutter_project/widgets/title_text.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

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
                            IconButton(
                              onPressed: (){}, icon: const Icon(IconlyLight.heart,size: 20,)
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const SubTitleTextWidget(label: "16.00\$", color: Colors.green,),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () async{
                            await  showModalBottomSheet(
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(40), bottom: Radius.zero)
                              ),
                              context: context,
                              builder: (context){
                                return const QuantityBottomSheet();
                              }
                            );
                          },
                          icon: const Icon(IconlyLight.arrowDown2),
                          label: Text("Quantity",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),

                            )
                          ),
                        )
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
