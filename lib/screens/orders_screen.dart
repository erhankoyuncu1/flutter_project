import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/widgets/order_widget.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/titles/app_name_text_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routName = "/OrdersScreen";
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
            icon: const Icon(IconlyLight.arrowLeft2,color: Colors.purple,)),
        title: AppNameText(
          titleText: "All Orders",
        ),
      ),
      body: isEmpty ?
        EmptyPageWidget(
          imagePath: AssetsManager.noOrder,
          subTitle: "There is no any order",
          buttonText: "Go Home Page",
          titleColor: Color.fromARGB(255, 52, 122, 175),
          buttonVisibility: false,
        )
        : ListView.separated(
          itemBuilder: (context, index){
            return const Padding(
              padding: EdgeInsets.all(12),
              child: OrderWidget(),
            );
          },
          separatorBuilder: (BuildContext context, index){
            return Divider(
              color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
            );
          },
          itemCount: 5
        )
    );
  }
}
