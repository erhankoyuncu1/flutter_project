import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/title/subtitle_text_widget.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
    this.pickedImage,
    required this.function
  });

  final  XFile? pickedImage;
  final  Function function;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: ClipRRect(
            child: pickedImage == null ?
            SubTitleTextWidget(label: "No selected image !")
            :Image.file(
              File(pickedImage!.path),
              fit: BoxFit.fill,
            )
          ),
        ),
        Positioned(
          child: Material(
            borderRadius: BorderRadius.circular(15),
            color: Colors.purple,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: (){
                function();
              },
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.image, size: 15,),
              ),
            ),
          ),
        )
      ],
    );
  }
}
