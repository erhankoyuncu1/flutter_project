import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/subtitle_text.dart';
import 'package:flutter_project/widgets/title_text.dart';

class CartCheckout extends StatelessWidget {
  const CartCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Color.fromARGB(255, 11, 55, 14))
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: kBottomNavigationBarHeight +10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      FittedBox(
                         child: TitleTextWidget(label: "Total 7 product"),                         
                       ),
                      SubTitleTextWidget(label: "check: \$ 112",color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18,)
                    ],
                  ),
                ),
                ElevatedButton(onPressed: (){}, child: const Text("Checkout",style: TextStyle(color: Colors.green),))
              ],
            ),
          )
      ),
    );
  }
}
