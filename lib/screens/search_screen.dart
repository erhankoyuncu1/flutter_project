import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/product_model.dart';
import 'package:flutter_project/services/app_functions.dart';
import 'package:flutter_project/widgets/Product/product_widget.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:flutter_project/widgets/titles/app_name_text_widget.dart';
import 'package:flutter_project/widgets/titles/subtitle_text_widget.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../services/assets_manager.dart';

class SearchScreen extends StatefulWidget {
  static const routName = "/SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  bool hasText = false;
  List<ProductModel> productList = [];
  String? filteredCategoryName;
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    loadProducts();
    searchTextController = TextEditingController();
    searchTextController.addListener((){
      setState(() {
        hasText = searchTextController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose(){
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];

  Future<void> loadProducts()  async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    try{
      setState(() {
        _isLoading = true;
      });
      await productProvider.fetchProducts();
      productList = productProvider.getProducts;
      filteredCategoryName = ModalRoute.of(context)!.settings.arguments as String?;
      productList = filteredCategoryName == null ?
      productProvider.getProducts
          : productProvider.findByCategory(categoryName: filteredCategoryName!);
    }
    catch(err){
      AppFunctions.showErrorOrWarningDialog(context: context, subtitle: err.toString(), function: (){});
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Image.asset(
                AssetsManager.search,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: AppNameText(titleText: filteredCategoryName ?? "Search product", titleColor: Colors.orange,)
        ),
        body: LoadingWidget(
          isLoading: _isLoading,
          child: productList.isEmpty ?
            const Center(
              child: SubTitleTextWidget(label: "No Product"),
            )
            :Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: searchTextController,
                    decoration: InputDecoration(
                      hintText: "search something...",
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: hasText ? GestureDetector(
                        onTap: (){
                          setState(() {
                            FocusScope.of(context).unfocus();
                            searchTextController.clear();
                          });
                        },
                        child: const Icon(Icons.clear),
                      )
                      : null,
                    ),
                    onChanged: (value) {

                    },
                    onSubmitted: (value){
                      setState(() {
                        productListSearch = productProvider.findByProductName
                          (searchText: searchTextController.text,
                            searchingProductList: productList);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  if(searchTextController.text.isNotEmpty && productListSearch.isEmpty)...[
                    const Center(
                      child: SubTitleTextWidget(label: "No Products found"),
                    )
                  ],

                  Expanded(
                    child: DynamicHeightGridView(
                      mainAxisSpacing: 12,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      itemCount: searchTextController.text.isNotEmpty ?
                        productListSearch.length :
                        productList.length,
                      builder: (context, index){
                        return  ProductWidget(
                          productId: searchTextController.text.isNotEmpty ? productListSearch[index].productId
                          :productList[index].productId);
                      },
                    )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}

