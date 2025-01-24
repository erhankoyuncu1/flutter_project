import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/order_widget.dart';
import '../widgets/empty_page_widget.dart';
import '../widgets/titles/app_name_text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../services/assets_manager.dart';

class OrdersScreen extends StatefulWidget {
  static const routName = "/OrdersScreen";
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  Future<void> loadOrders() async{
    final orderProvider = Provider.of<OrderProvider>(context,listen: false);
    await orderProvider.fetchOrdersByUserId();
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(IconlyLight.arrowLeft2, color: Colors.purple),
        ),
        title: const AppNameText(
          titleText: "All Orders",
        ),
      ),
      body: orderProvider.orders.isEmpty
          ? EmptyPageWidget(
        imagePath: AssetsManager.noOrder,
        subTitle: "There is no any order",
        titleColor: const Color.fromARGB(255, 52, 122, 175),
        buttonVisibility: false,
      )
          : ListView.separated(
        itemBuilder: (context, index) {
          final order = orderProvider.orders[index];
          return Padding(
            padding: const EdgeInsets.all(12),
            child: OrderWidget(order: order),
          );
        },
        separatorBuilder: (BuildContext context, index) {
          return Divider(
            color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
          );
        },
        itemCount: orderProvider.orders.length,
      ),
    );
  }
}
