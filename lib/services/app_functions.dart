import 'package:flutter/material.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';

class AppFunctions {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required String subtitle,
    bool isError = true,
    required Function function
  }) async{
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isError ? AssetsManager.error : AssetsManager.warning,
                height: 60,
                width: 60,
              ),
              const SizedBox(
                height: 20,
              ),
              SubTitleTextWidget(label: subtitle, fontWeight: FontWeight.w600),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    child: TextButton(onPressed: (){
                      Navigator.pop(context);
                    },
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green
                        ),
                        label: Text("Yes",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    )
                  ),
                  Visibility(
                    child: TextButton(onPressed: (){
                      Navigator.pop(context);
                    },
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        label: Text("No",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    )
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFct,
    required Function galleryFct,
    required Function removeFct
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: TitleTextWidget(label: "Choose option"),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: (){
                    cameraFct();
                    if(Navigator.canPop(context)){
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  onPressed: (){
                    galleryFct();
                    if(Navigator.canPop(context)){
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.browse_gallery_outlined),
                  label: const Text("Gallery"),
                ),
                TextButton.icon(
                  onPressed: (){
                    removeFct();
                    if(Navigator.canPop(context)){
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text("Remove"),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}