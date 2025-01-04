import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.bgColor =  Colors.transparent,
    this.iconColor = Colors.red,
    this.size = 20,
    this.label = ""
  });

  final Color bgColor;
  final Color iconColor;
  final double  size;
  final String label;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor,
        shape: BoxShape.circle,
      ),
      child: Row(
        children: [
          Title(color: Colors.white, child: Text(widget.label)),
          IconButton(
            style: IconButton.styleFrom(
              elevation: 10,
            ),
            icon: Icon(IconlyLight.heart,color: widget.iconColor,size: widget.size,),
            onPressed: (){},),
        ],
      )

    );
  }
}
