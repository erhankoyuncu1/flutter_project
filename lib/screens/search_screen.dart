import 'dart:developer';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/title/app_name_text_widget.dart';
import 'package:flutter_project/widgets/Product/product_widget.dart';
import '../services/assets_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  bool hasText = false;

  @override
  void initState(){
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

  @override
  Widget build(BuildContext context) {
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
          title: AppNameText(titleText: "Search product", titleColor: Colors.orange,)
        ),
        body: Padding(
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
                  log("submitted text is $value");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: DynamicHeightGridView(
                  mainAxisSpacing: 12,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  itemCount: 50,
                  builder: (context, index){
                    return const ProductWidget();
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

