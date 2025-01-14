import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/widgets/admin/product/product_widget.dart';
import 'package:flutter_project/widgets/loading_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/titles/app_name_text_widget.dart';
import '../../widgets/titles/subtitle_text_widget.dart';

class AllProductScreen extends StatefulWidget {
  static const routName = "/AllProductScreen";
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  late TextEditingController searchTextController;
  bool hasText = false;
  bool _isLoading = false;

  @override
  void initState(){
    getAllProduct();
    super.initState();
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

  Future<void> getAllProduct() async{
    final productProivder = Provider.of<ProductProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      await productProivder.fetchProducts();
    }catch(error){
      Fluttertoast.showToast(msg: error.toString());
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
    List<ProductModel> productList = productProvider.getProducts;

    return LoadingWidget(
      isLoading: _isLoading,
      child:  GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            leading: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(
                    icon: const Icon(IconlyLight.arrowLeft2,color: Colors.blue),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }
                )
            ),
            title: AppNameText(titleText:"All Products", titleColor: Colors.blue,)
        ),
        body: productList.isEmpty ?
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
                    return  AdminProductWidget(
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
