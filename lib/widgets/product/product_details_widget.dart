import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/constans/app_constans.dart';
import 'package:flutter_project/widgets/title/app_name_text_widget.dart';
import 'package:flutter_project/widgets/title/subtitle_text_widget.dart';
import 'package:flutter_project/widgets/title/title_text_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class ProductDetailsWidget extends StatefulWidget {
  static const routName = "/ProductDetailsSecreen";
  const ProductDetailsWidget({super.key});

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
        icon: const Icon(IconlyLight.arrowLeft2)),
        title: AppNameText(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: FancyShimmerImage(
                alignment: Alignment.center,
                imageUrl: AppConstans.imageUrl,
                height: size.height*0.25,
                width: size.width,
                errorWidget: Icon(Icons.broken_image, size: 50),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start  ,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text("title " *25,
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                color: Colors.green
                            ),
                          ),
                        )
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: SubTitleTextWidget(
                          label: "\$ 16.00",
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                iconColor: themeProvider.getIsDarkTheme ? Colors.white : Colors.yellow
                              ),
                              icon: const Icon(IconlyLight.heart),
                              label:
                                Text("Add to favorites",
                                  style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              onPressed: (){},
                            ),
                          )
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                iconColor: Colors.white
                              ),
                              icon: const Icon(Icons.shopping_cart_outlined),
                              label:
                                Text("Add to cart",
                                  style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              onPressed: (){},
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleTextWidget(label: "About Product"),
                        SubTitleTextWidget(label: "Computer stuffs"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child:  SubTitleTextWidget(
                      label: " A computer is an electronic device that processes data and performs tasks according to a set of instructions called programs. It operates using hardware components such as a central processing unit (CPU), memory (RAM), storage devices (e.g., hard drives or SSDs), and input/output devices like keyboards, mice, and screens. Computers can execute complex calculations, store vast amounts of information, and communicate over networks. They are powered by software, including operating systems like Windows or macOS, and applications for tasks such as word processing, gaming, and web browsing. Modern computers range from desktops and laptops to mobile devices and supercomputers, transforming industries and daily life by enabling automation, connectivity, and advanced problem-solving. ",
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
