import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constans/app_constans.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/widgets/categories_widget.dart';
import 'package:flutter_project/widgets/product/top_products_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/title/app_name_text_widget.dart';
import '../widgets/title/title_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const AppNameText(
            fontSize: 20,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Text(
                    themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Switch(
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: size.height*0.25,
                child: ClipRRect(
                  child: Swiper(
                    itemCount: AppConstans.bannerImages.length,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          activeColor: Colors.purple,
                        )
                    ),
                    itemBuilder: (BuildContext context, int index){
                      return Image.asset(
                        AppConstans.bannerImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const TitleTextWidget(
                label: "Top Products",
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: size.height*0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index){
                    return TopProductsWidget();
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const TitleTextWidget(
                label: "Categories",
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              const SizedBox(
                height: 25,
              ),
              GridView.count(
                crossAxisCount:4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                    AppConstans.categories.length,
                        (index) {
                      return CategoriesWidgets(
                          name: AppConstans.categories[index].name,
                          imageUrl: AppConstans.categories[index].imageUrl
                      );
                    }
                )
              ),
            ],
          ),
        )

      )
    );
  }
}
