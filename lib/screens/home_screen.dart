import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constans/app_constans.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product/top_products_widget.dart';
import '../widgets/titles/app_name_text_widget.dart';
import '../widgets/titles/title_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox.shrink(),
        titleSpacing: -10,
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
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
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
              const SizedBox(height: 20),
              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  child: Swiper(
                    itemCount: AppConstans.bannerImages.length,
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.purple,
                      ),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstans.bannerImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const TitleTextWidget(
                label: "Top Products",
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * 0.2,
                child: productProvider.getProducts.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.getProducts.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: productProvider.getProducts[index],
                      child: const TopProductsWidget(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              const TitleTextWidget(
                label: "Categories",
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              const SizedBox(height: 25),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  AppConstans.categories.length,
                      (index) {
                    return CategoriesWidgets(
                      name: AppConstans.categories[index].name,
                      imageUrl: AppConstans.categories[index].imageUrl,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
