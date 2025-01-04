import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/title/subtitle_text_widget.dart';

class QuantityBottomSheet extends StatelessWidget {
  const QuantityBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 8,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey,

          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 25,
            itemBuilder: (context, index){
              return InkWell(
                hoverColor: Colors.black,
                onTap: (){
                  log("index $index");
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubTitleTextWidget(label: "${index+1}"),
                  ),
                ),
              );
            }
          )
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
