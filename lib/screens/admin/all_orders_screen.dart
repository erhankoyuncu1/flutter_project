import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_project/providers/theme_provider.dart';
import 'package:flutter_project/services/app_functions.dart';
import 'package:flutter_project/services/assets_manager.dart';
import 'package:flutter_project/widgets/admin/order/order_widget.dart';
import 'package:flutter_project/widgets/empty_page_widget.dart';
import 'package:flutter_project/widgets/titles/title_text_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';

class AllOrdersScreen extends StatefulWidget {
  static const routName = "/AllOrdersScreen";
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  Future<void> loadOrders() async{
    try{
      final orderProvider = Provider.of<OrderProvider>(context,listen: false);
      await orderProvider.fetchOrders();
    }
    catch(err) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: err.toString(),
        function: (){}
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            if(Navigator.canPop(context)){
              Navigator.pop(context);
            }
          },
          icon: const Icon(IconlyLight.arrowLeft2, color: Colors.purple,)
        ),
        title: TitleTextWidget(label: "All Orders")
      ),
      body: orderProvider.orders.isEmpty ?
        EmptyPageWidget(
          imagePath: AssetsManager.error,
          subTitle: "No order yet"
        )
        :ListView.separated(
          itemCount: orderProvider.orders.length,
          separatorBuilder: (BuildContext context, index){
            return Divider(
              color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
            );
          },
        itemBuilder: (context, index) {
          final order = orderProvider.orders[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: OrderWidget(order: order),
          );
        }
      )
    );
  }
}
